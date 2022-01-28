/*  Simple finite state automaton which "parses" and stores grammars
    @(#) $Id: ProtoParser.java 427 2010-06-01 09:08:17Z gfis $
    2017-05-28: javadoc 1.8
    2016-05-30: store rules
    2005-01-27, Georg Fischer
*/
/*
 * Copyright 2006 Dr. Georg Fischer <punctum at punctum dot kom>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.teherba.jextra.parse;
import  org.teherba.jextra.parse.BaseParser;
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Table;
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.scan.Scanner;
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.trans.SemAction;
import  org.apache.logging.log4j.Logger;
import  org.apache.logging.log4j.LogManager;

/** A simple {@link BaseParser Parser} realized by a finite state automaton
 *  which reads and stores a {@link Grammar}.
 *  The syntax of such a grammar is defined by the MetaGrammar, which defines
 *  a variant of Backus-Naur-Form (BNF).
 *  @author Dr. Georg Fischer
 */
public class ProtoParser extends BaseParser {
    public final static String CVSID = "@(#) $Id: ProtoParser.java 427 2010-06-01 09:08:17Z gfis $";

    /** logger for debug and error situations */
    private static Logger log = LogManager.getLogger(ProtoParser.class);

    /** Current state of the Finite State Automaton
     *  used to parse the meta grammar
    */
    private int finState = FINISH;
    /* codes for <em>finState</em> */
    private static final int LEFT_SIDE      =  0;
    private static final int EQUALS         =  1;
    private static final int MEMBERETIES    =  2;
    private static final int SKIP_TO_PERIOD =  3;
    private static final int TRANSFORMATIONS=  4;
    private static final int NUMBER         =  5;
    private static final int FINISH         =  6;
    private static final String STATE_NAMES[] = // keep in parallel with codes above
                          { "LEFT_SIDE"
                          , "EQUALS"
                          , "MEMBERETIES"
                          , "SKIP_TO_PERIOD"
                          , "TRANSFORMATIONS"
                          , "NUMBER"
                          , "FINISH"
                          };

    /** left side of current production */
    private Symbol leftSide;

    /** Constructor - allocate new {@link Table}, {@link Grammar} and {@link Scanner} objects
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public ProtoParser(String fileName) {
        super(fileName);
    } // Constructor(String)

    /** Initialize the parser by reading
     *  a scanner interface
     */
    protected void initialize() {
        symbol = scanner.scan(); // terminal or (later) also: nonterminal
        while (symbol != scanner.sub && ! scanner.isAtEof()) { // read the scanner interface (1st line), up to '['
            if (Parm.isDebug(3)) {
                    System.out.println(Parm.getIndent()
                            + "<scan finState=\"" + STATE_NAMES[finState] + "\">"
                            + symbol.toString()
                            + "</scan>");
            } // debug 3
            // process the (rest of the) interface to the scanner
            symbol = scanner.scan(); // '[' is consumed
        } // while rest
        symbol   = scanner.scan(); // the axiom is always the first left hand side
        leftSide = symbol;
        grammar.setAxiom(symbol);
        table.initialize();
        finState = LEFT_SIDE;
    } // initialize

    /** Stores a production for later parser table generation
     *  @param prod production to be stored
     */
    private void store(Production prod) {
        prod.closeMembers();
        prod.closeSemantics();
        grammar.insert(prod);
        System.out.println(Parm.getIndent() + "<store>"
                + prod.getLeftSide().legible() +  " =" + prod.legible() + "</store>");
    } // store

    /** Determines the next state of the parser.
     *  @return true (false) if the sentence of the language
     *  was (not yet) accepted
     */
    protected boolean transition() {
        boolean accepted = false;
        switch (finState) {
            case LEFT_SIDE:
                leftSide = symbol; // remember it for productions after '|'
                prod = new Production(leftSide);
                finState = EQUALS;
                break;
            case EQUALS:
                if (symbol == scanner.equals) {
                    finState = MEMBERETIES;
                } else {
                    error(finState, symbol.getEntity());
                    finState = SKIP_TO_PERIOD;
                }
                break;
            case MEMBERETIES:
                if (false) {
                } else if (category == scanner.identifier.getCategory()) {
                    // add nonterminal to right side of production
                    prod.addMember(symbol);
                } else if (category == scanner.string.getCategory()) {
                    // convert string to terminal symbol, and add it
                    symbol = scanner.getSymbolList().mapSpecial(symbol.getEntity());
                    prod.addMember(symbol);
                } else if (symbol == scanner.period) {
                    // terminate this production
                    store(prod);
                    finState = LEFT_SIDE;
                } else if (symbol == scanner.bus) {
                    // terminate this production
                    store(prod);
                    finState = FINISH;
                    accepted = true;
                } else if (symbol == scanner.bar) {
                    // terminate this production
                    store(prod);
                    finState = MEMBERETIES;
                    prod = new Production(leftSide);
                } else if (symbol == scanner.arrow) {
                    // terminate this production
                    finState = TRANSFORMATIONS;
                } else {
                    error(finState, symbol.getEntity());
                }
                break;
            case TRANSFORMATIONS: // only of the form "# number"
                if (symbol == scanner.sharp) {
                    finState = NUMBER;
                } else {
                    error(finState, symbol.getEntity());
                }
                break;
            case NUMBER:
                if (category == scanner.number.getCategory()) {
                    prod.addSemantic(new SemAction(SemAction.BUILT_IN
                            , symbol.getNumericalValue()));
                    // readOff = false;
                    finState = MEMBERETIES; // cheat, but okay if no members follow
                } else {
                    error(finState, symbol.getEntity());
                }
                break;
            case SKIP_TO_PERIOD:
                if (symbol == scanner.period) {
                    finState = LEFT_SIDE;
                }
                break;
            default:
                error(finState, symbol.getEntity());
                break;
        } // switch finState
        return accepted;
    } // transition

    /** Test Frame: read a grammar and print all productions
     *  @param args command line arguments:
     *  <ol>
     *  <li>input filename</li>
     *  </ol>
     */
    public static void main (String args[]) {
        ProtoParser parser = new ProtoParser(args[0]);
        parser.parse();
    } // main

} // ProtoParser
