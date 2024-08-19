/*
    ParserGenerator.java: all-in-one LR(1) parser generator
    @(#) $Id$
    2024-08-19, Georg Fischer: reattempt
    2023-12-30 automatically translated from gen4.pl 
*/
import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.List;
import java.util.Map;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;

public class ParserGenerator {
    private static int debug = 0;
    private static TreeMap<String, List<Integer>> rules = new TreeMap<>(); // left -> list of indexes in prod
    private static List<String> prods = new ArrayList<>(); // flattened: left, mem1, mem2, ... memk, -k
    private static String hyper = "hyper_axiom"; // artificial first left side
    private static String axiom; // first left side of the user's grammar
    private static String left; // symbol on the left side
    private static String right; // a right side, several productions
    private static List<String> symQueue = new ArrayList<>(); // queue of (non-terminal, defined in %rules) symbols to be expanded
    private static Map<String, Boolean> symDone = new HashMap<>(); // history of @symQueue: defined iff symbol is already expanded
    private static List<List<Integer>> states = new ArrayList<>(); // state number -> array of items; [0] and [1] are not used.
    private static List<List<Integer>> succs = new ArrayList<>(); // state number -> array of successor states
    private static List<List<Integer>> preits = new ArrayList<>(); // state number -> array of items
    private static List<List<Integer>> preds = new ArrayList<>(); // state number -> array of predecessor states
    private static List<Integer> itemQueue = new ArrayList<>(); // List of items with symbols that must be expanded.
    private static Map<String, List<Integer>> symStates = new HashMap<>(); // symbol -> list of states with an item that has the marker before this symbol
    private static int acceptState; // the parser accepts the sentence when it reaches this state
    private static Map<Integer, Boolean> itemDone = new HashMap<>(); // history of %itemQueue: defined iff the item was already enqueued (in this iteration)
    private static List<Integer> laheads = new ArrayList<>(); // $succs(reduce item) -> index of (lalist, -1) when lookahead symbols are needed
    private static Map<Integer, Boolean> conStates = new HashMap<>(); // states with conflicts: they get lookaheads for all reduce items

    public static void main(String[] args) {
        // evaluate commandline arguments
        String fileName = "";
        int iarg = 0;
        try {
            while (iarg < args.length) {
                String arg = args[iarg ++];
                if (false) {
                } else if (arg.equals("-d")) {
                    debug    = Integer.parseInt(args[iarg ++]);
                } else if (arg.equals("-f")) {
                    fileName = args[iarg ++];
                }
            } // while args
            // Reader for the source file
            BufferedReader reader = new BufferedReader(
                    (fileName == null || fileName.length() <= 0 || fileName.equals("-"))
                    ? new InputStreamReader(System.in)
                    : new FileReader (fileName)
                    );

            initGrammar();
            String line = ""; // read input line
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (false) {
                } else if (line.matches("\\A *\\[ *(\\w+) *= *(\\w+)")) { // [ axiom = @rights
                    String[] parts = line.split("=");
                    left = parts[0].trim();
                    right = parts[1].trim();
                    axiom = left;
                    appendToProds(left, right);
                } else if (line.matches("\\A *\\. *(\\w+) *= *(.+)")) { // .left = @rights
                    String[] parts = line.split("=");
                    left = parts[0].trim();
                    right = parts[1].trim();
                    appendToProds(left, right);
                } else if (line.matches("\\A *\\| *(.+)")) { // | @rights
                    right = line.substring(1).trim();
                    appendToProds(left, right);
                } else if (line.matches("\\A *\\]")) {
                    break;
                }
            } // while line
        } catch (Exception exc) {
            System.err.println(exc.getMessage());
            exc.printStackTrace();;
        } // catch
        printGrammar();
        symQueue.add(hyper);
        symDone.put(hyper, true);
        dumpGrammar();
        statistics();
        initTable();
        dumpTable();
        walkGrammar();
        statistics();
        addLAheads();
        dumpTable();
    } // main

    private static void initGrammar() {
        prods.add(0, null); // [0] is not used
        rules.put(hyper, List.of(prods.size()));
        prods.add(hyper);
        prods.add(axiom);
        prods.add("eof");
        prods.add(String.valueOf(-2));
    }

    private static void appendToProds(String left, String right) {
        String[] rights = right.split("\\|");
        for (String prod : rights) {
            int iprod = prods.size();
            if (rules.containsKey(left)) {
                List<Integer> indexes = rules.get(left);
                indexes.add(iprod);
            } else {
                rules.put(left, new ArrayList<>(List.of(iprod)));
            }
            prods.add(left);
            prod = prod.trim();
            String[] mems = prod.split("\\s+");
            for (String mem : mems) {
                prods.add(mem);
            }
            prods.add(String.valueOf(-mems.length));
        }
    }

    private static void printGrammar() {
        System.out.println("/* printGrammar */");
        String dot = "[  ";
        for (String left : rules.keySet()) {
            System.out.print(dot + left);
            dot = "  .";
            String sep = " =";
            for (int iprod : rules.get(left)) {
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

    private static void dumpGrammar() {
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
                    }
                    iprod++;
                }
                String mem = prods.get(iprod);
                System.out.println(" [" + iprod + "] " + mem);
            }
        }
        System.out.println("]\n");
    }

    private static boolean isEOP(int item) {
        return prods.get(item).startsWith("-");
    }

    private static void statistics() {
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

    private static void initTable() {
        acceptState = 4;
        states.add(List.of(0));
        states.add(List.of(0));
        succs.add(List.of(0));
        succs.add(List.of(0));
        int state = 2;
        states.add(List.of(state));
        enqueueProds(axiom, state);
        state++;
        succs.add(List.of(state));
        states.add(List.of(state++));
        succs.add(List.of(acceptState));
        System.out.println("/* initTable, acceptState=" + acceptState + " */\n");
        laheads = List.of(-1, -1);
    }

    private static void enqueueProds(String left, int state) {
        System.out.println("  enqueueProds(left=" + left + ", state=" + state + ")");
        boolean busy = true;
        int syix = 0;
        while (busy && syix < symStates.get(left).size()) {
            if (state == symStates.get(left).get(syix)) {
                busy = false;
                System.out.println("    found state " + state + " in symStates{" + left + "}[" + syix + "]");
            }
            syix++;
        }
        if (busy) {
            symStates.get(left).add(state);
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

    private static void walkGrammar() {
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

    private static void insertProdsIntoState(String left, int state) {
        System.out.println("insert prods(" + left + ") into " + state);
        for (int item : rules.get(left)) {
            item++;
            walkLane(item, state);
        }
    }

    private static void walkLane(int item, int state) {
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

    private static int findSuccessor(int item, int state) {
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

    private static int chainStates(int item, int state, int succ) {
        int stix = states.get(state).size();
        states.get(state).add(item);
        succs.get(state).add(succ);
        if (!isEOP(item)) {
            int ptix = preds.get(succ).size();
            preits.get(succ).add(item);
            preds.get(succ).add(state);
        }
        return succ;
    }

    private static void dumpTable() {
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

    private static String markedItem(int item, int succ) {
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
                int mem = Integer.parseInt(prods.get(item));
                if (isEOP(item)) {
                    String left = prods.get(item + mem - 1);
                    result.append(sep).append("(").append(left).append(",").append(-mem).append(")");
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
        if (succ > 0) {
            result.append(" -> ").append(succ);
        }
        return result.toString();
    }

    private static int findPredecessor(int item, int state) {
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

    private static int delta(String mem, int state) {
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

    private static void linkToLAList(int succ, int state, int stix) {
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

    private static void walkBack(int item, int state, int stix) {
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

    private static void addLAheads() {
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

