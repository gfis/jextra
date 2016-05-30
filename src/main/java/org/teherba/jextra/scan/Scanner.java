/*  Read source file lines and return individual terminal symbols
    @(#) $Id: Scanner.java 427 2010-06-01 09:08:17Z gfis $
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
import  org.teherba.jextra.scan.LineReader;
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.scan.SymbolList;
import  java.util.ArrayList;

/** Reads lines from the input source file,
 *  and returns individual terminal symbols to the parser
 *  @author Dr. Georg Fischer
 */
public class Scanner {
    public final static String CVSID = "@(#) $Id: Scanner.java 427 2010-06-01 09:08:17Z gfis $";

    /** Controls verbosity of debugging output */
    private static final int DEBUG = 1;
    
    /** Programming language of the source file */
    private String language = LANG_C;
    /** Enumeration for programming languages to be parsed */
    public static final String LANG_C       = "C";
    public static final String LANG_PL1     = "PL1";
    public static final String LANG_BNF     = "BNF";
    
    /** Reader for lines from the source file  */
    private LineReader lineReader;
    
    /** symbol list accumulated by this scanner */
    private SymbolList symbolList;
    
    /**	No-args Constructor - initializes codes, but not the <em>LineReader</em>
     */
    public Scanner() {
        initCode();
        lineReader  = null;
        symbolList  = new SymbolList();
        initSpecial();
        initCategories();
    } // Constructor()

    /**	Constructor - initializes the Scanner
     *  @param lang source file programming language
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public Scanner(String lang, String fileName) {
        initCode();
        lineReader  = new LineReader(fileName);
        symbolList  = new SymbolList();
        initSpecial();
        initCategories();
    } // Constructor(String, String)
    /*----------------------------------------------------------------*/
    /** Character class of the current character */
    private byte code;
    /** Enumeration for <em>code</em> */
    private static final byte INVALID       = 0;
    private static final byte EOF           = 1;
    private static final byte EOL           = 2;
    private static final byte SPACE         = 3;
    private static final byte SPECIAL       = 4;
    private static final byte DIGIT         = 5;
    private static final byte LETTER        = 6;
    private static final byte QUOTE         = 7;
    private static final byte DOUBLE_QUOTE  = 8;
    
    /** number of lower characters which are mapped to character classes */
    private static final int CODE_MAX = 256;
    
    /** mapping of lower 256 characters to classes */
    private byte[] codeTable = new byte [CODE_MAX];
    
    /**
     *  Defines a mapping of characters to character sets 
     *  for all characters in the parameter string
     *  @param code to which all characters
     *  in <em>str</em> are mapped
     *  @param str contains the characters to be mapped
     */
    public void assignCode(byte code, String str) {
        for (int pos = 0; pos < str.length(); pos ++) {
            char ch = (char) (0xff & str.charAt(pos));
            codeTable[ch] = code;
        } // for pos
    } // assignCode

    /**
     *  Initializes the code table
     */
    public void initCode() {
        for (int code = 0; code < CODE_MAX; code ++) {
            codeTable[code] = INVALID; // clear table with code "invalid"
        } // for code
        assignCode (EOL,        "\f\n");
        assignCode (SPACE,      " \t\r");
        assignCode (SPECIAL,    "^!$%&/()={[]}?*+~#-:;,.|><@\\");
        assignCode (DIGIT,      "0123456789");
        assignCode (LETTER,     "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                            +   "abcdefghijklmnopqrstuvwxyz" 
                            +   "_");
        assignCode (QUOTE,      "\'");
        assignCode (DOUBLE_QUOTE,   "\"");
    } // initCode
    /*----------------------------------------------------------------*/
    /** Symbols for interpunctuation, with fixed entities */
    public Symbol arrow     ; // before transformation
    public Symbol bar       ; // separates productions
    public Symbol equals    ; // between left and right side of a rule
    public Symbol minus     ; // extended BNF
    public Symbol period    ; // end of rule
    public Symbol sub       ; // start of grammar definition
    public Symbol bus       ; // end   of grammar definition
    public Symbol sharp     ; // internal transformation
    public Symbol open      ; // start grouping
    public Symbol close     ; // end   grouping
    public Symbol plus      ; // occures once or several times
    public Symbol asterisk  ; // missing or several times
    public Symbol slash     ; // separated by
    public Symbol semicolon ; // end of statement
    public Symbol at        ; // @
    public Symbol colon     ; // :
    public Symbol dollar    ; // $
    public Symbol slashStar ; // / *
    public Symbol starSlash ; // * /
    public Symbol slashSlash; // / / 
        
    /**
     *  Initializes predefined, constant operator symbols
     */
    public void initSpecial() {
        arrow       = symbolList.putSpecial("=>");
        bar         = symbolList.putSpecial("|");
        equals      = symbolList.putSpecial("=");
        minus       = symbolList.putSpecial("-");
        period      = symbolList.putSpecial(".");
        sub         = symbolList.putSpecial("[");
        bus         = symbolList.putSpecial("]");
        sharp       = symbolList.putSpecial("#");
        open        = symbolList.putSpecial("(");
        close       = symbolList.putSpecial(")");
        plus        = symbolList.putSpecial("+");
        asterisk    = symbolList.putSpecial("*");
        slash       = symbolList.putSpecial("/");
        semicolon   = symbolList.putSpecial(";");
        at          = symbolList.putSpecial("@");
        colon       = symbolList.putSpecial(":");
        dollar      = symbolList.putSpecial("$");
        slashStar   = symbolList.putSpecial("/*");
        starSlash   = symbolList.putSpecial("*/");
        slashSlash  = symbolList.putSpecial("//");
    } // initSpecial
    /*----------------------------------------------------------------*/
    /** Category of the current symbol */
    private int category;
    /** Symbol categories - symbols which do not stand for themselves */
    public Symbol endOfFile     ;
    public Symbol endOfLine     ;
    public Symbol eolComment    ;
    public Symbol identifier    ;
    public Symbol nestComment   ;
    public Symbol number        ;
    public Symbol space         ;
    public Symbol string        ;
    
    /** Initializes predefined symbols - primaries -
     *  which do not stand for themselves, 
     *  in a fixed order
     */
    public void initCategories() {
        endOfFile   = symbolList.put("EOF");
        endOfLine   = symbolList.put("EOL");
        space       = symbolList.put("SPACE");
        nestComment = symbolList.put("NESTCOM");
        eolComment  = symbolList.put("EOLCOM");
        identifier  = symbolList.put("IDENTIFIER");
        number      = symbolList.put("NUMBER");
        string      = symbolList.put("STRING");
    } // initCategories
    /*----------------------------------------------------------------*/
    /** Current state of the Finite State Automaton */
    private int state;
    /** Enumeration for <em>state</em> */
    private static final byte INITIAL_STATE         =  0; // at start
    private static final byte END_OF_LINE_STATE     =  1; // end of line character (\n, \f)
    private static final byte EOL_COMMENT_STATE     =  2; // after //, in end-of-line comment
    private static final byte IDENTIFIER_STATE      =  3; // after letter, in identifier
    private static final byte NEST_COMMENT_STATE    =  5; // in /* ... */ comment
    private static final byte NUMBER_STATE          =  6; // after digit, in number
    private static final byte OPERATOR_STATE        =  7; // after special character - new operator
    private static final byte SPACE_STATE           =  8; // space/tab characters
    private static final byte STRING_STATE          =  9; // after 1st quote, in string
    private static final byte STRING_2_STATE        = 10; // after 2nd quote
    private static final byte TERMINAL_STATE        = 11; // after recognition of 1 symbol

    /** Index into <em>symbolList</em> of the next symbol 
     *  returned by <em>scan</em>
     */
    private Symbol resultSymbol;

    /** Whether to consume the current character */
    private boolean readOff;

    /** Start of the string for the symbol currently accumulated */
    private int start;

    /** Reads input characters and returns the index of the 
     *  next symbol (or EOF) in the symbol table, 
     *  by maintaining the state of a finite automaton.
     *  The following symbols are returned:
     *  <ul>
     *  <li>sequence of spaces, tabs: normal or at end of line</li>
     *  <li>nested or end-of-line comment</li>
     *  <li>identifier<li>
     *  <li>number<li>
     *  <li>string<li>
     *  <li>special symbol (operator, terminal symbol)<li>
     *  </ul>
     *  @return next symbol in the symbol table
     */
    public Symbol scan() {
        boolean busy = true; // as long as current symbol is not finished
        start = -1; // position in line, undefined so far
        state = INITIAL_STATE;
        resultSymbol = new Symbol();
        category = 0;
        if (DEBUG >= 2) {
            System.out.print("{");
        }
        while (busy) {
            char ch  = lineReader.lookAt();
            readOff = true;
            if (ch > '\u00ff') { // not in ISO-8859-1
                code = INVALID;
            }
            if (lineReader.isAtEof()) {
                code = EOF;
            } else {
                code = codeTable[0x00ff & ch]; 
            }
            
            if (DEBUG >= 2) {
                System.out.print("[" + String.valueOf(ch) + "]" + state);
            }
            switch (state) {
                case END_OF_LINE_STATE:
                    endOfLineState();
                    break;
                case EOL_COMMENT_STATE:
                    eolCommentState();
                    break;
                case IDENTIFIER_STATE:
                    identifierState();
                    break;
                case INITIAL_STATE:
                    initialState();
                    break;
                case NEST_COMMENT_STATE:
                    nestCommentState();
                    break;
                case NUMBER_STATE:
                    numberState();
                    break;
                case OPERATOR_STATE:
                    operatorState();
                    break;
                case SPACE_STATE:
                    spaceState();
                    break;
                case STRING_STATE:
                    stringState();
                    break;
                case STRING_2_STATE:
                    string2State();
                    break;
                default:
                    // programming error
                    break;
            } // switch state

            if (state == TERMINAL_STATE) {
                busy = false; // this symbol is finished, exit loop
            } else if (readOff) {
                lineReader.advance();
            }
        } // while busy

        if (DEBUG >= 2) {
            System.out.print("=" + resultSymbol + "/" + category + ":"
                    + resultSymbol.getEntity()
                    + "}"
                    );
        }
        return resultSymbol;
    } // scan
    /*----------------------------------------------------------------*/
    protected void endOfLineState() {
        switch (code) {
            case SPACE:
            case LETTER:
            case DIGIT:
            case SPECIAL:
            case INVALID:
            case QUOTE:
            case EOL:
            case EOF:
                resultSymbol = symbolList.map(category);
                state = TERMINAL_STATE;
                break;
        } // switch
    } // endOfLineState
    
    protected void eolCommentState() {
        switch (code) {
            case SPACE:
            case LETTER:
            case DIGIT:
            case SPECIAL:
            case INVALID:
            case QUOTE:
                break; // append them
            case EOL:
            case EOF:
                resultSymbol = symbolList.put(category, lineReader.getSubstring(start, lineReader.getColumn()));
                state = TERMINAL_STATE;
                break;
        } // switch
    } // eolCommentState
    
    protected void identifierState() {
        switch (code) {
            case DIGIT:
            case LETTER:
                // append them
                break;

            case EOL:
            case INVALID:
            case SPACE:
            case EOF:
            case QUOTE:
            case SPECIAL:
                resultSymbol = symbolList.map(category, lineReader.getSubstring(start, lineReader.getColumn()));
                state = TERMINAL_STATE;
                break;
        } // switch
    } // identifierState
    
    protected void initialState() {
        Symbol localSymbol;
        start = lineReader.getColumn();
        switch (code) {
            case DIGIT:
                state = NUMBER_STATE;
                category = number.getCategory();
                break;
            case EOF:
                category = endOfFile.getCategory();
                symbolList.append(" ");
                resultSymbol = symbolList.map(category);
                state = TERMINAL_STATE;
                break;
            case EOL:
                category = endOfLine.getCategory();
                symbolList.append(lineReader.nextChar());
                resultSymbol = symbolList.map(category);
                state = TERMINAL_STATE;
                break;
            case LETTER:
                state = IDENTIFIER_STATE;
                category = identifier.getCategory();
                break;
            case QUOTE:
                state = STRING_STATE;
                start ++; // skip over initial quote
                category = string.getCategory();
                break;
            case SPACE:
                state = SPACE_STATE;
                category = space.getCategory();
                break;
            case INVALID:
            case SPECIAL:
                localSymbol = symbolList.mapSpecial(lineReader.getSubstring(start));
                if (localSymbol != null) { // operator was found
                    lineReader.advance(localSymbol.length());
                    if        (localSymbol == slashSlash) {
                        state = EOL_COMMENT_STATE;
                        category = eolComment.getCategory();
                    } else if (localSymbol == slashStar) {
                        state = NEST_COMMENT_STATE;
                        category = nestComment.getCategory();
                    } else {
                        resultSymbol = localSymbol;
                        state = TERMINAL_STATE;
                    }
                } else {
                    // error: unknown sequence of special characters
                    // read all special characters and build a new operator
                    state = OPERATOR_STATE; 
                }
                break;
            default:
                System.err.println("Program error: invalid state " + state + "in 'initialState'");
                break;
        } // switch
    } // initialState
    
    protected void nestCommentState() {
        Symbol localSymbol;
        switch (code) {
            case SPACE:
            case LETTER:
            case DIGIT:
            case INVALID:
            case QUOTE:
                break; // append them 
            case EOL:
                symbolList.append(lineReader.getSubstring(start, lineReader.getColumn()));
                symbolList.append(lineReader.lookAt());
                start = 0;
                break;
            case EOF:
                // error: premature end of nested comment
                state = TERMINAL_STATE;
                break;
            case SPECIAL:
                localSymbol = symbolList.mapSpecial(lineReader.getSubstring());
                if (localSymbol == starSlash) { 
                    lineReader.advance(localSymbol.length());
                    symbolList.append(lineReader.getSubstring(start, lineReader.getColumn()));
                    resultSymbol = symbolList.put(category);
                    state = TERMINAL_STATE;
                } else {
                    // lineReader.advance(1); // by 1 only = care for "***/" 
                }
                break;
        } // switch
    } // nestCommentState
    
    protected void numberState() {
        switch (code) {
            case DIGIT:
                // append them
                break;

            case LETTER:
            case EOL:
            case INVALID:
            case SPACE:
            case EOF:
            case QUOTE:
            case SPECIAL:
                resultSymbol = symbolList.map(category, lineReader.getSubstring(start, lineReader.getColumn()));
                state = TERMINAL_STATE;
                readOff = false;
                break;
        } // switch
    } // numberState
    
    protected void operatorState() {
        switch (code) {
            case SPECIAL:
                // append them
                break;

            case LETTER:
            case DIGIT:
            case EOL:
            case INVALID:
            case SPACE:
            case EOF:
            case QUOTE:
                resultSymbol = symbolList.map(category, lineReader.getSubstring(start, lineReader.getColumn()));
                state = TERMINAL_STATE;
                readOff = false;
                break;
        } // switch
    } // operatorState
    
    protected void spaceState() {
        switch (code) {
            case SPACE:
                break; // append them
            case INVALID:
            case EOL:
            case SPECIAL:
            case EOF:
            case DIGIT:
            case LETTER:
            case QUOTE:
                resultSymbol = symbolList.map(category, lineReader.getSubstring(start, lineReader.getColumn()));
                state = TERMINAL_STATE;
                break;
        } // switch
    } // spaceState

    protected void stringState() {
        switch (code) {
            case SPACE:
            case LETTER:
            case DIGIT:
            case SPECIAL:
            case INVALID:
                // append them
                break;
            case EOL:
            case EOF:
                // error: premature end of string
                resultSymbol = symbolList.map(category, lineReader.getSubstring(start, lineReader.getColumn()));
                state = TERMINAL_STATE;
                break;
            case QUOTE:
                symbolList.append( lineReader.getSubstring(start, lineReader.getColumn()));
                state = STRING_2_STATE;
                break;
        } // switch
    } // stringState
    
    protected void string2State() {
        switch (code) {
            case SPACE:
            case LETTER:
            case DIGIT:
            case SPECIAL:
            case INVALID:
            case EOL:
            case EOF:
                // no 2nd string behind the 1st
                resultSymbol = symbolList.map(category);
                state = TERMINAL_STATE;
                break;
            case QUOTE:
                symbolList.append(lineReader.lookAt()); // 1 quote instead of 2
                state = STRING_STATE;
                break;
        } // switch
    } // string2State
    
    /*----------------------------------------------------------------*/
    /** Gets the index of the next free symbol
     *  @return number of symbols allocated so far
     */
    public int size() {
        return symbolList.size();
    } // size
    
    /** Gets the index of the next free symbol
     *  @return number of symbols allocated so far
     */
    public int getFreeSymbol() {
        return symbolList.size();
    } // getFreeSymbol
    
    /** Gets the symbol list of this scanner object
     *  @return symbol list
     */
    public SymbolList getSymbolList() {
        return symbolList;
    } // getSymbolList
    
    /** Gets a symbol from the symbol list
     *  @param index index of the symbol
     *  @return index of symbol in <em>symbolList</em>
     */
    public Symbol getSymbol(int index) {
        return symbolList.get(index);
    } // getSymbol
    
    /** Tells whether the scanner has reached the End Of File
     *  @return true if scanner is at EOF, false otherwise 
     */
    public boolean isAtEof() {
        return lineReader.isAtEof();
    } // isAtEof

    /** Destructor - Terminate the scanner, close its source file
     */
    public void terminate() {
        lineReader.close();
    } // terminate
    
    /** Print a list of all symbols for debugging purposes
     */
    private void dumpSymbols() {
        if (DEBUG >= 1) {
            for (int index = 0; index < symbolList.size(); index ++) {
                int category = symbolList.get(index).getCategory();
                System.out.println("Symbol " 
                        + index 
                        + ", category " + symbolList.get(category).getEntity()
                        + "\t\"" + symbolList.get(index).getEntity() + "\""
                        );
            } // for index
        } // DEBUG          
    } // dumpSymbols

    /** Test Frame: read lines and print them
     */     
    public static void main (String args[]) { 
        Scanner scanner = new Scanner(LANG_BNF, args[0]);
        scanner.dumpSymbols();
        while (! scanner.isAtEof()) { // read 1 symbol per line
            Symbol localSymbol = scanner.scan();
            System.out.println(localSymbol.toString());
        } // while notEof
        scanner.dumpSymbols();
        scanner.terminate();
    } // main
    
} // Scanner
