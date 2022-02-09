/*  LR(1) parser table (states and items)
    @(#) $Id$
    2022-02-10: data structures extracted from Grammar
    2017-05-28: javadoc 1.8
    2005-02-23, Georg Fischer: copied from Grammar.java
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

package org.teherba.jextra.gener;
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.gener.Item;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.ProtoQueue;
import  org.teherba.jextra.gener.ProtoState;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.scan.Symbol;
import  java.util.ArrayList;
import  java.util.HashMap;
import  java.util.Iterator;

/** LR(1) parser table, consisting of
 *  <ul>
 *  <li>a set of <em>State</em>s of the LR(1) <em>Parser</em>, each containing
 *  <li>a set of <em>Item</em>s (marked productions with successor information)
 *  </ul>
 *  @author Georg Fischer
 */
public class StateTable {
    public final static String CVSID = "@(#) $Id$";

    /** List of generated LR(1) parser states */
    private ArrayList<State> states;
    /** States that shift a symbol */
    private HashMap shiftingStates;
    /** underlying grammar */
    private Grammar grammar;
    /** the parser starts in this state */
    private State state2;
    /** the parser finishes in this state */
    private State state3;
    /** set of symbols that should be processed by STACLO */
    private SymbolQueue closeSymbolQueue;

    /** Queue of prototype states */
    private ProtoQueue protos;
    /** Fictitious father of the first prototype state */
    ProtoState proto0;
    /** prototype state with the marker behind the axiom */
    ProtoState proto2;

    /** No-args Constructor - create a new parsing table
     */
    public StateTable() {
        this(new Grammar());
    } // Constructor()

    /** Constructor - create a new state table,
     *  and allocate a tiny initial configuration
     *  @param gram grammar for which to parse
     */
    public StateTable(Grammar gram) {
        grammar             = gram;
        states              = new ArrayList<State>(1024);
        protos              = new ProtoQueue(2048);
        shiftingStates      = new HashMap  (1024);
        closeSymbolQueue    = new SymbolQueue();
    } // Constructor(Grammar)

    /** Allocate a minimal initial configuration by creating:
     *  <ul>
     *  <li>an artificial production: [hyperAxiom = eof axiom eof EOP]
     *  <li>a start state 2 that has the marker before the axiom
     *  <li>a final state 3 that has the marker behind the axiom, and that accepts the latter
     *  </ul>
     *  State 1 is reserved and not used (for historical reasons)
     */
    public void initialize() {
        Symbol eof = grammar.getScanner().endOfFile;
        Symbol hyperAxiom = new Symbol(grammar.getScanner().identifier.getCategory(), "HYPER_AXIOM");
        Production prod1 = new Production(hyperAxiom);
        prod1.addMember(eof);
        prod1.addMember(grammar.axiom);
        prod1.addMember(eof);
        prod1.closeMembers();
        grammar.insert(prod1);
        // state1 is reserved and not used (for historical reasons)
        state2 = allocate(eof);
        state3 = allocate(grammar.axiom);
        state3.addPredecessor(state2);
        state2.addItem(new Item(grammar.axiom, 1, Item.SHIFT , state3, prod1)); // prod1 was null
        state3.addItem(new Item(eof          , 2, Item.ACCEPT, state3, prod1)); // state3 was null

        proto0 = new ProtoState();
        proto2 = new ProtoState(proto0, prod1, prod1.size() - 1, eof, null);
        protos.push(proto2);

    } // initialize

    /** Generate all states of the LR(1) parser PDA.
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
                Object obj = grammar.getRule(markedSymbol);
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

    /** Get the starting state for the parser
     *  @return initial state to start the parser with
     */
    public State getStartState() {
        return state2;
    } // getStartState

    /** Get the grammar associated with the table
     *  @return grammar associated with the table
     */
    public Grammar getGrammar() {
        return grammar;
    } // getGrammar

    /** Add a state to the table.
     *  Former name was STAALL.
     *  @param symbol symbol that was shifted to reach this state
     *  @return new state just added
     */
    public State allocate(Symbol symbol) {
        State result = new State(symbol);
        states.add(result);
        symbol.addReachedState(result);
        return result;
    } // allocate

    /** Get a state from the table
     *  @param id internal number of the state
     *  @return the state with this identification
     */
    public State get(int id) {
        return (State) states.get(id);
    } // get

    // parser table generation methods -----------------------

    /** Edit the grammar by inserting or deleting a single production.
     *  Links to symbols and rules are inserted or deleted.
     *  Former name was PROCHA.
     *  @param operation &gt; 0 - insert; &lt; 0 - delete the productions
     *  @param prod1 production to be inserted or deleted
     *  @return whether the production was found
     */
    public boolean changeProduction(int operation, Production prod1) {
        boolean found = false;
        Iterator iter = grammar.getRule(prod1.getLeftSide()).iterator();
        while (! found && iter.hasNext()) {
            Production prod2 = (Production) iter.next();
            if (prod1.compareTo(prod2) == 0) {
                found = true;
                prod1 = prod2;
            }
        } // while iter

        if (false) {
        } else if (operation > 0) {
            if (! found) { // may insert it
                Symbol leftSide = prod1.getLeftSide();
                // ??? if (rules.
            } else { // insert, but already there
                Parm.alert(16);
            }
            // insertion
        } else if (operation < 0) {
            if (found) { // may delete it
                // ??? deletion not yet
            } else { // delete, but not there
                Parm.alert(54);
            }
            // deletion
        }
        // else operation == 0 -> wrong call
        return found;
    } // changeProduction

    /** Determine the look-ahead symbols
     *  for all productions of all states in the queue
     */
    public void getLookAheadSymbols() {
        // nyi ???
    } // getLookAheadSymbols

    /** (Re-)compute all successors of a set of states
     *  @param states compute the successors for the states in this set
     */
    public void recomputeSuccessorStates(StateQueue states) {
    /*
        while (states.hasNext()) {
            State statea = states.next();
            Iterator itemSet = statea.itemIterator();
            while (itemSet.hasNext()) {
                Item item = (Item) itemSet.next();
                if (item.getMarkedSymbol() != Production.EOP) { // no dummy symbol
                    State statec = item.getSuccessor();
                    boolean changed = true;
                    State stateb = null; // ???
                    Iterator predecessorSet = stateb.predIterator();
                    while (predecessorSet.hasNext()) {
                        // closeSymbolQueue is empty
                        statea = (State) predecessorSet.next();
                        Iterator productionSet = leftSide.getRule().iterator();
                        while (productionSet.hasNext()) {
                            Production prod = (Production) productionSet.next();
                            Symbol firstMember = prod.getFirstMember();
                            if (! statea.hasMarkedSymbol(firstMember)) {
                                closeSymbolQueue.push(firstMember);
                            }
                            statea.addItem(0, prod);
                        } // while productions
                        statea.addClosure(closeSymbolQueue);
                    } // while predecessors
                } // stateb exists
            } // while reached States
        } // while symbols
    */
    } // recomputeSuccessorStates

    /** Delete an item from a state
     *  @param state state from which the item should be deleted
     *  @param position of the marked symbol (starting at 0)
     *  @param prod production; the marker moves over its right side
     *  @return whether state did contain the item
     */
    public boolean deleteItem(State state, int position, Production prod) {
        boolean result = false; // assume failure
        // nyi ???
        return result;
    } // deleteItem

    /** Insert an item in a state.
     *  Former name was ITEINS.
     *  @param state state in which the item should be inserted
     *  @param position of the marked symbol (starting at 0)
     *  @param prod production; the marker moves over its right side
     *  @return whether state did not yet contain the item
     */
    public boolean insertItem(State state, int position, Production prod) {
        boolean result = false; // assume failure
        // nyi ???
        return result;
    } // insertItem

    /** Insert all (new) productions of a symbol in the table.
     *  Former name was SYMINS.
     *  @param queue queue of symbols to be inserted
     *  @return whether the table has changed
     */
    public boolean insertSymbols(SymbolQueue queue) {
        boolean changed = false;
        while (queue.hasNext()) {
            Symbol leftSide = queue.next();
            if (Parm.isDebug(2)) {
                System.out.println("insert left side: " + leftSide.toString());
            }
            Iterator reachedSet = leftSide.reachedIterator();
            while (reachedSet.hasNext()) {
                State stateb = (State) reachedSet.next();
                if (Parm.isDebug(2)) {
                    System.out.println("reached stateb: " + stateb.toString());
                }
                if (stateb != null) {
                    changed = true;
                    Iterator predecessorSet = stateb.predIterator();
                    while (predecessorSet.hasNext()) {
                        // closeSymbolQueue is empty
                        State statea = (State) predecessorSet.next();
                        if (Parm.isDebug(2)) {
                            System.out.println("predecessor statea: " + statea.toString());
                        }
                        Iterator productionSet = leftSide.getRule().iterator();
                        while (productionSet.hasNext()) {
                            Production prod = (Production) productionSet.next();
                            Symbol firstMember = prod.getFirstMember();
                            if (! statea.hasMarkedSymbol(firstMember)) {
                                closeSymbolQueue.push(firstMember);
                            }
                            statea.addItem(0, prod);
                        } // while productions
                        // statea.addClosure(closeSymbolQueue);
                    } // while predecessors
                } // stateb exists
            } // while reached States
        } // while queue
        return changed;
    } // insertSymbols

    /** Propagate the symbols of all states in the queue
     */
    public void putLookAheadSymbols() {
        // nyi ???
    } // putLookAheadSymbols

    /** Garbage collection for items
     */
    public void purgeItems() {
        // nyi ???
    } // purgeItems

    /** Garbage collection for states
     */
    public void purgeStates() {
        // nyi ???
    } // purgeStates

    /** Garbage collection for look-ahead symbols
     */
    public void purgeLookAheadSymbols() {
        // nyi ???
    } // purgeLookAheadSymbols

    /** Try to resolve conflicts
     *  @return number of remaining conflicts
     */
    public int resolveConflicts() {
        int result = 0;
        // nyi ???
        return result;
    } // resolveConflicts

    // generic methods ----------------------------------------------
    /** Return a human readable description of the object
     *  @return list of states
     */
    public String legible() {
        String result = "";
        Iterator<State> iter = states.iterator();
        int index = 0;
        while (iter.hasNext()) {
            if (index > 0) {
                result += Parm.getNewline();
            }
            result += iter.next().legible();
            index ++;
        } // while index
        return result;
    } // legible

    /** Return an XML description of the object
     *  @return list of XML elements representing the states
     */
    public String toString() {
        String result = Parm.getIndent() + "<table>" + Parm.getNewline();
        Parm.incrIndent();
        try {
            Iterator iter = states.iterator();
            while (iter.hasNext()) {
                result += ((State) iter.next()).toString() + Parm.getNewline();
            } // while index
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();
        } // try - catch
        Parm.decrIndent();
        result += Parm.getIndent() + "<protos>" + Parm.getNewline();
        Parm.incrIndent();
        Iterator iter = protos.iterator();
        while (iter.hasNext()) {
            result += ((ProtoState) iter.next()).toString();
        } // while states
        Parm.decrIndent();
        result += Parm.getIndent() + "</protos>" + Parm.getNewline();
        result += Parm.getIndent() + "</table>";
        return result;
    } // toString

    /** Test Frame
     *  @param args commandline arguments
     */
    public static void main (String args[]) {
        int iarg = Parm.addOptions(args);
    } // main

} // StateTable
