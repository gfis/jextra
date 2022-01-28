/*  LR(1) Grammar of a language and corresponding parser table
    @(#) $Id: Grammar.java 427 2010-06-01 09:08:17Z gfis $
    2017-05-28: javadoc 1.8
    2016-05-29: Java generics
    2007-05-08: relaunch with prototype states
    2005-02-10, Georg Fischer: copied from Symbol.java
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

package org.teherba.jextra.gener;
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Item;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.ProtoQueue;
import  org.teherba.jextra.gener.ProtoState;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.scan.Scanner;
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.scan.SymbolList;
import  java.util.ArrayList;
import  java.util.Iterator;
import  java.util.TreeMap;
import  org.apache.logging.log4j.Logger;
import  org.apache.logging.log4j.LogManager;

/** LR(1) Grammar of a language and corresponding parser table, consisting of
 *  <ul>
 *  <li>a set of <em>Rule</em>s consisting of sets of <em>Production</em>s</li>
 *  <li>an <em>axiom</em> - the rule with this <em>Symbol</em>
 *  on the left side is the top-most rule of the grammar</li>
 *  <li>a set of <em>State</em>s of the LR(1) <em>Parser</em></li>
 *  <li>a set of <em>Item</em>s which represents the parser Table
 *  generated from this <em>Grammar</em></li>
 *  </ul>
 *  @author Dr. Georg Fischer
 */
public class Grammar {
    public final static String CVSID = "@(#) $Id: Grammar.java 427 2010-06-01 09:08:17Z gfis $";

    /** log4j logger (category) */
    private static Logger log = LogManager.getLogger(Grammar.class.getName());
    /** a special nonterminal symbol which is the starting point of the grammar */
    public Symbol axiom;
    /** Maps a left side to the corresponding rule (set of productions) */
    private TreeMap<Symbol, Rule> ruleMap;
    /** underlying scanner with symbol table */
    private Scanner scanner;
    /** the top-most production for a fictious hyper-axiom */
    private Production prod1;
    /** the symbol list */
    private SymbolList symbolList;

    /** List of generated LR(1) parser states */
    private ArrayList<State> states;
    /** the parser starts in this state */
    private State state2;
    /** the parser finishes in this state */
    private State state3;

    /** Queue of prototype states */
    private ProtoQueue protos;
    /** Fictitious father of the first prototype state */
    ProtoState proto0;
    /** prototype state with the marker behind the axiom */
    ProtoState proto2;

    /** No-args Constructor - creates a new grammar
     */
    public Grammar() {
        this(new Scanner());
    } // Constructor()

    /** Constructor - creates a new grammar with an associated scanner
     *  @param scan the Scanner to be used
     */
    public Grammar(Scanner scan) {
        scanner     = scan;
        symbolList  = scanner.getSymbolList();
    //  symbolList.put(Production.EOP);
        axiom       = symbolList.put("axiom");
        ruleMap     = new TreeMap<Symbol, Rule>();
        states      = new ArrayList<State>(1024);
        protos      = new ProtoQueue(2048);
    } // Constructor(Scanner)

    /** Allocates a minimal initial configuration with one production:
     *  <ul>
     *  <li>one production: [hyperAxiom = eof axiom eof EOP]</li>
     *  <li>a start state 2 which has the marker before the axiom</li>
     *  <li>a final state 3 which has the marker behind the axiom and accepts it</li>
     *  </ul>
     */
    public void initializeTable() {
        Symbol eof = scanner.endOfFile;
        Symbol hyperAxiom = new Symbol(scanner.identifier.getCategory(), "HYPER_AXIOM");
        Production prod1 = new Production(hyperAxiom);
        // prod1.addMember(eof);
        prod1.addMember(axiom);
        prod1.addMember(eof);
        prod1.closeMembers();
        insert(prod1);
        // state1 is reserved and not used (for historical reasons)
        state2 = allocate(eof);
        state3 = allocate(eof);
        state3.addPredecessor(state2);
        state2.addItem(new Item(axiom, 1, Item.SHIFT , state3, prod1));
        state3.addItem(new Item(eof  , 2, Item.ACCEPT, null,   prod1));
        proto0 = new ProtoState();
        proto2 = new ProtoState(proto0, prod1, prod1.size() - 1, eof, null);
        protos.push(proto2);
    } // initializeTable

    /** Generates all states of the LR(1) parser PDA.
     */
    public void generateStates() {
        ProtoState result = null;
        while (protos.hasNext()) { // process every element of the queue
            ProtoState proto1 = protos.next();
            // System.out.print("qproc: " + proto1.toString());
            int pos1 = proto1.getMarkerPos() - 1; // move leftwards
            if (proto1.getSame() != null) {
                // do not re-evaluate
            } else if (pos1 >= 0) { // still not before 1st member
                Production prod1 = proto1.getProduction();
                ProtoState proto2 = new ProtoState(proto1.getHome(), prod1, pos1, proto1.getLookAhead(), proto1);
                result = protos.merge(proto2);
                proto1.setLeft(result);
                System.out.print("push2: " + proto2.toString());
                Symbol markedSymbol = prod1.getMember(pos1);
                // System.out.println("markd: " + markedSymbol.toString());
                Object obj = ruleMap.get(markedSymbol);
                if (proto2.getSame() == null && obj != null) { // nonterminal
                    Rule rule = (Rule) obj;
                /*
                    System.out.println("expnd: " + markedSymbol.toString()
                        + ", left=" + rule.getLeftSide().getEntity()
                        + ", size=" + rule.size()
                        );
                */
                    Iterator iter = rule.iterator();
                    while (iter.hasNext()) {
                        Production prodm = (Production) iter.next();
                        ProtoState protom = new ProtoState
                                ((pos1 == 0 ? proto1.getHome() : proto2)
                                , prodm, prodm.size(), proto1.getLookAhead(), null);
                        protos.merge(protom);
                        System.out.print("pushm: " + protom.toString());
                    } // while left side
                } else { // terminal
                    proto2.setLookAhead(markedSymbol);
                }
            } else { // before 1st member
            }
        } // while processing queue
    } // generateStates

    /** Gets the starting state for the parser
     *  @return initial state to start the parser with
     */
    public State getStartState() {
        return state2;
    } // getStartState

    /** Gets the axiom (root symbol) of the grammar
     *  @return symbol for the axiom of the grammar
     */
    public Symbol getAxiom() {
        return axiom;
    } // getAxiom

    /** Sets the axiom (root symbol) of the grammar
     *  @param nonterminal symbol for the axiom
     */
    public void setAxiom(Symbol nonterminal) {
        axiom = nonterminal;
    } // setAxiom

    /** Gets the scanner associated with the grammar
     *  @return scanner associated with the grammar
     */
    public Scanner getScanner() {
        return scanner;
    } // getScanner

    /** Gets the symbol list of this grammar object
     *  @return symbol list
     */
    public SymbolList getSymbolList() {
        return symbolList;
    } // getSymbolList

    /** Checks whether the grammar has a rule for a nonterminal
     *  @param leftSide symbol to be checked
     *  @return whether the symbol is a terminal
     */
    public boolean isTerminal(Symbol leftSide) {
        return ruleMap.get(leftSide) != null;
    } // isTerminal

    /** Gets the set of productions for a nonterminal
     *  @param leftSide symbol on the left side of the rule
     *  @return rule, or null if there is none
     */
    public Rule getRule(Symbol leftSide) {
        return ruleMap.get(leftSide);
    } // getRule

    /** Inserts or replaces a rule in the set of rules;
     *  there is no check whether the rule was already stored
     *  @param rule rule to be inserted or replaced
     */
    public void insert(Rule rule) {
        ruleMap.put(rule.getLeftSide(), rule);
        System.out.println("irule: " + rule.getLeftSide().getEntity() + ", size=" + rule.size());
    } // insert

    /** Removes all productions for a nonterminal, and thereby
     *  transforms it into a terminal
     *  @param leftSide symbol on the left side
     *  @return whether the rule was previously stored in the grammar
     *  (that is whether the left side was a nonterminal)
     */
/*
    public boolean removeRule(Symbol leftSide) {
        boolean found = false;
        Rule rule = ruleMap.get(leftSide);
        if (rule != null) {
            found = true;
            ruleMap.remove(leftSide);
        }
        return found;
    } // removeRule
*/

    /** Adds a production to the grammar;
     *  checks whether the production was already stored, and ignores
     *  the call in that case
     *  @param prod production to be added
     *  @return number of productions previously stored in the grammar
     */
    public int insert(Production prod) {
        int found = 0;
        Symbol leftSide = prod.getLeftSide();
        Rule rule = getRule(leftSide);
        if (rule == null) {
            rule = new Rule(leftSide); // was terminal
        } else { // some rule for this left side was previously stored - expand it
            rule.insert(prod);
        } // expand
        ruleMap.put(leftSide, rule);
        leftSide.setRule(rule);
        return rule.insert(prod);
    } // insert(prod)

    /** Removes a production from the grammar;
     *  checks whether the production was already stored, and prints
     *  a message if that was not the case
     *  @param prod production to be removed
     *  @return number of productions previously stored in the grammar
     */
    public int delete(Production prod) {
        int found = 0;
        Rule rule = getRule(prod.getLeftSide());
        if (rule == null) {
            Parm.alert(201); // system error: no rule with left side of production
        } else {
            found = rule.delete(prod);
        }
        return found;
    } // delete(prod)

    /** Adds a state to the table.
     *  Former name was STAALL.
     *  @param symbol symbol that was shifted to reached this state
     *  @return new state just added
     */
    public State allocate(Symbol symbol) {
        State result = new State(symbol);
        states.add(result);
        // symbol.addReachedState(result);
        return result;
    } // allocate

    /** Returns a human readable representation of this grammar
     *  @return lines with all rules, prefixed by dots
     */
    public String legible() {
        String result = "[";
        Iterator<Symbol> siter = symbolList.iterator();
        int index = 0;
        while (siter.hasNext()) {
            Symbol leftSide = siter.next();
            Rule rule = leftSide.getRule();
            if (rule != null) { // nonterminal
                if (index > 0) {
                    result += Parm.newline() + ".";
                }
                result += rule.legible();
                index ++;
            } // nonterminal
        } // while hasNext
        return result + Parm.newline() + "]";
    } // legible

    /** Returns an XML description of this grammar
     *  @return list of XML elements representing the rules
     */
    public String toString() {
        String result = Parm.getIndent() + "<grammar axiom=\"" + axiom.getEntity() + "\">" + Parm.getNewline();
        Parm.incrIndent();
        result += symbolList.toString() + Parm.getNewline();
        result += Parm.getIndent() + "<rules>" + Parm.getNewline();
        Parm.incrIndent();
        try {
            Iterator<Symbol> siter = ruleMap.keySet().iterator();
            while (siter.hasNext()) {
                Symbol leftSide = siter.next();
                result += ruleMap.get(leftSide).toString() + Parm.getNewline();
            } // while index
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();
        } // try - catch
        Parm.decrIndent();
        result += Parm.getIndent() + "</rules>" + Parm.getNewline();

        result += Parm.getIndent() + "<protos>" + Parm.getNewline();
        Parm.incrIndent();
        Iterator iter = protos.iterator();
        while (iter.hasNext()) {
            result += ((ProtoState) iter.next()).toString();
        } // while states
        Parm.decrIndent();
        result += Parm.getIndent() + "</protos>" + Parm.getNewline();

        result += Parm.getIndent() + "<states>" + Parm.getNewline();
        Parm.incrIndent();
        int istate = 0;
        while (istate < states.size()) {
            result += states.get(istate).toString();
            istate ++;
        } // while states
        Parm.decrIndent();
        result += Parm.getIndent() + "</states>" + Parm.getNewline();

        Parm.decrIndent();
        result += Parm.getIndent() + "</grammar>";
        return result;
    } // toString

    /** Test Frame
     *  @param args commandline arguments
     */
    public static void main (String args[]) {
    } // main

} // Grammar
