/*  A prototype of a state of the LR(1) Push-Down Automaton
    @(#) $Id: ProtoState.java 427 2010-06-01 09:08:17Z gfis $
    2007-05-07, Georg Fischer: copied from State.java
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
import  org.teherba.jextra.scan.Symbol;
import  org.teherba.jextra.gener.Production;
import  org.teherba.jextra.gener.Rule;
import  org.teherba.jextra.gener.ProtoQueue;
import  java.util.ArrayList;
import  java.util.Iterator;
import  java.util.TreeSet;

/** A prototype of a state of the LR(1) Push-Down Automaton, consisting of
 *  <ul>
 *  <li>a unique id which later becomes the state's id</li>
 *  <li>the home prototype</li>
 *  <li>the production involved</li>
 *  <li>the position of the marker in the production (0 = before first member, length + 1 = reduce action)</li>
 *  <li>the lookahead terminal</li>
 *  </ul>
 *  @author Dr. Georg Fischer
 */
public class ProtoState implements Comparable {
    public final static String CVSID = "@(#) $Id: ProtoState.java 427 2010-06-01 09:08:17Z gfis $";

    /** unique number assigned to this object */
    private int id;
    /** unique number assigned to each incarnation */
    private static int ident = 1;
    /** prototype state was pushed by this home prototype state */
    private ProtoState home;
    /** production involved */
    private Production prod;
    /** position of the marker in the production (0 = before first member, length + 1 = reduce action) */
    private int markerPos;
    /** lookahed symbol */
    private Symbol lookAhead;
    /** previous prototype state which has the marker one position more to the left */
    private ProtoState left;
    /** shift symbol at <em>markerPos</em> into this following prototype state */
    private ProtoState same;
    /** a prototype state with similiar configuration, or null of unique */
    private ProtoState follow;
    /** mark bits for set manipulation */
    private int markBits;
    
    /** No-args Constructor - creates a new prototype state
     */
    public ProtoState() {
        this(null, null, 0, null, null);
    }
    
    /** Constructor - creates a new prototype state 
     *  which is reached by the specified <em>symbol</em>
     *  @param home prototype state which pushed this production
     *  @param prod production with marker
     *  @param markerPos position of the marker before symbols in the left side, moving from right to left
     *  @param lookAhead terminal symbol behind the left side of the production
     *  @param follow this state is reached after recognition of the marked symbol
     */
    public ProtoState(ProtoState home, Production prod, int markerPos, Symbol lookAhead, ProtoState follow) {
        id              = ident ++;
        this.home       = home;
        this.prod       = prod;
        this.markerPos  = markerPos;
        this.lookAhead  = lookAhead;
        this.follow     = follow;
        this.same       = null;
    }
    
    /** Gets the unique identification of the state
     *  @return unique sequential number of the state
     */
    public int getId() {
        return id;
    }

    /** Gets the home prototype state.
     *  @return the prototype state which had a marker before the left side of the production
     */
    public ProtoState getHome() {
        return home;
    }

    /** Sets the home prototype state.
     *  @param home the prototype state which had a marker before the left side of the production
     */
    public void setHome(ProtoState home) {
        this.home = home;
    }

    /** Gets the similiar prototype state.
     *  @return the prototype state which has the same configuration
     */
    public ProtoState getSame() {
        return same;
    }

    /** Sets the similiar prototype state.
     *  @param same the prototype state which has the same configuration
     */
    public void setSame(ProtoState same) {
        this.same = same;
    }

    /** Gets the production.
     *  @return the production
     */
    public Production getProduction() {
        return prod;
    }

    /** Gets the marked position 
     *  @return position in the production (0 = before first memeber)
     */
    public int getMarkerPos() {
        return markerPos;
    }

    /** Sets the marked position
     *  @param pos position in the production (0 = before first memeber)
     */
    public void setMarkerPos(int pos) {
        markerPos = pos;
    }

    /** Gets the lookahead symbol of the prototype state
     *  @return the prototype state has this lookahead symbol
     */
    public Symbol getLookAhead() {
        return lookAhead;
    }

    /** Sets the lookahead symbol of the prototype state
     *  @param symbol set this lookahead symbol
     */
    public void setLookAhead(Symbol symbol) {
        lookAhead = symbol;
    }

    /** Gets the previous state
     *  @return the prototype state which has the marker one left
     */
    public ProtoState getLeft() {
        return left;
    }

    /** Sets the previous state
     *  @param left the prototype state which has the marker one left
     */
    public void setLeft(ProtoState left) {
        this.left = left;
    }

    /** Gets the follower state
     *  @return the prototype state which is reached by the symbol at <em>markerPos</em>
     */
    public ProtoState getFollow() {
        return follow;
    }

    /** Sets the follower state
     *  @param follow the prototype state which is reached by the symbol at <em>markerPos</em>
     */
    public void setFollow(ProtoState follow) {
        this.follow = follow;
    }

    /** Marks the element as being appended to some queue
     *  @param queue append the element to this queue
     *  @return 0 if the element was not yet marked,
     *  &gt; 0 (= mark bit) value if the element was already queued
     */
    public int mark(ProtoQueue queue) {
        int bit = queue.getBit();
        int result = markBits & bit;
        if (result == 0) {
            markBits += bit;
        }
        return result;
    }

    /** Unmarks the element when it is removed from some queue
     *  @param queue remove the element from this queue
     *  @return 0 if the element was not yet marked,
     *  &gt; 0 (= mark bit) value if the element was already queued
     */
    public int unmark(ProtoQueue queue) {
        int bit = queue.getBit();
        int result = markBits & bit;
        if (result != 0) {
            markBits -= bit;
        }
        return result;
    }

    /** Compares this object with the specified object (protoState2).
     *  Ordering is by production, marked position, and lookAhead.
     *  @param obj2 prototype state on the right side
     *  @return -1 | 0 | +1 if protoState1 < | = | > protoState2
     */
    public int compareTo(Object obj2) {
        ProtoState proto2 = (ProtoState) obj2;
        Production prod2 = proto2.getProduction();
        int result = prod.compareTo(prod2); 
        if (result == 0) {
            // System.out.print(" prod=");
            int pos2 = proto2.getMarkerPos();
            if (markerPos == pos2) {
                // System.out.print(" markerPos=");
                result = lookAhead.getEntity().compareTo(proto2.getLookAhead().getEntity());
                if (result == 0) {
                    // System.out.print(" lookAhead=");
                    result = home.getHome().getId() - proto2.getHome().getHome().getId();
                }               
            } else if (markerPos < pos2) {
                result = -1;
            } else {
                result = 1;
            } // else result == 0
        } else {
            // System.out.print(" prod<>");
        }
        // System.out.println();
        return result;
    }
    
    /** Returns a human readable description of the object
     *  @return state number and list of all items
     */
    public String legible() {
        String result = getId() + "^" + home.getId() + ": " 
                + prod.legible(markerPos) + "{" + lookAhead + "}"
                + (markerPos > prod.size() 
                    ? (" =: " + prod.getLeftSide() +  "," + prod.size())
                    : (" -> " + follow.getId())
                );
        return result;
    }

    /** Returns an XML description of the object
     *  @return XML element representing the item
     */
    public String toString() {
        String result = Parm.getIndent() + "<proto id=\"" + (id < 10 ? " " : "") + id
                + "\" home=\"" + (home.getId() < 10 ? " ": "") + home.getId()
                + "\" prod=\"" + prod.legible(markerPos)
                + "\"\tla=\"" + lookAhead.getEntity() + "\""
                + (follow != null ? " follow=\"" + follow.getId() + "\"" : "")
                + (same   != null ?   " same=\"" +   same.getId() + "\"" : "")
             /*
                + (left   != null ?   " left=\"" +   left.getId() + "\"" : "")
             */
                + " />" + Parm.getNewline();
        return result;
    }

    /** Test Frame
     */     
    public static void main (String args[]) { 
    } // main

} // ProtoState
