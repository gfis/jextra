/*  Base class for all parser table generators
    @(#) $Id$
    2022-02-10: LF only, Table -> StateTable, abstract
    2017-05-28: javadoc 1.8
    2016-06-11: renamed from Generator
    2005-02-21, Georg Fischer
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
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.gener.StateTable;

/** Base class for all Parser table Generators
 *  @author Georg Fischer
 */
public abstract class BaseGenerator {
    public final static String CVSID = "@(#) $Id$";

    /** Operate on this grammar and the corresponding parser table */
    protected Grammar grammar;
    /** Generate this new LR(1) parser table */
    protected StateTable targetTable;

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
        targetTable = new StateTable(grammar);
    } // Constructor(Grammar)

    /** Set the generator's target {@link stateTable}
     *  @param tab with state set and grammar
     */
    public void setTargetTable(StateTable tab) {
        targetTable = tab;
    } // setTargetTable

    /** Generate a new parser state table after a change of a set of productions
     */
    public abstract void generate();

} // BaseGenerator
