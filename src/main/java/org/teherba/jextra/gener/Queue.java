/*  Pseudo-abstract Queue for objects to be processed recursively
    @(#) $Id: Queue.java 427 2010-06-01 09:08:17Z gfis $
    2016-05-29: Java generics
    2007-05-08: with iterator()
    2005-03-01, Georg Fischer: copied from Rule.java
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
import  org.teherba.jextra.Parm;
import  java.util.ArrayList;
import  java.util.HashSet;
import  java.util.Iterator;

/** Base class for queues, consisting of:
 *  <ul>
 *  <li>an array of objects to be processed recursively
 *  <li>a map remembering the set of elements already queued 
 *  (whether already processed or not)
 *  <li>a pointer to the first object not yet processed
 *  <li>a description of the queue for debugging purposes
 *  </ul>
 *  These queues are used to avoid infinite loops when walking through
 *  a graph of interlinked objects which has cycles.
 *  Processes using this class need not care whether a dependant 
 *  object was already stored or processed.
 *  @author Dr. Georg Fischer
 */
public abstract class Queue {
    public final static String CVSID = "@(#) $Id: Queue.java 427 2010-06-01 09:08:17Z gfis $";
    
    /** value of mark bit for next incarnation */
    protected static int newMarkBit = 1;
    /** index of first object not yet processed */
    protected int head;
    /** array of objects to be processed */
    protected ArrayList<Object> elements;
    /** Bit used to mark the queued elements: 1, 2, 4, 8, 16, etc.
     *  This implementation assumes a maximum of 31 total queues,
     *  whether they store symbols or states. 
     */
    protected int markBit;
    /** name of the queue for debugging output */
    protected String name;

    /** No-args Constructor - creates a new rule
     */
    protected Queue() {
        this(128);
    } // COnstructor
    
    /** Constructor - creates a queue with specified 
     *  initial size
     *  @param initSize estimate of the number of elements in the queue
     */
    protected Queue(int initSize) {
        elements = new ArrayList<Object>(initSize);
        // set = new HashSet(initSize);
        head = 0;
        markBit = newMarkBit;
        newMarkBit <<= 1; 
    } // Constructor(int)
    
    /** Constructor - creates a queue with specified name
     *  @param descr description of the queue for debugging
     */
    public Queue(String descr) {
        this();
        setName(descr);
    } // Constructor(String)
    
    /** Constructor - creates a queue with specified initial size and name
     *  @param initSize estimate of the number of elements in the queue
     *  @param descr description of the queue for debugging
     */
    public Queue(int initSize, String descr) {
        this(initSize);
        setName(descr);
    } // Constructor(int, String)
    
    /** Gets the pointer to the first element not yet processed
     *  @return head of the queue
     */
    public int getHead() {
        return head;
    } // getHead

    /** Gets the pointer to the first element not yet processed
     *  @return head of the queue
     */
    public int getBit() {
        return markBit;
    } // getBit

    /** Gets the name of the queue
     *  @return string describing the queue's contents
     */
    public String getName() {
        return name;
    } // getName

    /** Sets the name of the queue
     *  @param descr string describing the queue's contents
     */
    public void setName(String descr) {
        name = descr;
    } // setName

    /** Gets the next element to be processed
     *  @return whether there are still some elements not yet processed
     */
    public boolean hasNext() {
        return head < elements.size();
    } // hasNext

    /** Gets the size of the queue 
     *  @return number of occupied elements
     */
    public int size() {
        return elements.size();
    } // size

    /** Gets the next element to be processed
     *  @return object from the queue
     */
/*
    public Object next() {
        return elements.get(head ++);
    } // next
*/
    /** Gets an iterator for ALL elements of the queue
     * 	(in contrast to the elements yet to be processed)
     *  @return iterator for all elements
     */
    public Iterator iterator() {
        return elements.iterator();
    } // iterator

    /** Appends an element to the queue without checking whether the 
     *  queue already contains that element
     *  @param elem object to be appended
     */
    protected void add(Object elem) {
        elements.add(elem);
    } // add

    /** Removes all elements from the queue
     */
    protected void clear() {
        elements.clear();
        // set.clear();
        head = 0;
    } // clear

} // Queue
