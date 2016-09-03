/*  Read source file lines
    @(#) $Id: LineReader.java 427 2010-06-01 09:08:17Z gfis $
    2005-01-24, Georg Fischer: copied from CheckAccount.java
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
import  java.io.BufferedReader;
import  java.io.FileReader;
import  java.io.InputStreamReader;

/** Read lines from the parser input (source) file
 *  @author Dr. Georg Fischer
 */
public class LineReader {
    public final static String CVSID = "@(#) $Id: LineReader.java 427 2010-06-01 09:08:17Z gfis $";

    /** tells whether the End Of File was detected */
    boolean atEof = false;

    /** current column in <em>line</em>, 0, 1 ... */
    private int column = 1; // behind 'line'

    /** current line from source file, or null at EOF */
    private String line = "";

    /** sequential number of the line: 1, 2 ... */
    public int lineNumber = 0;

    /** Reader for the source file */
    BufferedReader reader;

    /** Constructor - Initialize the LineReader, open a source file
     *  @param fileName path/name of the source file, "" = STDIN
     */
    public LineReader(String fileName) {
        line = "";
        lineNumber = 0;
        column = 1; // behind 'line'
        atEof = false;
        try {
            reader = new BufferedReader(
                    (fileName == null || fileName.length() <= 0 || fileName.equals("-"))
                    ? new InputStreamReader(System.in)
                    : new FileReader (fileName)
                    );
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();;
        } // catch
    } // Constructor(fileName)

    /** Reads and returns next source line, and
     *  increments the <em>lineNumber</em>
     *  @return source line as String
     */
    public String nextLine() {
        try {
            line = reader.readLine();
            if (line == null) {
                line = "";
                atEof = true;
            }
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();
        } // try
        column = 0;
        lineNumber ++;
        return line;
    } // nextLine

    /** Gets the entire current line
     *  @return source line as String
     */
    public String getLine() {
        return line;
    } // getLine

    /** Gets the current column in <em>line</em>: 0, 1 ...
     *  @return column number 0, 1 ...
     */
    public int getColumn() {
        return column;
    } // getColumn

    /** Sets the current column in <em>line</em>: 0, 1 ...
     *  @param col new column number
     */
    public void setColumn(int col) {
        column = col;
    } // setColumn

    /** Reads (consumes) the next character from the line buffer
     */
    public void advance() {
        column ++;
    } // advance()

    /** Reads (consumes) some characters from the line buffer
     *  @param columns number of characters to be consumed
     */
    public void advance(int columns) {
        column += columns;
    } // advance(int)

    /** Gets the current line number: 1, 2 ...
     *  @return line number 1, 2 ...
     */
    public int getLineNumber() {
        return lineNumber;
    } // getLineNumber

    /** Gets a substring from the current <em>line</em>,
     *  starting at the current <em>column</em>
     *  @return substring from <em>line</em>
     */
    public String getSubstring() {
        return line.substring(column);
    } // getSubstring()

    /** Gets a substring from the current <em>line</em>
     *  @param start first position in <em>line</em>
     *  @return substring from <em>line</em>
     */
    public String getSubstring(int start) {
        return line.substring(start);
    } // getSubstring(int)

    /** Gets a substring from the current <em>line</em>
     *  @param start first position in <em>line</em>
     *  @param behind one position behind substring in <em>line</em>
     *  @return substring from <em>line</em>
     */
    public String getSubstring(int start, int behind) {
        int len = line.length();
        if (behind > len) {
            System.out.print("{lineReader.substr(" + start + "," + behind + ")}");
            behind = len;
        }
        return line.substring(start, behind);
    } // getSubstring(int, int)

    /** Gets the next character in the input file, '\n'
     *  at the End Of Line (also for empty lines),
     *  and possibly sets the EOF flag
     *  @return next character, or '\n' at EOL or EOF
     */
    public char nextChar() {
        char result = lookAt();
        advance();
        return result;
    } // nextChar

    /** Gets the next character in the input file, '\n'
     *  at the End Of Line (also for empty lines),
     *  and possibly sets the EOF flag, but don't <em>advance</em>
     *  or read the character off
     *  @return next character, or '\n' at EOL or EOF
     */
    public char lookAt() {
        char result;
        if (column >  line.length()) { // behind line
            nextLine();
        }

        if (column == line.length()) { // at EOL
            result = '\n';
        } else { // in line
            result = line.charAt(column);
        }
        return result;
    } // lookAt

    /** Tells whether the reader has reached the End Of File
     *  @return true if reader is at EOF, false otherwise
     */
    public boolean isAtEof() {
        return atEof;
    } // isAtEof

    /** Destructor - Terminate the LineReader, close its source file
     */
    public void close() {
        try {
            reader.close();
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();
        } // try
    } // close
    //--------------------------------------------------------------
    /**
     *  Test Frame: read lines and print them
     *  @param args command line arguments: "{-l|-c} filename"
     */
    public static void main (String args[]) {
        LineReader testReader = new LineReader(args[1]);
        if (args[0].startsWith("-l")) {
            String line;
            while (! testReader.isAtEof()) {
                line = testReader.nextLine();
                System.out.println(testReader.getLineNumber() + "\t" + line);
            } // while
        } else { // -c
            char char1;
            int charNumber = 0;
            while (! testReader.isAtEof()) {
                char1 = testReader.nextChar();
                charNumber ++;
                System.out.println(charNumber + "\t" + char1);
            } // while
        }
    } // main
} // LineReader
