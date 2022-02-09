/*  Parm.java - System Parameters
    @(#) $Id$
    2022-02-10: LF only, addOptions, options --name=value
    2016-06-08: fixed NEWLINE; Franzi = 2
    2007-05-04: incrIndent and decrIndent can be used in string expressions
    2005-02-16, Georg Fischer
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

package org.teherba.jextra;
import  java.io.FileInputStream;
import  java.util.Iterator;
import  java.util.Properties;
import  org.apache.logging.log4j.Logger;
import  org.apache.logging.log4j.LogManager;

/** Access to system, configuration and commandline parameters
 *  @author Georg Fischer
 */
public class Parm {
    public final static String CVSID = "@(#) $Id$";

    /** log4j logger (category) */
    private static Logger log = LogManager.getLogger(Parm.class.getName());

    /** accumulated properties */
    private static Properties parameters;

    /** type of operating system
     */
    private static int operatingSystem;
    private static final int UNIX    = 1;
    private static final int WINDOWS = 2;

    /** level of indenting for XML output */
    private static String indent = "";

    /**
     *  Read the system parameters from a properties file
     */
    static {
        indent = "";
        try {
            parameters = new Properties();
            if (! System.getProperty("file.separator").equals("/")) {
                operatingSystem = WINDOWS;
            } else {
                operatingSystem = UNIX;
            }
            parameters.load(new FileInputStream("jextra.properties"));
        } catch (Exception exc) {
            log.error(exc.getMessage());
        }
    } // static

    /** Return the version number of the system
     *  @return current version number
     */
    public static String getVersion() {
        return "2.0";
    } // getVersion

    /** Add all options of the form <code>--name=value</code> 
     *  from the beginning of the commandline as properties
     *  @param args commandline arguments
     *  @return index of first non-option argument (normally a filename)
     */
    public static int addOptions(String[] args) {
        int iarg = 0; 
        while (iarg < args.length && args[iarg].startsWith("--")) {
            int eqPos = args[iarg].indexOf('=');
            if (eqPos >= 0) {
                String name  = args[iarg].substring(2, eqPos);
                String value = args[iarg].substring(eqPos + 1);
                parameters.setProperty(name, value);
            }
            iarg ++;
        } // for iarg
        return iarg;
    } // addOptions

    /** Return the value of a parameter
     *  @param name name of parameter
     *  @return value of the system parameter, or "" if it is undefined
     */
    public static String get(String name) {
        String result = parameters.getProperty(name);
        if (result == null) {
            result = "";
        }
        return result;
    } // get

    /** Return the integer value of a parameter
     *  @param name name of parameter
     *  @return integer value of the system parameter, or 0 if it is undefined
     */
    public static int getInt(String name) {
        int result = 0;
        String value = parameters.getProperty(name);
        try {
            if (value != null) {
                result = Integer.parseInt(value);
            }
        } catch (Exception exc) {
            log.error(exc.getMessage());
        }
        return result;
    } // getInt

    /** Get the system dependant line separator string (CR/LF or LF)
     *  @return newline string, "\n" on Unix
     */
    public static String getNewline() {
        return newline();
    } // getNewline

    /** Get the system dependant line separator string (CR/LF or LF)
     *  @return newline string, "\n" on Unix
     */
    public static String newline() {
        return "\n"; // System.getProperty("line.separator");
    } // newline

    /** Get an XML declaration
     *  @return XML declaration
     */
    public static String getXMLDeclaration() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>";
    } // getXMLDeclaration

    /** Get the leading whitespace for indented XML output
     *  @return a sequence of tab characters
     */
    public static String getIndent() {
        return indent;
    } // getIndent

    /** Increment the leading whitespace for indented XML output
     *  @return empty string
     */
    public static String incrIndent() {
        indent += "  ";
        return "";
    } // incrIndent

    /** Decrement the leading whitespace for indented XML output
     *  @return empty string
     */
    public static String decrIndent() {
        if (indent.length() >= 2) {
            indent = indent.substring(2); // remove 1 indentation level
        }
        return "";
    } // decrIndent

    /** Print an error message about some system assertion
     *  @param message number of the message
     */
    public static void alert(int message) {
        System.err.println("<assert id=\"" + message + "\"" + " />");
    } // alert(1)

    /** Print an error message about some system assertion
     *  @param message number of the message
     *  @param parm1 first additional parameter
     *  @param parm2 second additional parameter
     */
    public static void alert(int message, int parm1, int parm2) {
        System.err.println("<assert id=\"" + message + "\""
                + " parm1=\"" + parm1 + "\""
                + " parm2=\"" + parm2 + "\" />");
    } // alert(3)

    /** Determine whether a specified debugging level is in effect
     *  @param level level of debugging: 0 = none, 1 = some, 2 = more ...
     *  @return whether the current debugging level is &gt;= <em>level</em>
     */
    public static boolean isDebug(int level) {
        String value = parameters.getProperty("debug");
        boolean result = false;
        try {
            if (value != null) {
                result = Integer.parseInt(value) >= level;
            }
        } catch (Exception exc) { // ignore
        }
        return result;
    } // isDebug

    /** Test aid: show all system parameters
     *  @param args command line arguments
     */
    public static void main(String args[]) {
        try {
            System.out.println("java.version=" + System.getProperty("java.version"));
            System.out.println("os.name=" + System.getProperty("os.name"));

            int iarg = Parm.addOptions(args);;
            while (iarg < args.length) {
                System.out.println(args[iarg] + "=" + Parm.get(args[iarg]));
                iarg ++;
            } // for iarg
            System.out.println();
            Iterator iter = parameters.keySet().iterator();
            while (iter.hasNext()) {
                String key = (String) iter.next();
                System.out.println(key + "=" + Parm.get(key));
            } // while hasNext
        } catch (Exception exc) {
            log.error(exc.getMessage());
        }
    } // main

} // Parm
