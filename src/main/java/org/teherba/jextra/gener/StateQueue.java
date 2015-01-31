/*  Queue of states to be processed recursively
    @(#) $Id: StateQueue.java 427 2010-06-01 09:08:17Z gfis $
    Copyright (c) 2005 Dr. Georg Fischer <punctum@punctum.com>
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
import  org.teherba.jextra.gener.Queue;
import  org.teherba.jextra.gener.State;
import  org.teherba.jextra.gener.Table;
import  org.teherba.jextra.scan.Symbol;
/**
 *  Queue of states to be processed recursively
 *  @author Dr. Georg Fischer
 */
public class StateQueue extends Queue {
    public final static String CVSID = "@(#) $Id: StateQueue.java 427 2010-06-01 09:08:17Z gfis $";
    
    /**
     *  Empty Constructor - creates a new state queue
     */
    public StateQueue() {
        super();
    }
    
    /**
     *  Constructor - creates a queue with specified initial size
     *  @param initSize estimate of the number of elements in the queue
     */
    public StateQueue(int initSize) {
        super(initSize);
    }

    /**
     *  Constructor - creates a queue with specified name
     *  @param descr description of the queue for debugging
     */
    public StateQueue(String descr) {
        super(descr);
    }
    
    /**
     *  Constructor - creates a queue with specified initial size and name
     *  @param initSize estimate of the number of elements in the queue
     *  @param descr description of the queue for debugging
     */
    public StateQueue(int initSize, String descr) {
        super(initSize, descr);
    }
        
    /**
     *  Gets the next element to be processed
     *  @return object from the queue
     */
    public State next() {
        return (State) elements.get(head ++);
    }

    /**
     *  Appends an element to the queue if it is not yet contained in the queue
     *  @param elem element to be appended
     *  @return number of same elements already queued (0 or 1)
     */
    public int push(State elem) {
        int found = 0;
        if (elem.mark(this) == 0) { // not found
            add(elem);
        }
        else {
            found = 1;
        }
        return found;
    }

    /**
     *  Deletes the entire queue (set) after unmarking all elements 
     */
    public void clear() {
        head = 0;
        while (hasNext()) { // unmark all elements 
            State state = next();
            state.unmark(this);
        }
        super.clear();
    }

    //------------------------------------------------------------
    /**
     *  Test Frame
     */     
    public static void main (String args[]) { 
        Table table = new Table();
        StateQueue queue = new StateQueue("test");
        for (int index = 0; index < 8; index ++) {
            String entity = "S" + index;
            Symbol elem = new Symbol(entity);
            System.out.println("push " + entity + ": " 
                    + queue.push(table.allocate(elem))
                    + " @ " + queue.getHead()
                    );
        }
        for (int index = 0; index < 8; index += 4) {
            State state = table.get(index);
            System.out.println("push2 " 
                    + state.getReachingSymbol().getEntity() + ": " 
                    + queue.push(state)
                    + " @ " + queue.getHead()
                    );
        }
        while(queue.hasNext()) {
            System.out.println("next elem: " 
                    + queue.next().getReachingSymbol().getEntity());
        }
    } // main
}
