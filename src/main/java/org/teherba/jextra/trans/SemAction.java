/*  Semantic Action 
    @(#) $Id: SemAction.java 427 2010-06-01 09:08:17Z gfis $
    Copyright (c) 2005 Dr. Georg Fischer <punctum@punctum.com>
    2005-02-10, Georg Fischer: copied from Production.java
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

package org.teherba.jextra.trans;

/**
 *  Semantic action (elementary syntax tree transformation command) 
 *  of a production rule
 *  @author Dr. Georg Fischer
 */
public class SemAction {
    public final static String CVSID = "@(#) $Id: SemAction.java 427 2010-06-01 09:08:17Z gfis $";

    /* accumulator */
    public static final int  ACCO =  1; 
    public static final int  ACIN =  2;
    public static final int  ACMA =  3;
    public static final int  ACTA =  4;
    /* attribute */
    public static final int  ATCO =  5; 
    public static final int  ATIN =  6;
    public static final int  ATMA =  7;
    public static final int  SYAT =  8;
    /* son, member */
    public static final int  SOCO =  9; 
    public static final int  REIN = 10;
    public static final int  UNCHANGED  = 11;
    public static final int  SOTA = 12;
    /* new symbol */
    public static final int  SYCO = 13;  
    public static final int  SYIN = 14;
    public static final int  SYMA = 15;
    public static final int  BUILT_IN = 16; // was SEPR = 16;
    /* miscellaneous */
    public static final int  ACCU = 17; 
    public static final int  ATTR = 18;
    public static final int  EOSY = 19;
    public static final int  EOS  = 20;
    
    /** 
     *  code for the semantic action
     */
    private int action;
    
    /** 
     *  additional information: symbol number ...
     */
    private int info;
    
    /**
     *  Empty Constructor - creates a new semantic action
     */
    public SemAction() {
        action  = UNCHANGED;
        info    = 0;
    }
    
    /**
     *  Constructor - creates a new semantic action
     *  @param code code of the semantic action
     *  @param index additional info, number of a symbol
     */
    public SemAction(int code, int index) {
        action  = code;
        info    = index;
    }
    
    /**
     *  Gets the action code
     */
    public int getAction() {
        return action;
    }

    /**
     *  Sets the action code
     *  @param code code of the semantic action
     */
    public void setAction(int code) {
        action = code;
    }

    /**
     *  Gets the additional information (symbol number)
     */
    public int getInfo() {
        return info;
    }

    /**
     *  Sets the additional information (symbol number)
     *  @param index additional info, number of a symbol
     */
    public void setInfo(int index) {
        info = index;
    }

    /**
     *  Returns a human readable description of the object
     *  @return XML string rerpresenting the object
     */
    public String toString() {
        return "<sema act=\"" + action + "\" inf=\"" + info + "\" />";
    }

    //------------------------------------------------------------
    /**
     *  Test Frame
     */     
    public static void main (String args[]) { 
    } // main
}
