/*  Commandline tool which processes gramamrs and generates parser tables
    @(#) $Id: Translator.java 427 2010-06-01 09:08:17Z gfis $
    Copyright (c) 2007 Dr. Georg Fischer <punctum@punctum.com>
    2007-04-04: tested with XMLTransformer
    2007-02-27: copied from xtrans.MainTransformer
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

package org.teherba.jextra;
import  org.teherba.jextra.TranslatorFactory;
import  org.teherba.xtrans.BaseTransformer;
import  org.teherba.xtrans.grammar.ExtraTransformer;
import  java.util.Arrays; // asList
import  java.util.ArrayList; // asList
import  java.util.Iterator;
import  org.apache.logging.log4j.Logger;
import  org.apache.logging.log4j.LogManager;

/** Commandline tool which processes gramamrs and generates parser tables
 *  @author Dr. Georg Fischer
 */
public class Translator { 
    public final static String CVSID = "@(#) $Id: Translator.java 427 2010-06-01 09:08:17Z gfis $";

    /** log4j logger (category) */
    private Logger log;
    
    /** Factory for transformers for different file formats */
    private TranslatorFactory factory = null;
    
    /**
     *  Constructor
     */
    public Translator() {
        log = LogManager.getLogger(Translator.class.getName());
        factory = new TranslatorFactory();
    }

    /** maximum number of files / formats / encodings */
    private static final int MAX_FILE = 2;
    /**
     *  Processes the commandline arguments and calls the applicable transformer
     *  @param args commandline arguments as strings
     */
    public void processArgs(String args[]) {
        try {
            BaseTransformer generator   = null;
            BaseTransformer serializer  = null;
            int iarg = 0; // index for command line arguments
            if (iarg >= args.length) { // usage, with known ISO codes and formats
                System.err.println("usage:\tjava org.teherba.xtrans.Transformer "
                        + " [-enc1 srcenc [-enc2 tarenc]]"
                        + " [-nsp namespace]"
                        + " [-informat|-xml] [-xml|-outformat]"
                        + " [infile [outfile]]");
                Iterator iter = factory.getIterator();
                while (iter.hasNext()) {
                    generator = (BaseTransformer) iter.next();
                    System.err.println( "\t" + generator.getFirstFormatCode() 
                                +       "\t" + generator.getDescription    ());
                } // while iter
            } else { // >= 1 argument 
                String[] fileNames = new String[] {null, null};
                String options = ""; //  = "-test 2 ";
                int ifmt  = 0; 
                int ifile = 0;
                // get all commandline parameters
                while (iarg < args.length) {
                    log.debug("args[" + iarg + "]=\"" + args[iarg] + "\"");
                    if (args[iarg].length() == 0) { // parameter String[]
                        iarg ++;
                    } else if (args[iarg].startsWith("-")) { // is an option
                        String option = args[iarg ++].substring(1); // without the hyphen
                        BaseTransformer base = factory.getTransformer(option);
                        if (base != null) {
                            if (ifmt < MAX_FILE) {
                                if (ifmt == 0) {
                                    generator  = base;
                                } else {
                                    serializer = base;
                                }
                                ifmt ++;
                            } 
                        } else { // other option
                            String value = "1";
                            if (iarg < args.length && ! args[iarg].startsWith("-")) {
                                value = args[iarg ++];
                            }
                            options += "-" + option + " " + value + " ";
                            log.debug("addOption(\"" + option + "\", \"" + value + "\");"); 
                        }
                    } else { // no option -> filename
                        if (ifile < MAX_FILE) {
                            fileNames[ifile ++] = args[iarg];
                        }
                        iarg ++;
                    }
                } // while commandline
                if (generator == null || serializer == null) {
                    log.error("no known transformation format");
                } else {
                    ifile = 0;
                    generator .parseOptionString(options);
                    generator .openFile(ifile, fileNames[ifile]); 
                    ifile ++;
                    serializer.parseOptionString(options);
                    serializer.openFile(ifile, fileNames[ifile]);
                    generator.setCharWriter(serializer.getCharWriter());
                    
                    generator .setContentHandler(serializer);
                    serializer.setContentHandler(generator );
                    generator .generate();
                    
                    generator .closeAll();
                    serializer.closeAll();
                }
            } // args.length >= 1
        } catch (Exception exc) {
            log.error(exc.getMessage(), exc);
            exc.printStackTrace();
        }
    }
    
    /** Main program, processes the commandline arguments
     *  @param args Arguments; if missing, print the following:
     *  <pre>
     *  usage:\tjava org.teherba.jextra.Translator 
     *  [-enc1 srcenc [-enc2 tarenc]]
     *  [-nsp namespace]
     *  [-informat|-xml] [-xml|-outformat]
     *  [infile [outfile]]
     *  </pre>
     */
    public static void main(String args[]) {
        (new Translator()).processArgs(args);
    } // main

}
