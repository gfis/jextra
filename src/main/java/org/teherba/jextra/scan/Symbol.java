/*  Attributes of parser symbols (identifiers, number, strings ...)
    of the (programming) language
    @(#) $Id: Symbol.java 427 2010-06-01 09:08:17Z gfis $
    2017-05-28: javadoc 1.8
    2016-05-29: Java generics
    2005-01-24, Georg Fischer: copied from LineReader.java
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

package org.teherba.jextra.scan;
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.gener.SymbolQueue;
import  java.util.Iterator;
import  java.util.TreeSet;

/** Attributes of parser symbols:
 *  <ul>
 *  <li>identifiers</li>
 *  <li>numbers</li>
 *  <li>strings</li>
 *  <li>interpunctuation</li>
 *  </ul>
 *  @author Dr. Georg Fischer
 */
public class Symbol implements Comparable {
    public final static String CVSID = "@(#) $Id: Symbol.java 427 2010-06-01 09:08:17Z gfis $";

    /** category of the symbol: identfier, number, string, nonterminal
     *  (that is the index of another symbol which was previously
     *  allocated)
     */
    private int category;
    /** denotes the symbol: identifier, nonterminal's name, number value,
     *  string of interpunctuation characters
     */
    private String entity;
    /** internal number of the symbol in a symbol table */
    private int index;
    /** mark bits for set manipulation */
    private int markBits;
    /** set of states reached by this symbol*/
    private TreeSet<State> reachedStates;
    /** rule with this symbol as the left side (for nonterminals, null for terminals) */
    private Rule rule;

    /** No-args Constructor - creates a new symbol
     */
    public Symbol() {
        this(0, "");
    } // Constructor()

    /** Constructor - creates a new symbol with entity
     *  @param ent entity (string) of the symbol
     */
    public Symbol(String ent) {
        this(0, ent);
    } // Constructor(String)

    /** Constructor - creates a new symbol with entity and category
     *  @param ent entity (string) of the symbol
     *  @param cat category of the symbol
     */
    public Symbol(int cat, String ent) {
        category        = cat;
        entity          = ent;
        index           = 0;
        markBits        = 0;
        reachedStates   = new TreeSet<State>();
        rule            = null;
    } // Constructor(int, String)

    /** Gets the category of the symbol: identifier, number etc.
     *  @return codes for identifier, number, string etc.
     */
    public int getCategory() {
        return category;
    } // getCategory

    /** Sets the category of the symbol: identifier, number etc.
     *  @param value category to be set
     */
    public void setCategory(int value) {
        category = value;
    } // setCategory

    /** Gets the entity (string) of the symbol
     *  @return string, content, name of the symbol
     */
    public String getEntity() {
        return entity;
    } // getEntity

    /** Sets the entity (string) of the symbol
     *  @param value string, content, name of the symbol
     */
    public void setEntity(String value) {
        entity = value;
    } // setEntity

    /** Gets the symbol's internal number in a symbol table
     *  @return index in symbol table
     */
    public int getId() {
        return index;
    } // getId

    /** Sets the symbol's internal number in a symbol table
     *  @param id index to be assigned
     */
    public void setId(int id) {
        index = id;
    } // setId

    /** Marks the element as being appended to some queue
     *  @param queue append the element to this queue
     *  @return 0 if the element was not yet marked,
     *  &gt; 0 (= mark bit) value if the element was already queued
     */
    public int mark(SymbolQueue queue) {
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
    public int unmark(SymbolQueue queue) {
        int bit = queue.getBit();
        int result = markBits & bit;
        if (result != 0) {
            markBits -= bit;
        }
        return result;
    } // unmark

    /** Gets rule for which the nonterminal is the left side,
     *  or null if it is a terminal
     *  @return rule for which the symbol is the left side
     */
    public Rule getRule() {
        return rule;
    } // getRule

    /** Sets rule for which the nonterminal is the left side,
     *  (or null if it is a terminal)
     *  @param rule rule to be stored for this left symbol
     */
    public void setRule(Rule rule) {
        this.rule = rule;
    } // setRule

    /** Gets the numerical value from an entities name
     *  @return numerical value of the entity
     */
    public int getNumericalValue() {
        int result = 0;
        try {
            result = Integer.parseInt(entity);
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();
            result = 0;
        }
        return result;
    } // getNumericValue

    /** Appends a reached state to the internal set
     *  @param state state to be appended
     *  @return the number of such reached states previously contained in the state
     */
    public int addReachedState(State state) {
        return reachedStates.add(state) ? 0 : 1;
    } // addReachedState

    /** Removes a reached state from the internal set
     *  @param state state to be removed
     *  @return the number of such reached states previously contained in the state
     */
    public int removeReachedState(State state) {
        return reachedStates.remove(state) ? 1 : 0;
    } // removeReachedState

    /** Iterates over all reached states
     *  @return Iterator for states reached by this symbol
     */
    public Iterator reachedIterator() {
        return reachedStates.iterator();
    } //reachedIterator

    /** Compares this object (symbol1) with the specified object (symbol2)
     *  @param obj2 symbol on the right side
     *  @return -1, 0, +1 if symbol1 &lt; = &gt; symbol2
     */
    public int compareTo(Object obj2) {
        int result = entity.compareTo(((Symbol) obj2).getEntity());
                // order 1 by entities
        if (result == 0) {
            // order 2 by categories
            int cat2 = ((Symbol) obj2).getCategory();
            if (category < cat2) {
                result = -1;
            } else if (category > cat2) {
                result =  1;
            }
            // else 'return' is already 0
        } // discriminate by categories
        return result;
    } // compareTo

    /** Gets the length of the symbol's entity (string)
     *  @return length of string
     */
    public int length() {
        return entity.length();
    } // length

    /** Returns a human readable representation of the object
     *  @return the entity of the symbol, for strings enclosed in single quotes
     */
    public String legible() {
        String result = entity
                .replaceAll("\n", "\\\\n")
                .replaceAll("&", "&amp;")
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                ;
        return Character.isLetterOrDigit(result.charAt(0)) ? result : "\'" + result + "\'";
    } // legible

    /** Returns an XML description of the object
     *  @return XML string representing the object
     */
    public String toString() {
        return "<sym id=\"" + index + "\""
                + " cat=\"" + category + "\">"
                + entity
                .replaceAll("\n", "\\\\n")
                .replaceAll("&", "&amp;")
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                + "</sym>";
    } // toString

    /** Test Frame
     *  @param args commandline arguments
     */
    public static void main (String args[]) {
    } // main

} // Symbol
