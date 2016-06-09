/*  Production rule of the grammar
    @(#) $Id: Production.java 427 2010-06-01 09:08:17Z gfis $
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
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.trans.SemAction;
import  java.util.ArrayList;
import  java.util.Iterator;

/** Production rule of the grammar, consisting of
 *  <ul>
 *  <li>left side (nonterminal)</li>
 *  <li>array of members (symbol numbers) on the right side, maybe empty</li>
 *  <li>EOP = end of production symbol</li>
 *  <li>semantic (transformational) part = list of semantic actions</li>
 *  </ul>
 *  @author Dr. Georg Fischer
 */
public class Production implements Comparable {
    public final static String CVSID = "@(#) $Id: Production.java 427 2010-06-01 09:08:17Z gfis $";

    /** a special symbol indicating the end of a production */
    public static final Symbol EOP = new Symbol(0, "EOP");
    
    /** No-args Constructor - creates a new production
     */
    public Production() {
        this(new Symbol());
    } // Constructor()
    
    /** Constructor - creates a new, empty production
     *  for left side <em>symbol</em>
     *  @param symbol symbol on the left side (nonterminal)
     */
    public Production(Symbol symbol) {
        leftSide    = symbol;
        members     = new ArrayList<Symbol>(16);
        semantics   = new ArrayList<SemAction>(16);
    } // Constructor(symbol)
    
    //---------------------------------
    /** sequential number */
    private int id;
    
    /** Gets the sequential number
     *  of the production
     */
    public int getId() {
        return id;
    } // getId
    /** Sets the sequential number of the production
     *  @param id set this int
     */
    public void setId(int id) {
        this.id = id;
    } // setId
    //---------------------------------
    /** (number of) left hand symbol of the production (nonterminal) */
    private Symbol leftSide;
    /** Gets the left side (number of nonterminal symbol) 
     *  of the production
     */
    public Symbol getLeftSide() {
        return leftSide;
    } // getLeftSide
    /** Sets the left side of the production
     *  @param nonterminal symbol on the left side (nonterminal)
     */
    public void setLeftSide(Symbol nonterminal) {
        leftSide = nonterminal;
    } // setLeftSide
    //---------------------------------
    /** list of symbols (their numbers) on the right side of the
     *  production (maybe empty), terminated by EOP
     */
    private ArrayList<Symbol> members;
    
    /** Appends a symbol to the right side of the production
     *  @param member symbol on the right side (terminal or
     *  nonterminal)
     */
    public void addMember(Symbol member) {
        members.add(member);
    } // addMember

    /** Gets a member on the right side by its position
     *  @param position index of the desired member, starting at 0,
     *  must be less than <em>size()</em>
     *  @return symbol at the specified position in the right side
     */
    public Symbol getMember(int position) {
        Symbol result;
        if (position < 0 || position >= members.size()) {
            result = EOP;
        } 
        else {
            result = (Symbol) members.get(position);
        }
        return result;
    } // getMember

    /** Gets the first member on the right side 
     *  @return symbol at position 0 in the right side
     */
    public Symbol getFirstMember() {
        return getMember(0);
    } // getFirstMember

    /** Terminates the right side (member list) of the production
     */
    public void closeMembers() {
        addMember(EOP);
    } // closeMembers

    //---------------------------------
    /** list of semantic actions for this production */
    private ArrayList<SemAction> semantics;
    
    /** Appends a semantic action
     *  @param sema semantic action to be appended
     */
    public void addSemantic(SemAction sema) {
        semantics.add(sema);
    } // addSemantic

    /** Terminates the list of semantic actions for the production
     */
    public void closeSemantics() {
        addSemantic(new SemAction(SemAction.EOS, 0));
    } // closeSemantics
    //---------------------------------
    /** Compares this object (prod1) with the specified object (prod2).
     *  Ordering is by left side, common member substring and length
     *  @param obj2 production on the right side
     *  @return -1, 0, +1 if prod1 < = > prod2
     */
    public int compareTo(Object obj2) {
        Production prod2 = (Production) obj2;
        int result = this.leftSide.compareTo(prod2.getLeftSide()); // order 1 by left sides
        if (result == 0) { 
            // System.out.print(" " + leftSide.getEntity() + "=");
            // order 2 by member lists
            int len1 = this.size();
            int len2 = prod2.size();
            int index = 0;
            while (index < len1 && index < len2) {
                result = this.getMember(index).compareTo(prod2.getMember(index));
                if (result != 0) {
                    index = len1; // break loop
                }
                index ++;
            } // while in both member lists
            if (result == 0) {
                // System.out.print(" members= " + len1 + " " + len2);
                if (len1 < len2) {
                    result = -1;
                } else if (len1 > len2) {
                    result =  1;
                }
                // else 'result' is already 0
            }
        } // discriminate by member lists
        return result;
    } // compareTo
    
    /** Gets the length, that is the number of members on the right side
     *  of the production;
     *  can only be called for closed productions; EOP is not counted
     *  @return number of members on the right side (0, 1 ...)
     */
    public int size() {
        return members.size() - 1; // EOP is not counted
    } // size

    /** Returns a human readable representation of this {@link Production}
     *  @return string of symbols on the right side, separated and
     *  prefixed with 1 blank
     */
    public String legible() {
        return legible(-1); // will never be reached as marker position
    } // legible

    /** Returns a human readable representation of this {@link Production}
     *  with a marker before a position
     *  @param position index of member to be marked (0 = first)
     *  @return string of symbols on the right side, separated and
     *  prefixed with 1 blank
     */
    public String legible(int position) {
        String result = "";
        Iterator<Symbol> iter = members.iterator();
        int index = 0;
        while (iter.hasNext()) {
            Symbol member = iter.next();
            if (index == position) {
                result += " @";
            }
            if (member != EOP) {
                result += " " + member.legible();
            }
            index ++;
        } // while hasNext
        return result;
    } // legible(position)

    /** Returns an XML description of the object
     *  @return list of XML elements representing the members and semantic actions
     */
    public String toString() {
        String result = Parm.getIndent() + "<prod left=\"" + leftSide.getEntity() 
                + "\" size=\"" + size()
                + "\">" + Parm.getNewline();
        Parm.incrIndent();
        Iterator<Symbol> miter = members.iterator();
        while (miter.hasNext()) {
            result += Parm.getIndent() + miter.next().toString() + Parm.getNewline();
        } // while hasNext
        Iterator<SemAction> siter = semantics.iterator();
        while (siter.hasNext()) {
            result += Parm.getIndent() + siter.next().toString() + Parm.getNewline();
        } // while hasNext
        Parm.decrIndent();
        result += Parm.getIndent() + "</prod>" + Parm.getNewline();
        return result;
    } // toString

    /** Test Frame
     */     
    public static void main (String args[]) { 
    } // main

} // Production
