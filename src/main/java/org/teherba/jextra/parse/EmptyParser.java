/*  Test parser which reads over all symbols found
    @(#) $Id: EmptyParser.java 427 2010-06-01 09:08:17Z gfis $
    Copyright (c) 2005 Dr. Georg Fischer <punctum@punctum.com>
    2005-03-02 Georg Fischer
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
import  org.teherba.jextra.parse.BaseParser;
import  org.teherba.jextra.Parm;
import  org.teherba.jextra.gener.Table;
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.scan.Scanner;

/** Test parser which reads over all symbols found,
 *  without any state transition-
 *  @author Dr. Georg Fischer
 */
public class EmptyParser extends BaseParser {
    public final static String CVSID = "@(#) $Id: EmptyParser.java 427 2010-06-01 09:08:17Z gfis $";

    /** Constructor - Initialize the EmptyParser
     *  @param tab contains the grammar
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public EmptyParser(Table tab, String fileName) {
        super(tab, fileName);
        table.initialize();
    } // Constructor(Table, String)

    /** Constructor - allocate new {@link Table}, {@link Grammar} and {@link Scanner} objects
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public EmptyParser(String fileName) {
        super(fileName);
        table.initialize();
    } // Constructor(String)

    /** Decides whether a scanned symbol is not ignored.
     *  @return true (false) if the symbol is (not) relevant
     */
    protected boolean relevant() {
        return true;
    } // relevant
    
    /** Test Frame: read symbols, whitespace, comments and print them
     *  @param args command line arguments: 
     *  <ol>
     *  <li>input filename</li>
     *  </ol>
     */     
    public static void main (String args[]) {
        EmptyParser parser = new EmptyParser(args[0]);
        parser.parse();
    } // main

} // EmptyParser
