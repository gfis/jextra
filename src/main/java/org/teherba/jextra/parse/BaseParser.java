/*  Abstract Parser - for regular or context-free languages
    @(#) $Id: BaseParser.java 427 2010-06-01 09:08:17Z gfis $
    2005-03-02, Georg Fischer
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
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.gener.Table;
import  org.teherba.jextra.scan.Scanner;
import  org.teherba.jextra.scan.Symbol;
import  org.apache.log4j.Logger;

/** Abstract Parser - for regular or context-free languages
 *  @author Dr. Georg Fischer
 */
public class BaseParser {
    public final static String CVSID = "@(#) $Id: BaseParser.java 427 2010-06-01 09:08:17Z gfis $";

    /** logger for debug and error situations */
    private static Logger log = Logger.getLogger(BaseParser.class);

    /** parser {@link Table} with {@link Grammar} and state set */
    protected Table      table;
    /** current state of the push-down automaton */
    protected State      state;
    /** {@link Grammar} of the language to be read in */
    protected Grammar    grammar;
    /** {@link Scanner} which reads the input file */
    protected Scanner    scanner;
    /** category of the currently scanned {@link #symbol} */
    protected int        category;
    /** {@link Symbol} just read by the {@link #scanner} */
    protected Symbol     symbol;
    /** whether the symbol was "comsumed" by a transition */
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
    public BaseParser(Table tab, String fileName) {
        table   = tab;
        grammar = table.getGrammar();
        scanner = grammar.getScanner();
    } // Constructor(Table, String)

    /** Constructor - allocate new {@link Table}, {@link Grammar} and {@link Scanner} objects
     *  @param fileName path/name of the source file, "" = STDIN
     */
    protected BaseParser(String fileName) {
        scanner = new Scanner(Scanner.LANG_BNF, fileName); 
        grammar = new Grammar(scanner);
        table   = new Table(grammar);
    } // Constructor(String)

    /** Gets the grammar associated with the parser's table
     *  @return  grammar associated with the parser's table
     */
    public Grammar getGrammar() {
        return grammar;
    } // getGrammar

    /** Gets the parser's table
     *  @return table with state set and grammar
     */
    public Table getTable() {
        return table;
    } // getTable
    
    /** Reads from input and parses the (next) sentence of the grammar's language.
     *  @return true (false) if the sentence was (not) accepted
     */
    protected boolean parse() { 
        if (Parm.isDebug(1)) {
            System.out.println(Parm.getXMLDeclaration());
            System.out.println("<Parser>");
            Parm.incrIndent();
        }
        state = table.getStartState();
        initialize();
        boolean accepted = loop();
        terminate();
        if (Parm.isDebug(1)) {
            System.out.println(grammar.toString()); 
            System.out.println(Parm.getIndent() + "<legibleGrammar>");
            System.out.println(this.getGrammar().legible());
            System.out.println(Parm.getIndent() + "</legibleGrammar>");
            System.out.println(Parm.getIndent() + "<legibleTable>");
            System.out.println(this.getTable()  .legible());
            System.out.println(Parm.getIndent() + "</legibleTable>");
            Parm.decrIndent();
            System.out.println(Parm.getIndent() + "</Parser>");
        }
        return accepted;
    } // parse
    
    /** May initialize the parser, for example by reading
     *  a scanner interface
     */
    protected void initialize() {   
        symbol = scanner.scan(); // terminal or (later) also: nonterminal
    } // initialize
    
    /** Terminates the parser
     */
    protected void terminate() {    
    } // terminate
    
    /** Reads the input file and parses all symbols;
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
    
    /** Decides whether a scanned symbol is not ignored.
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
    
    /** Determines the next state of the parser. 
     *  This dummy version reads over all symbols without 
     *  any state change.
     *  @return true (false) if the sentence of the language 
     *  was (not yet) accepted  
     */
    protected boolean transition() {
        try {
            if (Parm.isDebug(3)) {
                    System.out.println(Parm.getIndent()
                            + "<scan state=\"" + state.getId() + "\">" 
                            + symbol.toString()
                            + "</scan>");
            }
        } catch (Exception exc) {
            System.err.println("BaseParser.transition: state=" + state + ", symbol=" + symbol);
            System.err.println(exc.getMessage());
            exc.printStackTrace();
        } // try - catch
        return false;
    } // transition
    
    /** Issues a parser error message
     *  @param stateId number of the state which doesn't expect this symbol
     *  @param symbolEntity representation of the offending symbol
     */
    protected void error(int stateId, String symbolEntity) {            
        System.out.println("<error state=\"" + state.getId() 
                + "\" sym=\"" + symbol.getEntity() + "\" />"
                + Parm.getNewline());
    } // error

} // BaseParser
