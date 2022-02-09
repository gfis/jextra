/*  LR(1) Grammar of a language and corresponding parser table
    @(#) $Id$
    2022-02-10: LF only
    2017-05-28: javadoc 1.8
    2016-05-29: Java generics
    2007-05-08: relaunch with prototype states
    2005-02-10, Georg Fischer: copied from Symbol.java
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
import  org.teherba.jextra.gener.Item;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.scan.Scanner;
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.scan.SymbolList;
import  java.util.ArrayList;
import  java.util.Iterator;
import  java.util.TreeMap;

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
    public final static String CVSID = "@(#) $Id$";

    /** a special nonterminal symbol which is the starting point of the grammar */
    public Symbol axiom;
    /** Map a left side to the corresponding rule (set of productions) */
    private TreeMap<Symbol, Rule> ruleMap;
    /** underlying scanner with symbol table */
    private Scanner scanner;
    /** the top-most production for a fictious hyper-axiom */
    private Production prod1;
    /** the symbol list */
    private SymbolList symbolList;

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
    } // Constructor(Scanner)

    /** Get the axiom (root symbol) of the grammar
     *  @return symbol for the axiom of the grammar
     */
    public Symbol getAxiom() {
        return axiom;
    } // getAxiom

    /** Set the axiom (root symbol) of the grammar
     *  @param nonterminal symbol for the axiom
     */
    public void setAxiom(Symbol nonterminal) {
        axiom = nonterminal;
    } // setAxiom

    /** Get the scanner associated with the grammar
     *  @return scanner associated with the grammar
     */
    public Scanner getScanner() {
        return scanner;
    } // getScanner

    /** Get the symbol list of this grammar object
     *  @return symbol list
     */
    public SymbolList getSymbolList() {
        return symbolList;
    } // getSymbolList

    /** Check whether the grammar has a rule for a nonterminal
     *  @param leftSide symbol to be checked
     *  @return whether the symbol is a terminal
     */
    public boolean isTerminal(Symbol leftSide) {
        return ruleMap.get(leftSide) != null;
    } // isTerminal

    /** Get the set of productions for a nonterminal
     *  @param leftSide symbol on the left side of the rule
     *  @return rule, or null if there is none
     */
    public Rule getRule(Symbol leftSide) {
        return ruleMap.get(leftSide);
    } // getRule

    /** Insert or replaces a rule in the set of rules;
     *  there is no check whether the rule was already stored
     *  @param rule rule to be inserted or replaced
     */
    public void insert(Rule rule) {
        ruleMap.put(rule.getLeftSide(), rule);
        System.out.println("irule: " + rule.getLeftSide().getEntity() + ", size=" + rule.size());
    } // insert

    /** Remove all productions for a nonterminal, and thereby
     *  transform it into a terminal
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

    /** Add a production to the grammar;
     *  check whether the production was already stored, and ignore
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

    /** Remove a production from the grammar;
     *  check whether the production was already stored, and print
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

    /** Return a human readable representation of this grammar
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

    /** Return an XML description of this grammar
     *  @return list of XML elements representing the symbol list
     *  and the rules with productions and members.
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
