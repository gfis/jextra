/*
    ParserGenerator.java: All-in-one LR(1) parser generator
    @(#) $Id$
    2024-08-19, Georg Fischer: reattempt
    2023-12-30 automatically translated from gen4.pl
*/
import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.List;
import java.util.Scanner;
import java.io.File;

public class ParserGenerator {
    private int debug;       // debugging mode: 0=none, 1=some, 2=more
    private String hyper;    // artificial first left side
    private String axiom;    // first left side of the user's grammar
    private int acceptState; // the parser accepts the sentence when it reaches this state
    private ArrayList<String>              prods     = new ArrayList<>(); // flattened: left, mem1, mem2, ... memk, -k
    private TreeMap<String, List<Integer>> rules     = new TreeMap<>();   // left -> list of indexes in prod
    private ArrayList<String>              symQueue  = new ArrayList<>(); // queue of (non-terminal, defined in rules) symbols to be expanded
    private HashMap<String, Boolean>       symDone   = new HashMap<>();   // history of @symQueue: defined iff symbol is already expanded
    private HashMap<String, List<Integer>> symStates = new HashMap<>();   // symbol -> list of states with an item that has the marker before this symbol
    private ArrayList<List<Integer>>       states    = new ArrayList<>(); // state number -> array of items; [0] and [1] are not used.
    private ArrayList<List<Integer>>       succs     = new ArrayList<>(); // state number -> array of successor states
    private ArrayList<List<Integer>>       preits    = new ArrayList<>(); // state number -> array of items
    private ArrayList<List<Integer>>       preds     = new ArrayList<>(); // state number -> array of predecessor states
    private ArrayList<Integer>             itemQueue = new ArrayList<>(); // List of items with symbols that must be expanded.
    private HashMap<Integer, Boolean>      itemDone  = new HashMap<>();   // history of itemQueue: defined iff the item was already enqueued (in this iteration)
    private ArrayList<Integer>             laheads   = new ArrayList<>(); // succs(reduce item) -> index of (lalist, -1) when lookahead symbols are needed
    private HashMap<Integer, Boolean>      conStates = new HashMap<>();   // states with conflicts: they get lookaheads for all reduce items

    /**
     * Main program 
     * @param args commandline arguments: [-d mode] [-f fileName|-]
     * <ul>
     * <li>-d debug mode</li>
     * <li>-f fileName</li>
     */
    public static void main(String[] args) {
        // evaluate commandline arguments
        ParserGenerator pg = new ParserGenerator();
        String fileName = null;
        pg.debug = 0;
        int iarg = 0;
        try {
            // evaluate any commandline arguments
            while (iarg < args.length) {
                String arg = args[iarg ++];
                if (false) {
                } else if (arg.equals("-d")) {
                    pg.debug    = Integer.parseInt(args[iarg ++]);
                } else if (arg.equals("-f")) {
                    fileName = args[iarg ++];
                }
            } // while args
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();;
        } // catch
            
        pg.readGrammar(fileName);
        pg.printGrammar();
        pg.symQueue.add(pg.hyper);
        // symDone.put(hyper, true);
        pg.dumpGrammar();
        pg.statistics();
        pg.initTable();
        pg.dumpTable();
        pg.walkGrammar();
        pg.statistics();
        pg.addLAheads();
        pg.dumpTable();
    } // main
    
    /**
     * Initialize the grammar with the first rule for the {@link #hyper_axiom}
     */
    private void initGrammar() {
        hyper = "hyper_axiom";
        prods.add("null"); // [0] is not used
        rules.put(hyper, List.of(prods.size())); // the first production will start thereafter
        prods.add(hyper); 
        prods.add(axiom); // hyper_axiom = axiom eof . (length 2)
        prods.add("eof");
        prods.add(String.valueOf(-2));
    } // initGrammar

    /**
     * Read the grammar from a file and build the structures for rules and productions.
     * @param fileName input file
     */
    private void readGrammar(String fileName) {
        final int IN_HEAD = 1;    // looking for first "["
        final int IN_LEFT = 2;    // expecting the left side of a rule
        final int IN_RULE = 3;    // expecting "="
        final int IN_PROD = 4;    // expecting "="
        final int IN_TAIL = 5;    // after "]"d of a rule
        try {
            Scanner sc = (fileName == null || fileName.length() <= 0 || fileName.equals("-")) 
                ? new Scanner(System.in)
                : new Scanner(new File(fileName), "UTF-8");
            int state = IN_HEAD;
            String left = null;
            int iprod = prods.size();
            while (sc.hasNext()) {  
                String part = sc.next().trim();
                if (debug > 0) {
                    System.out.println("part=\"" + part + "\", state=" + state);
                }
                switch(state) {
                    default:
                    case IN_HEAD: // skip all before the first "["
                        if (part.equals("[")) {
                            axiom = null;
                            left = null;
                            state = IN_LEFT;
                        }
                        break;
                    case IN_LEFT: // after "[" or "." - start of a new rule
                        if (part.matches("\\w+")) { // valid left side
                            if (axiom == null) { // was not yet seen
                                axiom = part;
                                initGrammar();
                            }
                            left = part; 
                            iprod = prods.size();
                            prods.add(left);
                            if (!rules.containsKey(left)) { // there is no rule yet with this left side
                                rules.put(left, new ArrayList<>());
                            }
                            rules.get(left).add(iprod);
                            state = IN_RULE;
                        } else {
                            System.err.println("part=\"" + part + "\" is no valid left side");
                        }
                        break;
                    case IN_RULE: // expecting "="
                        if (part.equals("=")) {
                            state = IN_PROD;
                        } else {
                            System.err.println("part=\"" + part + "\" instead of \"=\" or \"|\"");
                        }
                        break;
                    case IN_PROD: // append the members of the production
                        if (false) {
                        } else if (part.matches("\\w+")) { // valid member
                            prods.add(part);
                        } else if (part.equals("|") || part.equals(".") || part.equals("]")) { // EOP
                            int memNo = prods.size() - iprod - 1; // left side is not counted
                            prods.add(String.valueOf(-memNo));
                            if (false) {
                            } else if (part.equals(".")) {
                                state = IN_LEFT;
                            } else if (part.equals("]")) {
                                state = IN_TAIL;
                            } else { // continue with same rule
                                iprod = prods.size();
                                prods.add(left);
                                if (!rules.containsKey(left)) { // there is no rule yet with this left side
                                    rules.put(left, new ArrayList<>());
                                }
                                rules.get(left).add(iprod);
                                state = IN_PROD;
                            }
                        } else {
                            System.err.println("part=\"" + part + "\" is no valid member");
                        }
                        break;
                    case IN_TAIL: // after "]" - skip all following
                        break;
                } // switch state
            } // while sc.hasNext
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();;
        } // catch
    } // readGrammar

    private void printGrammar() {
        System.out.println("/* printGrammar */");
        String dot = "[  ";
        for (String left : rules.keySet()) {
            System.out.print(dot + left);
            dot = "  .";
            String sep = " =";
            for (int iprod : rules.get(left)) {
                iprod ++;
                try {
                    // int iprod = prod; // Integer.parseInt(prod) + 1;
                    System.out.print(sep);
                    sep = " |";
                    while (!isEOP(iprod)) {
                        String mem = prods.get(iprod);
                        System.out.print(" " + mem);
                        iprod++;
                    }
                } catch (Exception exc) {
                    System.err.println("printGrammar: exc, left=" + left + ", iprod=" + iprod);
                }
            }
            System.out.println();
        }
        System.out.println("]\n");
    }

    private void dumpGrammar() {
        System.out.println("/* dumpGrammar */");
        String dot = "[  ";
        while (!symQueue.isEmpty()) {
            String left = symQueue.remove(0);
            for (int iprod : rules.get(left)) {
                System.out.print(dot + "[" + iprod + "] " + left + " =");
                dot = "  .";
                iprod++;
                while (!isEOP(iprod)) {
                    String mem = prods.get(iprod);
                    System.out.print(" [" + iprod + "] " + mem);
                    if (rules.containsKey(mem) && !symDone.containsKey(mem)) {
                        symQueue.add(mem);
                        symDone.put(mem, true);
                        if (debug > 1) {
                            System.out.println("\n\tsymDone{" + mem + "} = true");
                        }
                    }
                    iprod++;
                }
                String mem = prods.get(iprod);
                System.out.println(" [" + iprod + "] " + mem);
            }
        }
        System.out.println("]\n");
    }

    private boolean isEOP(int item) {
        return prods.get(item).startsWith("-");
    }

    private void statistics() {
        System.out.printf("%4d rules\n", rules.size());
        System.out.printf("%4d members in productions\n", prods.size());
        System.out.printf("%4d states\n", states.size());
        System.out.printf("%4d successor states\n", succs.size());
        System.out.printf("%4d predecessor states\n", succs.size());
        System.out.printf("%4d potential conflicts\n", conStates.size());
        System.out.printf("%4d symStates\n", symStates.size());
        System.out.printf("%4d symDone\n", symDone.size());
        System.out.printf("%4d itemStates\n", itemQueue.size());
        System.out.printf("%4d itemDone\n\n", itemDone.size());
    }

    private void initTable() {
        acceptState = 4;
        states.add(List.of(0, 0));
        states.add(List.of(0));
        succs.add(List.of(0, 0));
        succs.add(List.of(0));
        int state = 2;
        states.add(List.of(state));
        enqueueProds(axiom, state);
        state ++;
        succs.add(List.of(state));
        states.add(List.of(state ++));
        succs.add(List.of(acceptState));
        System.out.println("/* initTable, acceptState=" + acceptState + " */\n");
        laheads.add(-1);
        laheads.add(-1);
    }

    private void enqueueProds(String left, int state) {
        System.out.println("  enqueueProds(left=" + left + ", state=" + state + ")");
        boolean busy = true;
        int syix = 0;
        if (symStates.get(left) != null) {
            while (busy && syix < symStates.get(left).size()) {
                if (state == symStates.get(left).get(syix)) {
                    busy = false;
                    System.out.println("    found state " + state + " in symStates{" + left + "}[" + syix + "]");
                }
                syix++;
            } // while busy
            if (busy) {
                symStates.get(left).add(state);
            }
        } else { // no such symState so far
            symStates.put(left, new ArrayList<>(List.of(state)));
        }
        if (rules.containsKey(left)) {
            for (int item : rules.get(left)) {
                item++;
                if (!itemDone.containsKey(item)) {
                    System.out.println("    enqueue item: " + left + " = " + markedItem(item, -1));
                    itemQueue.add(item);
                }
            }
        }
    }

    private void walkGrammar() {
        System.out.println("/* walkGrammar */");
        itemDone.clear();
        while (!itemQueue.isEmpty()) {
            int item = itemQueue.remove(0);
            String left = prods.get(item - 1);
            System.out.println("----------------");
            System.out.println("dequeue item: " + left + " = " + markedItem(item, -1));
            if (!itemDone.containsKey(item)) {
                for (int stix = 0; stix < symStates.get(left).size(); stix++) {
                    int state = symStates.get(left).get(stix);
                    insertProdsIntoState(left, state);
                }
                dumpTable();
            } else {
                System.out.println("  already done");
            }
        }
    }

    private void insertProdsIntoState(String left, int state) {
        System.out.println("insert prods(" + left + ") into " + state);
        for (int item : rules.get(left)) {
            item++;
            walkLane(item, state);
        }
    }

    private void walkLane(int item, int state) {
        System.out.println("walkLane from state " + state + " follow item " + markedItem(item, -1));
        int stix;
        int succ;
        boolean busy = true;
        while (busy) {
            enqueueProds(prods.get(item), state);
            succ = findSuccessor(item, state);
            if (succ > 0) {
                state = chainStates(item, state, succ);
            } else if (succ < 0) {
                busy = false;
            } else if (succ == 0) {
                succ = states.size();
                state = chainStates(item, state, succ);
            }
            if (isEOP(item)) {
                busy = false;
            }
            itemDone.put(item, true);
            item++;
        }
    }

    private int findSuccessor(int item, int state) {
        String mem = prods.get(item);
        int result = 0;
        int stix = 0;
        boolean busy = true;
        while (busy && stix < states.get(state).size()) {
            int item2 = states.get(state).get(stix);
            String mem2 = prods.get(item2);
            if (item == item2) {
                busy = false;
                result = -succs.get(state).get(stix);
                System.out.println("  found item " + item2 + " in states[" + state + "][" + stix + "] => " + result);
            } else if (mem.equals(mem2)) {
                busy = false;
                result = succs.get(state).get(stix);
                System.out.println("  found member " + mem2 + " in states[" + state + "][" + stix + "] => " + result);
            }
            stix++;
        }
        if (busy) {
            result = 0;
            System.out.println("  found no item " + item + " in states[" + state + "][" + stix + "] => " + result);
        }
        return result;
    }

    private int chainStates(int item, int state, int succ) {
        int stix = states.get(state).size();
        List<Integer> 
        temp = states.get(state); temp.add(item); // states.get(state).add(item);
        temp = succs.get(state); temp.add(succ);
        if (!isEOP(item)) {
            int ptix = preds.get(succ).size();
            temp = preits.get(succ); temp.add(item);  // preits.get(succ).add(item);
            temp = preds.get(succ);  temp.add(state); // preds.get(succ).add(state);
        }
        return succ;
    }

    private void dumpTable() {
        System.out.println("/* dumpTable */");
        for (int state = 2; state < states.size(); state++) {
            int reduCount = 0;
            String sep = String.format("%-12s", String.format("state [%3d]", state));
            int stix = 0;
            while (stix < states.get(state).size()) {
                int item = states.get(state).get(stix);
                if (isEOP(item)) {
                    reduCount++;
                }
                if (succs.get(state).get(stix) == acceptState) {
                    System.out.println(sep + String.format("%3d:", item) + " =.");
                } else {
                    System.out.println(sep + markedItem(item, succs.get(state).get(stix)));
                }
                sep = String.format("%-12s", "");
                stix++;
            }
            if (reduCount > 0 && stix > 1) {
                conStates.put(state, true);
                System.out.println(String.format("%-12s", "") + "==> potential conflict");
            }
        }
        for (int succ = 4; succ < preds.size(); succ++) {
            String sep = String.format("%-12s", String.format("preds [%3d]", succ));
            int ptix = 0;
            while (ptix < preits.get(succ).size()) {
                int item = preits.get(succ).get(ptix);
                System.out.println(sep + markedItem(item, preds.get(succ).get(ptix)));
                sep = String.format("%-12s", "");
                ptix++;
            }
        }
        for (String sym : symStates.keySet()) {
            String sep = "\t";
            System.out.print("symbol " + sym + " in states");
            for (int syix = 0; syix < symStates.get(sym).size(); syix++) {
                System.out.print(sep + symStates.get(sym).get(syix));
                sep = ", ";
            }
            System.out.println();
        }
        int nlah = laheads.size();
        if (nlah > 2) {
            System.out.println("lookahead lists:");
            for (int ilah = 0; ilah < nlah; ilah++) {
                int term = laheads.get(ilah);
                if (term < 0) {
                    System.out.println(" <- state " + (-term));
                } else {
                    System.out.print(" " + term);
                }
            }
            System.out.println();
        }
        System.out.println();
    }

    private String markedItem(int item, int succ) {
        StringBuilder result = new StringBuilder(String.format("%3d:", item));
        String sep;
        if (isEOP(item)) {
            sep = " ";
            if (succ < 0) {
                int ilah = -succ;
                while (!laheads.get(ilah).equals("-")) {
                    sep += "," + laheads.get(ilah);
                    ilah++;
                }
                if (sep.length() >= 2) {
                    sep = " " + sep.substring(2);
                }
            }
            sep += "=:";
            succ = 0;
        } else {
            sep = " @";
        }
        try {
            boolean busy = true;
            while (busy) {
                String mem = prods.get(item);
                if (isEOP(item)) {
                    int memNo = Integer.parseInt(mem); // negative number of members
                    String left = prods.get(item + memNo - 1);
                    result.append(sep).append("(").append(left).append(",").append(-memNo).append(")");
                    busy = false;
                } else {
                    result.append(sep).append(mem);
                }
                sep = " ";
                item++;
            }
        } catch(Exception exc) {
            // ignore
        }
        if (true || succ > 0) {
            result.append(" -> ").append(succ);
        }
        return result.toString();
    }

    private int findPredecessor(int item, int state) {
        int result = 0;
        int ptix = 0;
        boolean busy = true;
        while (busy && ptix < preits.get(state).size()) {
            if (item == preits.get(state).get(ptix)) {
                busy = false;
                result = preds.get(state).get(ptix);
            }
            ptix++;
        }
        if (busy) {
            result = 0;
            System.out.println("  no predecessor found for item " + item + " in preits[" + state + "]");
        } else {
            System.out.println("  predecessor " + result + " found for item " + item + " in preits[" + state + "]");
        }
        return result;
    }

    private int delta(String mem, int state) {
        int result = 0;
        int stix = 0;
        boolean busy = true;
        while (busy && stix < states.get(state).size()) {
            int item2 = states.get(state).get(stix);
            String mem2 = prods.get(item2);
            if (mem.equals(mem2)) {
                busy = false;
                result = succs.get(state).get(stix);
            }
            stix++;
        }
        if (busy) {
            result = 0;
            System.out.println("  delta found no symbol " + mem + " in states[" + state + "]");
        } else {
            System.out.println("  delta(mem=" + mem + ", state=" + state + ") -> state " + result);
        }
        return result;
    }

    private void linkToLAList(int succ, int state, int stix) {
        int ilah = laheads.size();
        succs.get(state).set(stix, -ilah);
        System.out.print("    addLAheads(succ=" + succ + ", state=" + state + ", stix=" + stix + ") [" + ilah + "]: ");
        int teix = 0;
        try {
            while (teix < states.get(succ).size()) {
                int item = states.get(succ).get(teix);
                int mem = Integer.parseInt(prods.get(item));
                if (!rules.containsKey(mem)) {
                    laheads.add(mem);
                    System.out.print(" " + mem);
                }
                teix++;
            } // while teix
        } catch(Exception exc) {
            // ignore
        }
        laheads.set(ilah, -state);
        System.out.println(" ... [" + ilah + "] " + laheads.get(ilah));
    }

    private void walkBack(int item, int state, int stix) {
        System.out.println("/* walkBack(item=" + item + ", state=" + state + ", stix=" + stix + ") */");
        int prodLen = 0;
        try {
            prodLen = -Integer.parseInt(prods.get(item));
        } catch(Exception exc) {
            // ignore
        }
        int iprod = prodLen;
        int pred = state;
        boolean busy = true;
        while (iprod >= 1) {
            item--;
            pred = findPredecessor(item, pred);
            if (pred == 0) {
                busy = false;
            }
            iprod--;
        }
        if (busy) {
            item--;
            String left = prods.get(item);
            int succ = delta(left, pred);
            System.out.println("  walkBack found pred=" + pred + ", left=" + left + ", succ=" + succ);
            if (succ > 0) {
                linkToLAList(succ, state, stix);
            }
        }
    }

    private void addLAheads() {
        System.out.println("/* addLAheads */");
        for (int state : conStates.keySet()) {
            int stix = 0;
            while (stix < states.get(state).size()) {
                int item = states.get(state).get(stix);
                if (isEOP(item)) {
                    walkBack(item, state, stix);
                }
                stix++;
            }
        }
    }
}
//: This is a direct translation of the Perl

