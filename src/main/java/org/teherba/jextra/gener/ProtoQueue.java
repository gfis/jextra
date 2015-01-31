/*  Queue of prototype states to be processed recursively
    @(#) $Id: ProtoQueue.java 427 2010-06-01 09:08:17Z gfis $
    2007-05-08, Georg Fischer: copied from StateQueue.java
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
import  org.teherba.jextra.gener.Queue;
import  org.teherba.jextra.gener.ProtoState;
import  java.util.Iterator;

/**
 *  Queue of states to be processed recursively
 *  @author Dr. Georg Fischer
 */
public class ProtoQueue extends Queue {
    public final static String CVSID = "@(#) $Id: ProtoQueue.java 427 2010-06-01 09:08:17Z gfis $";
    
    /** No-args Constructor - creates a new prototype state queue
     */
    public ProtoQueue() {
        super();
    }
    
    /** Constructor - creates a queue with specified initial size
     *  @param initSize estimate of the number of elements in the queue
     */
    public ProtoQueue(int initSize) {
        super(initSize);
    }

    /** Constructor - creates a queue with specified name
     *  @param descr description of the queue for debugging
     */
    public ProtoQueue(String descr) {
        super(descr);
    }
    
    /** Constructor - creates a queue with specified initial size and name
     *  @param initSize estimate of the number of elements in the queue
     *  @param descr description of the queue for debugging
     */
    public ProtoQueue(int initSize, String descr) {
        super(initSize, descr);
    }
        
    /** Gets the next element to be processed
     *  @return object from the queue
     */
    public ProtoState next() {
        return (ProtoState) elements.get(head ++);
    }

    /** Appends an element to the queue 
     *  @param elem element to be appended
     */
    public void push(ProtoState elem) {
        add(elem);
    }

    /** Appends an element to the queue;
     *  if it was already contained in the queue, the <em>same</em> property
     *	is set in the new queue element.
     *  @param elem element to be appended
     *  @return element which was previously queued, or new element if unique
     */
    public ProtoState merge(ProtoState elem) {
        ProtoState result = null;
        Iterator iter = this.iterator();
        boolean busy = true;
        while (result == null && iter.hasNext()) {
        	// search for same prototype state
        	ProtoState proto2 = (ProtoState) iter.next();
        	if (elem.compareTo(proto2) == 0) {
        		result = proto2;
        	}
        } // while searching
        add(elem);
        if (result == null) { // not found
            result = elem;
        } else {
        	elem.setSame(result);
        }
        return result;
    }

    /** Deletes the entire queue (set) after unmarking all elements 
     */
    public void clear() {
        head = 0;
        while (hasNext()) { // unmark all elements 
            ProtoState proto = next();
            proto.unmark(this);
        }
        super.clear();
    }

}
