/*  Abstract Parser - for regular or context-free languages
    @(#) $Id$
    2022-02-10: LF only, no logging, Table -> StateTable
    2005-03-02, Georg Fischer
*/
/*
 * Copyright 2006 Georg Fischer <dr dot georg dot fischer at gmail dot com>
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
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.gener.StateTable;
import  org.teherba.jextra.scan.Scanner;
import  org.teherba.jextra.scan.Symbol;

/** Abstract Parser - for regular or context-free languages
 *  @author Georg Fischer
 */
public class BaseParser {
    public final static String CVSID = "@(#) $Id$";

    /** parser {@link StateTable} with {@link Grammar} and state set */
    protected StateTable stateTable;
    /** current state of the push-down automaton */
    protected State      state;
    /** {@link Scanner} that reads the input file */
    protected Scanner    scanner;
    /** category of the currently scanned {@link #symbol} */
    protected int        category;
    /** {@link Symbol} just read by the {@link #scanner} */
    protected Symbol     symbol;
    /** whether the symbol was "consumed" by a transition */
    protected boolean    readOff;
    /** current {@link Production} */
    protected Production prod;
    /** current {@link Rule} */
    protected Rule       rule;

    /** Constructor - central LR(1) parsing algorithm
     *  utilizing a push-down stack of states.
     *  @param tab LR(1) table of parser states
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public BaseParser(StateTable tab, String fileName) {
        stateTable = tab;
        scanner    = stateTable.getGrammar().getScanner();
    } // Constructor(StateTable, String)

    /** Constructor - allocate new {@link stateTable}, {@link Grammar} and {@link Scanner} objects
     *  @param fileName path/name of the source file, "" = STDIN
     */
    protected BaseParser(String fileName) {
        scanner     = new Scanner(Scanner.LANG_BNF, fileName);
        stateTable  = new StateTable(new Grammar(scanner));
    } // Constructor(String)

    /** Get the grammar associated with the parser's {@link stateTable}
     *  @return grammar
     */
    public Grammar getGrammar() {
        return stateTable.getGrammar();
    } // getGrammar

    /** Get the parser's {@link stateTable}
     *  @return table with state set and grammar
     */
    public StateTable getStateTable() {
        return stateTable;
    } // getTable

    /** Read from input and parse the (next) sentence of the grammar's language.
     *  @return true (false) if the sentence was (not) accepted
     */
    public boolean parse() {
        String className = this.getClass().getName(); // e.g. org.teherba.jextra.parse.ProtoParser
        int dotPos = className.lastIndexOf('.');
        className = className.substring(dotPos + 1);
        if (Parm.isDebug(1)) {
            System.out.println(Parm.getXMLDeclaration());
            System.out.println("<" + className + ">");
            Parm.incrIndent();
        }
        state = stateTable.getStartState();
        initialize();
        boolean accepted = loop();
        terminate();
        if (Parm.isDebug(1)) {
            System.out.println(getGrammar().toString());
            System.out.println(Parm.getIndent()     + "<legibleGrammar>");
            System.out.println(getGrammar().legible());
            System.out.println(Parm.getIndent()     + "</legibleGrammar>");
            System.out.println(Parm.getIndent()     + "<legibleTable>");
            System.out.println(getStateTable().legible());
            System.out.println(Parm.getIndent()     + "</legibleTable>");
            Parm.decrIndent();
            System.out.println(Parm.getIndent()     + "</" + className + ">");
        }
        return accepted;
    } // parse

    /** May initialize the parser, for example by reading
     *  a scanner interface
     */
    protected void initialize() {
        symbol = scanner.scan(); // terminal or (later) also: nonterminal
    } // initialize

    /** Terminate the parser
     */
    protected void terminate() {
    } // terminate

    /** Read the input file and parse all symbols;
     *  assumes that the first symbol is already read in.
     *  @return true (false) if the sentence was (not) accepted
     */
    protected boolean loop() {
        boolean accepted = false;
        while (! accepted && ! scanner.isAtEof()) {
            boolean readOff = true;
            category = symbol.getCategory();
            if (relevant()) {
                accepted = transition();
            } // if relevant
            if (readOff) {
                symbol = scanner.scan();
            }
        } // while scanning
        return accepted;
    } // loop

    /** Decide whether a scanned symbol is not ignored.
     *  @return true (false) if the symbol is (not) relevant,
     *  that means it is no comment and no whitespace
     */
    protected boolean relevant() {
        return  category != scanner.nestComment.getCategory()
            &&  category != scanner.eolComment .getCategory()
            &&  category != scanner.space      .getCategory()
            &&  category != scanner.endOfLine  .getCategory()
            ;
    } // relevant

    /** Determine the next state of the parser.
     *  This dummy version reads over all symbols without
     *  any state change.
     *  @return true (false) if the sentence of the language
     *  was (not yet) accepted
     */
    protected boolean transition() {
        if (Parm.isDebug(3)) {
                System.out.println(Parm.getIndent()
                        + "<scan state=\"" + state.getId() + "\">"
                        + symbol.toString()
                        + "</scan>");
        }
        return false;
    } // transition

    /** Issue a parser error message
     *  @param stateId number of the state which doesn't expect this symbol
     *  @param symbolEntity representation of the offending symbol
     */
    protected void error(int stateId, String symbolEntity) {
        System.out.println("<error state=\"" + state.getId()
                + "\" sym=\"" + symbol.getEntity() + "\" />"
                + Parm.getNewline());
    } // error

} // BaseParser
