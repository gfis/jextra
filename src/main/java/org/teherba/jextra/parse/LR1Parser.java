/*  LR(1) Parser - recognizes the language of a context-free grammar
    @(#) $Id: LR1Parser.java 427 2010-06-01 09:08:17Z gfis $
    2005-02-25, Georg Fischer
    Copyright (c) 1980 Georg Fischer
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
import  org.teherba.jextra.gener.Item;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.gener.Table;
import  org.teherba.jextra.parse.BaseParser;
import  org.teherba.jextra.scan.Scanner;
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.trans.SemAction;

import  java.util.ArrayList;

/** LR(1) Parser - recognizes the language of a context-free
 *  grammar; utilizes a deterministic push-down stack automaton.
 *  @author Dr. Georg Fischer
 */
public class LR1Parser extends BaseParser {
    public final static String CVSID = "@(#) $Id: LR1Parser.java 427 2010-06-01 09:08:17Z gfis $";

    /** push-down stack for states */
    protected ArrayList stack = new ArrayList(128);

    /** Constructor - central LR(1) parsing algorithm
     *  utilizing a push-down stack of states
     *  @param tab LR(1) table of parser states
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public LR1Parser(Table tab, String fileName) {
        super(tab, fileName);
        stack = new ArrayList(128);
        state = table.getStartState();
    }

    /** Constructor - allocate new <em>Table</em>, <em>Grammar</em> and <em>Scanner</em> objects
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public LR1Parser(String fileName) {
        super(fileName);
    }

    /** Determines the next state of the parser. 
     *  This dummy version reads over all symbols without 
     *  any state change.
     *  @return true (false) if the sentence of the language 
     *  was (not yet) accepted  
     */
    protected boolean transition() {
        boolean accepted = false;
        Item item = state.delta(symbol);
        switch (item.getAction()) {
            case Item.SHIFT: 
                state = item.getSuccessor();
                stack.add(state); // PUSH state
                break;
            case Item.REDUCE:
                Production prod = item.getProduction();
                int top = stack.size();
                int newTop = top - prod.size();
                while (-- top >= newTop) {
                    state = (State) stack.remove(top); // POP right side
                } // while popping
                symbol = prod.getLeftSide();
                readOff = false;
                break;
            case Item.ERROR:
                error(state.getId(), symbol.getEntity());
                // ignore symbol
                break;
            case Item.ACCEPT:
                System.out.println("<accept />" + Parm.getNewline());
                accepted = true;
                break;
        } // switch action
        return accepted;
    }
    
    /** Test Frame: read a sentence of the grammar 
     *  and print its structure tree
     *  @param args command line arguments: 
     *  <ol>
     *  <li>input filename</li>
     *  </ol>
     */     
    public static void main (String args[]) { 
        LR1Parser parser = new LR1Parser(args[0]);
        parser.parse();
        System.out.println(parser.getGrammar().legible());
    } // main
}
