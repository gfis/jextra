/*  Base class for all Parser Table Generators
    @(#) $Id: Generator.java 427 2010-06-01 09:08:17Z gfis $
    2017-05-28: javadoc 1.8
    2016-06-11: renamed from Generator
    2005-02-21, Georg Fischer
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
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.gener.SymbolQueue;
import  org.teherba.jextra.gener.Table;
import  org.teherba.jextra.scan.SymbolList;
import  org.teherba.jextra.trans.SemAction;
import  java.util.ArrayList;
import  java.util.Iterator;

/** Base class for all Parser Table Generators
 *  @author Dr. Georg Fischer
 */
public class BaseGenerator {
    public final static String CVSID = "@(#) $Id: Generator.java 427 2010-06-01 09:08:17Z gfis $";

    /** Operate on this grammar and corresponding parser table */
    private Grammar grammar;
    /** Generate this LR(1) parser table */
    private Table table;

    /** No-args Constructor - creates a new generator for a grammar
     */
    public BaseGenerator() {
        this(new Grammar());
    } // Constructor()

    /** Constructor - creates a new generator for a grammar
     *  @param gram operate on this <em>Grammar</em> and
     *  corresponding parser table
     */
    public BaseGenerator(Grammar gram) {
        grammar = gram;
        table   = new Table(grammar);
    } // Constructor(Grammar)

    /** Reorganizes the parser table after a change of a set of productions
     */
    public void reorganize() {
        boolean changed = true;
        SymbolQueue queue = new SymbolQueue();
        while (changed) {
            changed = table.insertSymbols(queue);
            // table.recomputeSuccessorStates();
        } // while changed

        if (Parm.getInt("enbloc") == 0) {
            table.purgeLookAheadSymbols();
            table.purgeStates();
            table.getLookAheadSymbols();
        } // enbloc
        table.putLookAheadSymbols();
        table.purgeItems();
        table.resolveConflicts();
    } // reorganize

    //------------------------------------------------------------
    /** Test Frame
     *  @param args commandline arguments
     */
    public static void main (String args[]) {
    } // main

} // BaseGenerator
