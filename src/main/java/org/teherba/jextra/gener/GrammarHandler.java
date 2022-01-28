/*  Transforms grammar files of the EXTRA (Extensible Translator) system 
    @(#) $Id: GrammarHandler.java 427 2010-06-01 09:08:17Z gfis $
    2007-05-02, Georg Fischer: copied from JCLTransformer
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
import  org.teherba.jextra.gener.Grammar;
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.trans.SemAction;
import  org.teherba.xtrans.CharTransformer;
import  org.teherba.xtrans.grammar.ExtraTransformer;
import  org.xml.sax.Attributes;
import  org.xml.sax.SAXParseException;
import  org.apache.logging.log4j.Logger;
import  org.apache.logging.log4j.LogManager;

/** Transformer for grammars of the EXTRA (Extensible Translator) system.
 *  @author Dr. Georg Fischer
 */
public class GrammarHandler extends ExtraTransformer { 
    public final static String CVSID = "@(#) $Id: GrammarHandler.java 427 2010-06-01 09:08:17Z gfis $";

    /** log4j logger (category) */
    private static Logger log = LogManager.getLogger(GrammarHandler.class.getName());
    
    /** No-args Constructor.
     */
    public GrammarHandler() {
        super();
        setFormatCodes("gener");
        setDescription("Parser Generator");
        setFileExtensions("grm");
        putEntityReplacements();
    } // Constructor()
    
    //////////////////////
    // SAX event generator
    //////////////////////

    /** Transforms from the specified format to XML
     *  @return whether the transformation was successful
     */
    public boolean generate() {
        boolean result  = false;
        log.error("GrammarHandler cannot read input files");
        return  result;
    } // generate

    //////////////////////
    // SAX content handler 
    //////////////////////

    /** current production */
    private Production prod;
    /** current rule */
    private Rule rule;
    /** current symbol */
    private Symbol sym;
    /** current left side symbol (nonterminal) */
    private Symbol leftSide;
    /** whether in semantic translation part of the production */
    private boolean inTrans;
    /** underlying grammar which results from the processed SAX events */
    private Grammar grammar;
    
    /** Gets the grammar which results from the processed SAX events
     *  @return resulting grammar 
     */
    public Grammar getGrammar() {
        return grammar;
    } // getGrammar
    
    /** Receive notification of the beginning of the document.
     */
    public void startDocument() {
        lineBuffer  = new StringBuffer(MAX_BUF); // a rather long line
        openElement = "";
        ruleCount   = 0;
        inTrans     = false;
    } // startDocument
    
    /** Process the grammar which was built from the SAX events
     */
    public void processGrammar() {
        grammar.initializeTable();
        grammar.generateStates();
        System.out.println(grammar.toString());
    } // processGrammar
    
    /** Receive notification of the start of an element.
     *  Looks for the element which contains raw lines.
     *  @param uri The Namespace URI, or the empty string if the element has no Namespace URI 
     *  or if Namespace processing is not being performed.
     *  @param localName the local name (without prefix), 
     *  or the empty string if namespace processing is not being performed.
     *  @param qName the qualified name (with prefix), 
     *  or the empty string if qualified names are not available.
     *  @param attrs the attributes attached to the element. 
     *  If there are no attributes, it shall be an empty Attributes object.
     */
    public void startElement(String uri, String localName, String qName, Attributes attrs) {
        if (namespace.length() > 0 && qName.startsWith(namespace)) {
            qName = qName.substring(namespace.length());
        }
        openElement = qName;
        if (false) {
        } else if (qName.equals(COMMENT_TAG)) { 
            // ignore comment start
        } else if (qName.equals(LEFT_TAG   )) { 
            lineBuffer.setLength(0);
        } else if (qName.equals(PROD_TAG   )) { 
            prodCount ++;
            prod = new Production(leftSide);
            inTrans = false;
        } else if (qName.equals(ROOT_TAG   )) { 
            grammar = new Grammar();
        } else if (qName.equals(RULE_TAG   )) { 
        } else if (qName.equals(SEMA_TAG   )) { 
            lineBuffer.setLength(0);
        } else if (qName.equals(SYM_TAG    )) { 
            lineBuffer.setLength(0);
        } else if (qName.equals(TERM_TAG   )) { 
            lineBuffer.setLength(0);
        } else if (qName.equals(TRANS_TAG  )) { 
            lineBuffer.setLength(0);
            inTrans = true;
        } // else ignore unknown elements
    } // startElement
     
    /** Receive notification of the end of an element.
     *  Looks for the element which contains raw lines.
     *  Terminates the line.
     *  @param uri the Namespace URI, or the empty string if the element has no Namespace URI 
     *  or if Namespace processing is not being performed.
     *  @param localName the local name (without prefix), 
     *  or the empty string if Namespace processing is not being performed.
     *  @param qName the qualified name (with prefix), 
     *  or the empty string if qualified names are not available.
     */
    public void endElement(String uri, String localName, String qName) {
        if (namespace.length() > 0 && qName.startsWith(namespace)) {
            qName = qName.substring(namespace.length());
        }
        openElement = ""; 
        if (false) {
        } else if (qName.equals(COMMENT_TAG)) { 
            // ignore comment end
        } else if (qName.equals(LEFT_TAG   )) { 
            prodCount = 0;
            leftSide = grammar.getSymbolList().map(lineBuffer.toString());
            Object obj = leftSide.getRule();
            if (obj != null) {
                rule = (Rule) obj;
            } else {
                ruleCount ++;
                rule = new Rule();
                rule.setLeftSide(leftSide);
                leftSide.setRule(rule);
                if (ruleCount <= 1) {
                    grammar.setAxiom(leftSide);
                }
            }
        } else if (qName.equals(PROD_TAG   )) { 
            prod.closeMembers();
            rule.insert(prod);
            grammar.insert(prod);
        } else if (qName.equals(ROOT_TAG   )) {
            processGrammar(); 
        } else if (qName.equals(RULE_TAG   )) { 
            grammar.insert(rule);
        } else if (qName.equals(SEMA_TAG   )) { 
            SemAction sema = null;
            try {
                sema = new SemAction(Integer.parseInt(lineBuffer.toString()), 0);
            } catch (Exception exc) {
            }
            prod.addSemantic(sema);
            prod.closeSemantics();
        } else if (qName.equals(SYM_TAG    )) { 
            if (ruleCount >= 1) {
                sym = grammar.getSymbolList().map(lineBuffer.toString());
                prod.addMember(sym);
            }
        } else if (qName.equals(TERM_TAG   )) { 
            sym = grammar.getSymbolList().map(lineBuffer.toString());
        } else if (qName.equals(TRANS_TAG  )) { 
        } // else ignore unknown elements
    } // endElement
    
    /** Receive notification of character data inside an element.
     *  @param ch the characters.
     *  @param start the start position in the character array.
     *  @param len the number of characters to use from the character array. 
     */
    public void characters(char[] ch, int start, int len) {
        if  (false) {
        } else if ( openElement.equals(SYM_TAG    )
                ||  openElement.equals(LEFT_TAG   )
                ||  openElement.equals(SEMA_TAG   )
                ) {
            String text = new String(ch, start, len);
            lineBuffer.append(new String(ch, start, len));
        } else if ( openElement.equals(COMMENT_TAG)) {
            // ignore comment content
        } else if ( openElement.equals(TERM_TAG   )) {
            String text = replaceInResult(new String(ch, start, len));
            lineBuffer.append(text.replaceAll("\'","\'\'"));
        } // else ignore whitespace around unknown elements
    } // characters
} // GrammarHandler
