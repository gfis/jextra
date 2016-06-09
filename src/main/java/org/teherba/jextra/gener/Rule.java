/*  Rule (set of productions) of the grammar
    @(#) $Id: Rule.java 427 2010-06-01 09:08:17Z gfis $
    2016-05-29: Java generics
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
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.scan.Symbol;
import  java.util.ArrayList;
import  java.util.Iterator;

/** Rule of the grammar, consisting of:
 *  <ul>
 *  <li>symbol on the left hand side (nonterminal)</li>
 *  <li>set of productions (symbols on the right side and semantic actions)</li>
 *  </ul>
 *  A symbol points to its rule if the symbol is nonterminal.
 *  @author Dr. Georg Fischer
 */
public class Rule {
    public final static String CVSID = "@(#) $Id: Rule.java 427 2010-06-01 09:08:17Z gfis $";

    /** left hand symbol of the production (nonterminal)
     */
    private Symbol leftSide;

    /** list of productions (empty for terminal left side)
     */
    private ArrayList<Production> productions;

    /** No-args Constructor - creates a new rule
     */
    public Rule() {
        this(new Symbol());
    } // Constructor()

    /** Constructor - creates a new, empty rule
     *  for left side <em>symbol</em>
     *  @param symbol on the left side (nonterminal)
     */
    public Rule(Symbol symbol) {
        leftSide    = symbol;
        leftSide.setRule(this);
        productions = new ArrayList<Production>(4);
    } // Constructor(Symbol>

    /** Gets the left hand side (number of nonterminal symbol)
     *  of the production
     *  @return symbol on the left side of all productions
     */
    public Symbol getLeftSide() {
        return leftSide;
    } // getLeftSide

    /** Sets the left hand side of the production
     *  @param nonterminal symbol on the left side
     */
    public void setLeftSide(Symbol nonterminal) {
        leftSide = nonterminal;
    } // setLeftSide

    /** Gets all productions in this rule
     *  @return productions for the same left side
     */
    public ArrayList<Production> getProductions() {
        return productions;
    } // getProductions

    /** Returns an iterator over all productions of the rule.
     *  @return productions for the same left side
     */
    public Iterator<Production> iterator() {
        return productions.iterator();
    } // iterator

    /** Returns the number of productions for this rule
     *  @return number of productions for the same left side
     */
    public int size() {
        return productions.size();
    } // size

    /** Appends a production unconditionally to the internal list
     *  @param prod production to be appended
     */
    public void add(Production prod) {
        if (prod.getLeftSide() != leftSide) {
            Parm.alert(200);
        }
        productions.add(prod);
    } // add

    /** Inserts a production in the internal list if it is not yet stored
     *  @param prod production to be inserted
     *  @return number of such productions already stored
     */
    public int insert(Production prod) {
        int found = 0; // assume none found
        if (prod.getLeftSide() != leftSide) {
            Parm.alert(200);
        }
        Iterator<Production> iter = productions.iterator();
        while (iter.hasNext()) { // search
            if (iter.next().compareTo(prod) == 0) { // already stored
                found ++;
            } // already stored
        } // while searching
        if (found == 0) {
            productions.add(prod);
        }
        return found;
    } // insert

    /** Removes a production from the internal list
     *  @param prod production to be removed
     *  @return number of such productions which were found
     */
    public int delete(Production prod) {
        int found = 0; // assume none found
        if (prod.getLeftSide() != leftSide) {
            Parm.alert(200);
        }
        int index = 0;
        while (index < productions.size()) { // search
            if (productions.get(index).compareTo(prod) == 0) {
                found ++;
                productions.remove(index); // there might be several ones
            } // found
            index ++;
        } // while searching
        if (productions.size() == 0) { // no productions left
            leftSide.setRule(null); // throw rule, turn symbol into terminal
        } // none left
        return found;
    } // delete

    /** Returns a human readable representation of the object
     *  @return dot, leftSide, equals, list of productions separated by bars
     *  prefixed with 1 blank
     */
    public String legible() {
        String result = leftSide.getEntity() + " =" ;
        int index = 0;
        Iterator<Production> iter = this.iterator();
        while (iter.hasNext()) {
            if (index > 0) {
            	result += Parm.newline() + "\t| ";
            }
            result += iter.next().legible();
            index ++;
        } // while iter
        return result;
    } // legible

    /** Returns an XML description of this {@link Rule}
     *  @return list of XML elements representing the productions
     */
    public String toString() {
        String result = Parm.getIndent() + "<rule left=\"" + leftSide.getEntity() + "\">" + Parm.getNewline();
        Parm.incrIndent();
        Iterator<Production> iter = this.iterator();
        while (iter.hasNext()) {
            result += iter.next().toString();
        } // while hasNext
        Parm.decrIndent();
        result += Parm.getIndent() + "</rule>";
        return result;
    } // toString

    //------------------------------------------------------------
    /** Test Frame
     */
    public static void main (String args[]) {
    } // main

} // Rule
