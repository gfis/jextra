/*  A State of the LR(1) Push-Down Automaton
    @(#) $Id: State.java 427 2010-06-01 09:08:17Z gfis $
    2017-05-28: javadoc 1.8
    2016-05-29: Java generics
    2005-02-17, Georg Fischer: copied from Rule.java
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
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.gener.Item;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.gener.StateQueue;
import  java.util.ArrayList;
import  java.util.Iterator;
import  java.util.TreeSet;

/** A State of the LR(1) Push-Down Automaton, consisting of
 *  <ul>
 *  <li>the symbol which "reaches" the state</li>
 *  <li>the list of predecessor states</li>
 *  <li>the list of items in the state</li>
 *  <li>the list of states with the same accessing symbol</li>
 *  <li>various marking bits</li>
 *  </ul>
 *  @author Dr. Georg Fischer
 */
public class State implements Comparable {
    public final static String CVSID = "@(#) $Id: State.java 427 2010-06-01 09:08:17Z gfis $";

    /** the state was reached by this symbol */
    private Symbol reachingSymbol;
    /** set of states which reach this state */
    private TreeSet<State> predecessors;
    /** set of items in this state */
    private TreeSet<Item> items;
    /** mark bits for set manipulation */
    private int markBits;
    /** a unique number assigned to each incarnation */
    private static int currentId = 2;
    /** the unique number assigned to <em>this</em> object */
    private int id;
    
    /** No-args Constructor - creates a new state
     */
    private State() {
        this(null);
    } // Constructor()
    
    /** Constructor - creates a new state 
     *  which is reached by the specified <em>symbol</em>
     *  @param symbol which reaches the state
     */
    public State(Symbol symbol) {
        id              = currentId ++;
        items           = new TreeSet<Item>();
        markBits        = 0;
        predecessors    = new TreeSet<State>();
        reachingSymbol  = symbol;
    } // Constructor(symbol>
    
    /** Gets the unique identification of the state
     *  @return unique sequential number of the state
     */
    public int getId() {
        return id;
    } // getId

    /** Gets the accessing symbol of the state
     *  @return the state is reached when this symbol shifted
     */
    public Symbol getReachingSymbol() {
        return reachingSymbol;
    } // getReachingSymbol

    /** Sets the accessing symbol of the state
     *  @param symbol number of the symbol which reaches the state
     */
    public void setReachingSymbol(Symbol symbol) {
        reachingSymbol = symbol;
    } // setReachingSymbol

    /** Gets the set of items of this state
     *  @return a sorted set of items
     */
/*
    public TreeSet getItems() {
        return items;
    } // getItems
*/    
    /** Appends an item to the internal list of this state
     *  @param item item to be appended
     *  @return the number of such items previously contained in the state
     */
    public int addItem(Item item) {
        item.setState(this);
        // System.err.println("State#addItem, item=" + item);
        return items.add(item) ? 0 : 1;
    } // addItem(Item)

    /** Appends an item to the internal list of this state.
     *  Former name was ITEINS.
     *  @param pos position of the marked symbol (starting at 0)
     *  @param prod production; the marker moves over its right side
     *  @return the number of such items previously contained in the state
     */
    public int addItem(int pos, Production prod) {
        Item item = new Item(pos, prod);
        item.setState(this);
        return items.add(item) ? 0 : 1;
    } // addItem(int, Production)

    /** Removes an item from the internal list of this state
     *  @param item item to be removed
     *  @return the number of such items previously contained in the state
     */
    public int removeItem(Item item) {
        return items.remove(item) ? 1 : 0;
    } // removeItem(Item)

    /** Iterates over all predecessor states
     *  @return Iterator for all predecessors of this state
     */
    public Iterator<Item> itemIterator() {
        return items.iterator();
    } // itemIterator

    /** Marks the element as being appended to some queue
     *  @param queue append the element to this queue
     *  @return 0 if the element was not yet marked,
     *  &gt; 0 (= mark bit) value if the element was already queued
     */
    public int mark(StateQueue queue) {
        int bit = queue.getBit();
        int result = markBits & bit;
        if (result == 0) {
            markBits += bit;
        }
        return result;
    } // mark

    /** Unmarks the element when it is removed from some queue
     *  @param queue remove the element from this queue
     *  @return 0 if the element was not yet marked,
     *  &gt; 0 (= mark bit) value if the element was already queued
     */
    public int unmark(StateQueue queue) {
        int bit = queue.getBit();
        int result = markBits & bit;
        if (result != 0) {
            markBits -= bit;
        }
        return result;
    } // unmark

    /** Appends a predecessor state to the internal list
     *  @param pred state to be appended
     *  @return the number of such predecessors previously contained in the state
     */
    public int addPredecessor(State pred) {
        return predecessors.add(pred) ? 0 : 1;
    } // addPredecessor

    /** Removes a predecessor state from the internal list
     *  @param pred state to be removed
     *  @return the number of such predecessors previously contained in the state
     */
    public int removePredecessor(State pred) {
        return predecessors.remove(pred) ? 1 : 0;
    } // removePredecessor

    /** Iterates over all predecessor states
     *  @return Iterator for all predecessors of this state
     */
    public Iterator<State> predIterator() {
        return predecessors.iterator();
    } // predIterator

    /** Determines whether the state contains an item
     *  which has the specified marked symbol.
     *  This functionality formerly was part of ITEINS.
     *  @param symbol this symbol must be marked in the state
     *  @return whether an item with this marked symbol was found
     */
    public boolean hasMarkedSymbol(Symbol symbol) {
        boolean result = false;
        Iterator iter = items.iterator();
        while (! result && iter.hasNext()) {
            result = ((Item) iter.next()).getMarkedSymbol().equals(symbol);
        } // while iterator
        return result;
    } // hasMarkedSymbol

    /** Adds the closure of a set of symbols to a state, and creates
     *  corresponding new items in the state. 
     *  Assumes that the queue head is reset.
     *  @param symbols queue (set) of symbols to be added with all their
     *  starting symbols
     */
    public void addClosure(SymbolQueue symbols) {
        while (symbols.hasNext()) { // process entire queue
            Symbol symbol = symbols.next();
            Iterator iter = symbol.getRule().iterator();
            while (iter.hasNext()) {
                Production prod = (Production) iter.next();
                Symbol firstMember = prod.getFirstMember();
                if (! this.hasMarkedSymbol(firstMember)) {
                    symbols.push(firstMember);
                }
                this.addItem(0, prod);
            } // while productions
        } // while queue not processed
        symbols.clear(); // free the entire queue, reset all marked bits
    } // addClosure

    /** Computes the transition-function of the pushdown-automaton;  
     *  used by <em>Generator</em> and by <em>Parser</em>.
     *  The parser is in <em>this</em> state
     *  @param symbol the parser has read this symbol
     *  @return the first item in this state with which has <em>symbol</em> marked,
     *  or an ERROR item if no such item exists in the state
     */
    public Item delta(Symbol symbol) {
        Item result = null;
        Iterator iter = itemIterator();
        while (result == null && iter.hasNext()) {
            Item item = (Item) iter.next();
            if (item.getMarkedSymbol().equals(symbol)) { // found
                result = item;
            } // found 
        } // while items
        if (result == null) { // not found
            result = new Item(symbol, 0, Item.ERROR, this, null);
        }
        return result;
    } // delta
    
    /** Searches for a compatible state.
     *  @param itema first item with symbol 'syma' in 'statea' = 'this'.
     *  @return a compatible state, or null if none was found
     */
    public State searchCompatible(Item itema) {
        State stateb = null; // result
        Symbol syma = itema.getMarkedSymbol();
        Iterator reachedSet = syma.reachedIterator();
        while (reachedSet.hasNext()) {
            State stated = (State) reachedSet.next();
            if (stated != null) {
                Iterator predecessorSet = stated.predIterator();
                if (predecessorSet.hasNext()) {
                    State statec = (State) predecessorSet.next();
                    Iterator itemSet = statec.itemIterator();
                    boolean before = true;
                    while (before && itemSet.hasNext()) {
                        Item itemc = (Item) itemSet.next();
                        before = ! itemc.getMarkedSymbol().equals(syma);
                    } // while before
                    
                /* ????
                        Symbol firstMember = prod.getFirstMember();
                        if (! statea.hasMarkedSymbol(firstMember)) {
                            closeSymbolQueue.push(firstMember);
                        }
                        statea.addItem(0, prod);
                    } // while productions
                    statea.addClosure(closeSymbolQueue);
                */
                } // while predecessors
            } // stated exists
        } // while reached States
        Item result = null;
        Iterator iter = itemIterator();
        while (result == null && iter.hasNext()) {
            Item item = (Item) iter.next();
            if (item.getMarkedSymbol().equals(syma)) { // found ??? symbol ???
                result = item;
            } // found 
        } // while items
        if (result == null) { // not found
            result = new Item(syma, 0, Item.ERROR, this, null); // ??? symbol
        }
        return stateb;
    } // searchCOmpatibleState
    
    /** Compares this object (state1) with the specified object (state2).
     *  Ordering is by reaching symbol, item set.
     *  @param obj2 state on the right side
     *  @return -1 | 0 | +1 if state1 &lt; | = | &gt; state2
     */
    public int compareTo(Object obj2) {
        int result = reachingSymbol.compareTo(((State) obj2).getReachingSymbol()); 
                // order 1 by reaching symbol
        if (result == 0) { // order 2 by item set
            Iterator iter1 = items.iterator();
            Iterator iter2 = ((State) obj2).itemIterator();
            while (result == 0 && iter1.hasNext() && iter2.hasNext()) {
                result = ((Item) iter1.next()).compareTo((Item) iter2.next());
            } // while in both item sets
            if (iter1.hasNext()) {
                result = +1;
            } else if (iter2.hasNext()) {
                result = -1;
            }
        } // discriminate by item sets
        return result;
    } // compareTo
    
    /** Returns a human readable description of the object
     *  @return state number and list of all items
     */
    public String legible() {
        String result = getId() + ": ";
        Iterator iter = items.iterator();
        while (iter.hasNext()) {
            result += "\t" + ((Item) iter.next()).legible();
        } // while hasNext
        return result;
    } // legible

    /** Returns an XML description of the object
     *  @return XML element representing the item
     */
    public String toString() {
        String result = Parm.getIndent() + "<state id=\"" + id 
                + "\" reachedBy=\"" + reachingSymbol.getEntity() 
                + "\">" + Parm.getNewline();
        Parm.incrIndent();
        Iterator iter = predecessors.iterator();
        while (iter.hasNext()) {
            result += Parm.getIndent() + "<pred id=\"" + ((State) iter.next()).getId()
                    + "\" />" + Parm.getNewline();
        } // while predecessors
        iter = items.iterator();
        while (iter.hasNext()) {
            result += ((Item ) iter.next()).toString();
        } // while items
        Parm.decrIndent();
        result += Parm.getIndent() + "</state>" + Parm.getNewline();
        return result;
    } // toString

    /** Test Frame
     *  @param args commandline arguments
     */     
    public static void main (String args[]) { 
    } // main

} // State
