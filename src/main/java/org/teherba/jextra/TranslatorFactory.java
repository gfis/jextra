/*  Selects the applicable filter
    @(#) $Id: TranslatorFactory.java 427 2010-06-01 09:08:17Z gfis $
    2016-06-10: comments; Margarete's way
    2007-04-18: NumberFilter, KontoFilter
    2007-02-27: copied from TransformerFactory
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
import  org.teherba.xtrans.BaseTransformer;
import  org.teherba.xtrans.XMLTransformer;
import  org.teherba.jextra.gener.GrammarHandler;
import  java.util.Arrays; // asList
import  java.util.ArrayList; // asList
import  java.util.Iterator;
import  java.util.StringTokenizer;
import  org.apache.log4j.Logger;

/** Selects a specific filter, and iterates over the descriptions
 *  of all filters and their codes
 *  @author Dr. Georg Fischer
 */
public class TranslatorFactory {
    public final static String CVSID = "@(#) $Id: TranslatorFactory.java 427 2010-06-01 09:08:17Z gfis $";

    /** log4j logger (category) */
    private Logger log;

    /** Set of transformers for different file formats
     */
    private BaseTransformer[] allTransformers;

    /** Non-args Constructor
     */
    public TranslatorFactory() {
        log = Logger.getLogger(TranslatorFactory.class.getName());
        allTransformers = new BaseTransformer[] { null // since this allows for "," on next source line
        // the order here defines the order in documentation.jsp,
        // should be: "... group by package order by package, name"
        // -------
        , new XMLTransformer            () // XML serializer
        , new GrammarHandler            () // consumes SAX events and generates a parser table
        };
    } // TranslatorFactor

    /** Gets an iterator over all implemented transformers.
     *  @return list iterator over <em>allTransformers</em>
     */
    public Iterator getIterator() {
        Iterator result = (Arrays.asList(allTransformers)).iterator();
        result.next(); // skip initial null element
        return result;
    } // getIterator

    /** Gets the number of available transformers
     *  @return number of formats which can be spelled
     */
    public int getCount() {
        return allTransformers.length - 1; // minus [0] (== null)
    } // getCount

    /** Determines whether the format code denotes this
     *  transformer class.
     *  @param transformer the transformer to be tested
     *  @param format code for the desired format
     */
    public boolean isApplicable(BaseTransformer transformer, String format) {
        boolean result = false;
        StringTokenizer tokenizer = new StringTokenizer(transformer.getFormatCodes(), ",");
        while (! result && tokenizer.hasMoreTokens()) {
            // try all tokens
            if (format.equals(tokenizer.nextToken())) {
                result = true;
            }
        } // while all tokens
        return result;
    } // isApplicable

    /** Gets the applicable transformer for a specified format code.
     *  @param format abbreviation for the format according to ISO 639
     *  @return the transformer for that format, or <em>null</em> if the
     *  format was not found
     */
    public BaseTransformer getTransformer(String format) {
        BaseTransformer transformer = null;
        // determine the applicable transformer for 'format'
        for (int itrans = 1; itrans < allTransformers.length; itrans ++) {
            if (isApplicable(allTransformers[itrans], format)) {
                transformer = allTransformers[itrans];
            }
        } // for itrans
        log.debug("getTransformer(\"" + format + "\") = " + transformer);
        return transformer;
    } // getTransformer

} // TranslatorFactory
