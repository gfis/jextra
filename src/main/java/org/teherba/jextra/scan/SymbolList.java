/*  Store and retrieve parser symbols of the programming language
    @(#) $Id: SymbolList.java 427 2010-06-01 09:08:17Z gfis $
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
import  org.teherba.jextra.scan.LineReader; // in main, for testing
import  org.teherba.jextra.scan.Symbol;
import  java.util.ArrayList;
import  java.util.HashMap;
import  java.util.Iterator;

/** Maintains a storage of parser symbols:
 *  <ul>
 *  <li>identifiers</li>
 *  <li>numbers</li>
 *  <li>strings</li>
 *  <li>sequences of interpunctuation characters</li>
 *  </ul>
 *  @author Dr. Georg Fischer
 */
public class SymbolList {
    public final static String CVSID = "@(#) $Id: SymbolList.java 427 2010-06-01 09:08:17Z gfis $";
    
    /** internal temporary buffer for strings of new entities **/
    private StringBuffer buffer = new StringBuffer(1024); // usually longer than any source line
    
    /** maps entities (strings) to <em>Integer</em> indexes of the 
     *  corresponding entries in <em>symbolList</em>
     */
    private HashMap<String, Symbol> entityMap; 
    
    /** array of symbols, indexed by symbol number, stores <em>Symbol</em>s
     */
    private ArrayList<Symbol> symbolList;

    /** array of indexes of special symbols, indexed by symbol number
     *  stores <em>Integer</em>s
     */
    private ArrayList<Symbol> specialList; 
    //--------------------------------------------------------- 
    /** Constructor - creates a new, empty symbol list
     */
    public SymbolList() {
        try { 
            buffer.setLength(0);
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();;
        } // catch
        entityMap   = new HashMap<String, Symbol> (1024);
        specialList = new ArrayList<Symbol>       (64);
        symbolList  = new ArrayList<Symbol>       (1024);
    } // Constructor()
    //--------------------------------------------------------- 
    /** Appends a character to the internal entity buffer 
     *  for later mapping
     *  @param ch character to be appended
     */
    public void append(char ch) {
        buffer.append(ch);
    } // append(char)
    
    /** Appends a string of characters to the internal entity buffer 
     *  for later mapping
     *  @param str string to be appended
     */
    public void append(String str) {
        buffer.append(str);
    } // append(String>
    //--------------------------------------------------------- 
    /** Tries to map the entity (String) in the internal buffer
     *  to one of the entities stored so far
     *  @return index of previously stored symbol, 
     *  or of a new symbol if not found
     */
    public Symbol map() {
        return map(0);
    } // map()
    
    /** Tries to map the entity (string) in the internal buffer
     *  to one of the entities stored so far
     *  @param category category of the new symbol
     *  @return index of previously stored symbol, 
     *  or of a new symbol if not found
     */
    public Symbol map(int category) {
        Symbol symbol = map(category, buffer.toString());
        buffer.setLength(0); // start assembly of next entity
        return symbol;
    } // map(category)
    
    /** Tries to map the parameter entity (string)
     *  to one of the entities stored so far
     *  @param str entity (identifier, number and so on) to be mapped
     *  @return index of previously stored symbol, 
     *  or of a new symbol if not found
     */
    public Symbol map(String str) {
        return map(0, str);
    } // map(String)
    
    /** Tries to map the parameter entity (string)
     *  to one of the entities stored so far
     *  @param category category of the new symbol
     *  @param str entity (identifier, number and so on) to be mapped
     *  @return index of previously stored symbol, 
     *  or of a new symbol if not found
     */
    public Symbol map(int category, String str) {
        Symbol symbol;
        Object obj = entityMap.get(str);
        if (obj != null) { // found - was already stored
            symbol = (Symbol) obj;
        } else { // not found - create a new entity
            symbol = new Symbol(category, str);
            entityMap.put(str, symbol);
            if (category == 0) {
                symbol.setCategory(symbolList.size());
            }
            symbol.setId(symbolList.size());
            symbolList.add(symbol);
        } // not found
        return symbol;
    } // map(category, String)
    //--------------------------------------------------------- 
    /** Gets a symbol via its index in the symbol list
     *  @param index number of the symbol
     *  @return symbol with that index in the symbol list
     */
    public Symbol get(int index) {
        return symbolList.get(index);
    } // get
    //--------------------------------------------------------- 
    /** Stores a new symbol without trying to map it to a
     *  previously stored symbol
     *  @return a new symbol
     */
    public Symbol put() {
        return put(0);
    } // put()
    
    /** Stores a new symbol without trying to map it to a
     *  previously stored symbol
     *  @param category category of the new symbol
     *  @return a new symbol
     */
    public Symbol put(int category) {
        Symbol symbol = put(category, buffer.toString());
        buffer.setLength(0); // start assembly of next entity
        return symbol;
    } // put(category)
    
    /** Stores a new symbol without trying to map it to a
     *  previously stored symbol
     *  @param str entity to be stored
     *  @return a new symbol
     */
    public Symbol put(String str) {
        return put(0, str);
    } // put(String)

    /** Stores a new symbol without trying to map it to a
     *  previously stored symbol
     *  @param category category of the new symbol
     *  @param str entity to be stored
     *  @return a new symbol
     */
    public Symbol put(int category, String str) {
        Symbol symbol = new Symbol(category, str);
        if (category == 0) {
            symbol.setCategory(symbolList.size());
        }
        symbol.setId(symbolList.size());
        symbolList.add(symbol);
        return symbol;
    } // put(category, String)
    //--------------------------------------------------------- 
    /** Stores a sequence of special characters as a new symbol, and
     *  remembers it in the <em>specialList</em>; it will not be found
     *  by <em>map</em>
     *  @param special string to be stored
     *  @return the new symbol
     */
    public Symbol putSpecial(String special) {
        Symbol symbol = put(special);
        specialList.add(symbol);
        return symbol;
    } // putSpecial

    /** Tries to match a prefix of the parameter with the 
     *  longest sequence of special characters
     *  in <em>specialList</em>, and to return the index of the 
     *  corresponding symbol. 
     *  @param str string to be matched, may be longer as 
     *  the symbol found
     *  @return index of the special symbol, or -1 if not found
     */
    public Symbol mapSpecial(String str) {
        Symbol result = null;
        String candidate = "";
        Iterator<Symbol> iter = specialList.iterator();
        while (iter.hasNext()) {
            Symbol special = iter.next();
            String entity = special.getEntity();
            if (str.startsWith(entity) && entity.length() > candidate.length()) {
                candidate = entity;
                result = special;
            }
        } // while hasNext
        // System.out.println ("[mapS(" + str + "):" + result.toString() + "]");
        return result;
    } // mapSpecial
    
    /** Gets the number of symbols allocated so far
     *  @return number of symbols allocated so far
     */
    public int size() {
        return symbolList.size();
    } // size
    
    /** Returns a human readable description of the object
     *  @return list of XML elements representing the symbols in the list
     */
    public String toString() {
        String 
        result = Parm.getIndent() + "<symbolList>" + Parm.getNewline();
        Parm.incrIndent();
        Iterator<Symbol> iter = symbolList.iterator();
        while (iter.hasNext()) {
            result  += Parm.getIndent() 
                    +  iter.next().toString() 
                    +  Parm.getNewline();
        } // while hasNext
        Parm.decrIndent();
        result += Parm.getIndent() + "</symbolList>" + Parm.getNewline();
        return result;
    } // toString

    /** -----------------------------------------------------------
     *  Test Frame: reads a text file with 1 symbol per line,
     *  stores and prints the symbols
     *  @param args name of text file to be read
     */     
    public static void main (String args[]) { 
        LineReader lineReader = new LineReader(args[0]); 
        SymbolList symbolList = new SymbolList();
        try {
            String line = lineReader.nextLine();
            while (! lineReader.isAtEof()) { // read 1 symbol per line
                symbolList.append(line);
                Symbol symbol = symbolList.map(0);
                System.out.print (symbol.toString());
                if (line.length() > 0
                    && Character.isDigit(line.charAt(0))) {
                    System.out.print("<numerical value=\"" 
                            + symbol.getNumericalValue()
                            + "\" />");
                }
                System.out.println();
                line = lineReader.nextLine();
            } // while notEof
            lineReader.close();
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();
        } // try
        System.out.println(symbolList.toString());
    } // main

} // SymbolList
