/*
    ParserGenerator.java: All-in-one LR(1) parser generator
    @(#) $Id$
    2024-08-19, Georg Fischer: retry
    2023-12-30: automatically translated from data/gen4.pl
    2022-02-12: LR(1) after 41 years?!
    2022-02-11: walkLane
    2022-02-10, Georg Fischer: gen4.pl
*/
import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.List;
import java.util.Scanner;
import java.io.File;

public class ParserGenerator {
    protected int debug;     // debugging mode: 0=none, 1=some, 2=more
    private String hyper;    // artificial first left side
    private String axiom;    // first left side of the user's grammar
    private int acceptState; // the parser accepts the sentence when it reaches this state
    private ArrayList<String>              prods      = new ArrayList<>(); // flattened: left, mem1, mem2, ... memk, -k
    private TreeMap<String, List<Integer>> rules      = new TreeMap<>();   // left -> list of indexes in prod
    private ArrayList<String>              symQueue   = new ArrayList<>(); // queue of (non-terminal, defined in rules) symbols to be expanded
    private HashMap<String, Boolean>       symDone    = new HashMap<>();   // history of @symQueue: defined iff symbol is already expanded
    private TreeMap<String, List<Integer>> symStates  = new TreeMap<>();   // symbol -> list of states with an item that has the marker before this symbol
    private ArrayList<List<Integer>>       states     = new ArrayList<>(); // state number -> array of items; [0] and [1] are not used.
    private ArrayList<List<Integer>>       succs      = new ArrayList<>(); // state number -> array of successor states
    private ArrayList<List<Integer>>       preits     = new ArrayList<>(); // state number -> array of items
    private ArrayList<List<Integer>>       preds      = new ArrayList<>(); // state number -> array of predecessor states
    private ArrayList<Integer>             itemQueue  = new ArrayList<>(); // List of items with symbols that must be expanded.
    private HashMap<Integer, Boolean>      itemDone   = new HashMap<>();   // history of itemQueue: defined iff the item was already enqueued (in this iteration)
    private ArrayList<String>              lookAheads = new ArrayList<>(); // succs(reduce item) -> index of (lalist, -1) when lookahead symbols are needed
    private HashMap<Integer, Boolean>      conStates  = new HashMap<>();   // states with conflicts: they get lookaheads for all reduce items

    /**
     * Main program
     * @param args commandline arguments: [-d mode] [-f fileName|-]
     * <ul>
     * <li>-d debug mode</li>
     * <li>-f fileName</li>
     */
    public static void main(String[] args) {
        ParserGenerator pg = new ParserGenerator();
        // evaluate any commandline arguments
        String fileName = null;
        pg.debug = 0;
        int iarg = 0;
        try {
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
        if (pg.debug >= 2) {
            pg.printGrammar();
        }
        pg.symQueue.add(pg.hyper);
        pg.dumpGrammar();
        if (pg.debug >= 2) {
            pg.statistics();
        }
        pg.initTable();
        if (pg.debug >= 2) {
            pg.dumpTable();
        }
        pg.walkGrammar();
        if (pg.debug >= 2) {
            pg.statistics();
        }
        pg.addLookAheads();

        pg.dumpTable();
        pg.statistics();
    } // main

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
                if (debug > 0 && debug < 4) {
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

    /**
     * Initialize the grammar with the first rule for the {@link #hyper_axiom}
     */
    private void initGrammar() {
        hyper = "hyper_axiom";
        prods.add("null"); // [0] is not used
        rules.put(hyper, new ArrayList<>());
        rules.get(hyper).add(prods.size()); // the first production will start thereafter
        prods.add(hyper);
        prods.add(axiom); // hyper_axiom = axiom eof . (length 2)
        prods.add("eof");
        prods.add(String.valueOf(-2));
    } // initGrammar

    /**
     * Write the grammar in alphabetical order of the left sides.
     */
    private void printGrammar() {
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
                    } // while ! EOP
                } catch (Exception exc) {
                    System.err.println("printGrammar: exc, left=" + left + ", iprod=" + iprod);
                }
            } // for iprod
            System.out.println();
        } // for left
        System.out.println("]");
    } // printGrammar

    /**
     * Expand the grammar tree.
     */
    private void dumpGrammar() {
        String dot = "[  ";
        while (!symQueue.isEmpty()) {
            String left = symQueue.remove(0);
            for (int iprod : rules.get(left)) {
                if (debug >= 2) {
                    System.out.print(dot + "[" + iprod + "] " + left + " =");
                }
                dot = "  .";
                iprod++;
                while (!isEOP(iprod)) {
                    String mem = prods.get(iprod);
                    if (debug >= 2) {
                        System.out.print(" [" + iprod + "] " + mem);
                    }
                    if (rules.containsKey(mem) && !symDone.containsKey(mem)) {
                        symQueue.add(mem);
                        symDone.put(mem, true);
                        if (debug >= 2) {
                            System.out.println("\n\tsymDone{" + mem + "} = true");
                        }
                    }
                    iprod++;
                } // while ! EOP
                String mem = prods.get(iprod);
                if (debug >= 2) {
                    System.out.println(" [" + iprod + "] " + mem);
                }
            } // for iprod
        } // while queue not empty
        if (debug >= 2) {
            System.out.println("]");
        }
    } // dumpGrammar

    /**
     * Print counts of data structures.
     */
    private void statistics() {
        System.out.println("Statistics:");
        System.out.printf("%4d rules\n", rules.size());
        System.out.printf("%4d members in productions\n", prods.size());
        System.out.printf("%4d states\n", states.size());
        System.out.printf("%4d successor states\n", succs.size());
        System.out.printf("%4d predecessor states\n", succs.size());
        System.out.printf("%4d potential conflicts\n", conStates.size());
        System.out.printf("%4d symStates\n", symStates.size());
        System.out.printf("%4d symDone\n", symDone.size());
        System.out.printf("%4d itemStates\n", itemQueue.size());
        System.out.printf("%4d itemDone\n", itemDone.size());
        System.out.printf("%4d lookAheads\n", lookAheads.size());
    } // statistics

    /**
     * Return a human legible item: the marker and the portion behind it,
     * or a reduction.
     */
    private String markedItem(int item, int succ) {
        StringBuilder result = new StringBuilder(String.format("%3d:", item));
        String sep;
        if (isEOP(item)) {
            sep = " ";
            if (succ < 0) {
                int ilah = -succ;
                while (ilah < lookAheads.size() && !lookAheads.get(ilah).startsWith("-")) {
                    sep += "," + lookAheads.get(ilah);
                    ilah++;
                } // while ilah
                if (sep.length() >= 2) {
                    sep = " " + sep.substring(2); // remove 1st comma
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
                if (isEOP(item)) { // last, @eop
                    int memNo = Integer.parseInt(mem); // negative number of members
                    String left = prods.get(item + memNo - 1);
                    result.append(sep).append("(").append(left).append(",").append(-memNo).append(")"); // reduce
                    busy = false;
                } else { // inside - shift
                    result.append(sep).append(mem);
                }
                sep = " ";
                item++;
            } // while item
        } catch(Exception exc) {
            // ignore
        }
        if (true || succ > 0) {
            result.append(" -> ").append(succ);
        }
        return result.toString();
    } // markedItem

    /**
     * Whether the marker is at the end of a production.
     */
    private boolean isEOP(int item) {
        return prods.get(item).startsWith("-");
    } // isEOP

    /**
     * Expand the grammar tree.
     */
    private void dumpTable() {
        System.out.println("dumpTable:");
        //---- states
        for (int state = 2; state < states.size(); state++) { // over all states
            int reduceCount = 0; // number of reductions in this state
            String sep = String.format("%-12s", String.format("state [%3d]", state));
            int stix = 0;
            while (stix  < states.get(state).size()) {
                int item = states.get(state).get(stix);
                if (isEOP(item)) {
                    reduceCount++;
                }
                if (succs.get(state).get(stix) == acceptState) {
                    System.out.println(sep + String.format("%3d:", item) + " =.");
                } else {
                    System.out.println(sep + markedItem(item, succs.get(state).get(stix)));
                }
                sep = String.format("%-12s", "");
                stix++;
            } // while stix
            if (reduceCount > 0 && stix > 1) {
                conStates.put(state, true);
                System.out.println(String.format("%-12s", "") + "==> potential conflict");
            }
        } // for states
        //----- succs
        for (int succ = 4; succ < preds.size(); succ++) { // over all predecessors
            String sep = String.format("%-12s", String.format("preds [%3d]", succ));
            int ptix = 0;
            while (ptix < preits.get(succ).size()) {
                int item = preits.get(succ).get(ptix);
                System.out.println(sep + markedItem(item, preds.get(succ).get(ptix)));
                sep = String.format("%-12s", "");
                ptix++;
            } // while ptix
        } // for succ
        //---- symStates
        for (String sym : symStates.keySet()) {
            String sep = "\t";
            System.out.print("symbol " + sym + " in states");
            for (int syix = 0; syix  < symStates.get(sym).size(); syix++) {
                System.out.print(sep + symStates.get(sym).get(syix));
                sep = ", ";
            }
            System.out.println();
        } // for sym
        //---- lookAheads
        int nlah = lookAheads.size();
        if (nlah > 2) {
            System.out.println("lookahead lists:");
            for (int ilah = 0; ilah < nlah; ilah++) {
                String term = lookAheads.get(ilah);
                if (term.startsWith("-")) { // negative: end of list
                    System.out.println(" <- state " + (term.substring(1)));
                } else {
                    System.out.print(" " + term);
                }
            } // for ilah
            System.out.println();
        } // nlah > 2
    } // dumpTable

    /**
     * Determine the next state reached by the marked symbol in an item.
     * @return
     * &lt; 0 if item already present (negative successor),
     * &gt; 0 if marked symbol found, but not the item,
     * = 0 if nothing was found,
     * and stix = index where to enter this item in states[state].
     */
    private int findSuccessor(int item, int state) {
        String mem = prods.get(item);
        int result = 0; // assume that neither item nor symbol was found yet
        int stix = 0;
        boolean busy = true;
        if (state < states.size()) { // !!!
            while (busy && stix < states.get(state).size()) { // while not found
                int item2 = states.get(state).get(stix);
                String mem2 = prods.get(item2);
                if (item == item2) { // same item found
                    busy = false;
                    result = -succs.get(state).get(stix); // negative successor
                    if (debug >= 2) {
                        System.out.println("  found item " + item2 + " in states[" + state + "][" + stix + "] => " + result);
                    }
                } else if (mem.equals(mem2)) { // marked symbol found
                    busy = false;
                    result = succs.get(state).get(stix); // positive successor
                    if (debug >= 2) {
                        System.out.println("  found member " + mem2 + " in states[" + state + "][" + stix + "] => " + result);
                    }
                }
                stix++;
            } // while busy, stix
        }
        if (busy) {
            result = 0; // successor := 0
            if (debug >= 2) {
                System.out.println("  found no item " + item + " in states[" + state + "][" + stix + "] => " + result);
            }
        }
        if (state >= states.size()) { // !!!
            states.add(new ArrayList<Integer>());
        }
        if (debug >= 2) {
            System.out.print("    findSuccessor: scalar(states)=" + states.size() + "\n");
        }
        return result;
    } // findSuccessor

    /**
     *
     */
    private int chainStates(int item, int state, int succ) {
        if (debug >= 4) {
            System.out.print("# chainStates(" + item + ", " + state + ", " + succ + ")\n");
        }
        while (states.size() <= state) {
            states.add(new ArrayList<Integer>());
        }
        states.get(state).add(item);
        while (succs .size() <= state) {
            succs .add(new ArrayList<Integer>());
        }
        succs .get(state).add(succ);
        if (!isEOP(item)) { // succ is not valid otherwise
            while (preits.size() <= succ) {
                preits.add(new ArrayList<Integer>());
            }
            preits.get(succ).add(item);
            while (preds .size() <= succ) {
                preds .add(new ArrayList<Integer>());
            }
            preds .get(succ).add(state);
        }
        if (debug >= 2) {
            System.out.print("    chainStates: scalar(states)=" + states.size() + "\n");
        }
        return succ;
    } // chainStates

    /**
     * Follow a production starting at item,
     * insert item in state and/or follow the lane.
     * @param item start at this item
     * @param state in this state
     */
    private void walkLane(int item, int state) {
        if (debug >= 1) {
            System.out.println("walkLane from state " + state + " follow item " + markedItem(item, -1));
        }
        int stix;
        int succ;
        boolean busy = true;
        while (busy) {
            enqueueProds(prods.get(item), state);
            succ = findSuccessor(item, state); // > for symbol, < 0 for item, = 0 nothing found
            if (debug >= 4) {
                System.out.print("# walkLane1: item=" + item + ", state=" + state + ", succ=" + succ + ", busy=" + (busy ? 1 : 0) + "\n");
            }
            if (false) {
            } else if (succ >  0) { // marked symbol found, but not the item: insert item anyway and follow to successor
                state = chainStates(item, state, succ);
            } else if (succ <  0) { // same item found
                busy = false; // break loop, quit lane
            } else { // succ == 0: allocate new state
                succ = states.size();
                state = chainStates(item, state, succ);
            }
            if (isEOP(item)) {
                busy = false;
            }
            if (debug >= 4) {
                System.out.print("# walkLane3: item=" + item + ", state=" + state + ", succ=" + succ + ", busy=" + (busy ? 1 : 0) + "\n");
            }
            itemDone.put(item, true);
            item++;
        } // while not at EOP
    } // walkLane

    /**
     * Enqueue items for all productions of <em>left</em> with the marker at the beginning,
     * and insert them in <em>state</em>.
     * Insert <em>state</em> into <em>symStates[left]</em> if not yet present.
     */
    private void enqueueProds(String left, int state) {
        if (debug >= 2) {
            System.out.println("  enqueueProds(left=" + left + ", state=" + state + ")");
        }
        boolean busy = true;
        int syix = 0;
        if (symStates.get(left) != null) {
            while (busy && syix < symStates.get(left).size()) {
                if (state == symStates.get(left).get(syix)) {
                    busy = false;
                    if (debug >= 2) {
                        System.out.println("    found state " + state + " in symStates{" + left + "}[" + syix + "]");
                    }
                }
                syix++;
            } // while busy
            if (busy) { // not found
                symStates.get(left).add(state);
            }
        } else { // no such symState so far
            symStates.put(left, new ArrayList<>()); symStates.get(left).add(state);
        }
        // now loop over the rule
        if (rules.containsKey(left)) { // is really a non-terminal
            for (int item : rules.get(left)) { // $iprod and $item coincide
                item++; // skip over left side
                if (!itemDone.containsKey(item)) { // not yet enqueued
                    if (debug >= 2) {
                        System.out.println("    enqueue item: " + left + " = " + markedItem(item, -1));
                    }
                    itemQueue.add(item);
                    // itemDone{$item} = true;
                } // not yet enqueued
            } // for item
        } // if non-terminal
        if (debug >= 2) {
            System.out.print("    enqueueProds: scalar(states)=" + states.size() + "\n");
        }
    } // enqueueProds

    /**
     * Initialize the state table.
     * States 0, 1 are not used.
     */
    private void initTable() {
        int state = 0;
        states.add(new ArrayList<Integer>()); states.get(state).add(0);
        succs .add(new ArrayList<Integer>()); succs .get(state).add(0);
        state++; // 1
        states.add(new ArrayList<Integer>()); states.get(state).add(0);
        succs .add(new ArrayList<Integer>()); succs .get(state).add(0);
        state++; // 2
        states.add(new ArrayList<Integer>()); states.get(state).add(state); // @axiom
        enqueueProds(axiom, state);
        state++; // 3
        succs .add(new ArrayList<Integer>()); succs .get(succs .size() - 1).add(state); // 2 -> 3
        states.add(new ArrayList<Integer>()); states.get(states.size() - 1).add(state++);
        acceptState = state; // 4
        succs .add(new ArrayList<Integer>()); succs .get(succs .size() - 1).add(acceptState); // 4
        if (debug >= 1) {
            System.out.println("initTable, acceptState=" + acceptState + ", scalar(states)= " + states.size());
        }
        lookAheads.add("-1");
        lookAheads.add("-1");
    } // initTable

    private void insertProdsIntoState(String left, int state) {
        if (debug >= 2) {
            System.out.println("insert prods(" + left + ") into " + state);
        }
        for (int item : rules.get(left)) { // iprod and item coincide
            item++; // skip over left side
            walkLane(item, state);
        } // for item
    } // insertProdsIntoState

    /**
     * Expand the grammar tree by inserting items from the queue.
     */
    private void walkGrammar() {
        if (debug >= 2) {
            System.out.println("walkGrammar");
        }
        itemDone.clear(); // clear history of %itemQueue
        while (!itemQueue.isEmpty()) {
            int item = itemQueue.remove(0);
            String left = prods.get(item - 1);
            if (debug >= 2) {
                System.out.println("----------------");
                System.out.println("dequeue item: " + left + " = " + markedItem(item, -1));
            }
            if (!itemDone.containsKey(item)) {
                // now insert the start of all productions of $left into all states where $left is marked in an item
                // follow those productions and eventually generate successor states
                for (int stix = 0; stix < symStates.get(left).size(); stix++) {
                    int state = symStates.get(left).get(stix);
                    insertProdsIntoState(left, state);
                } // for stix
                if (debug >= 3) {
                    dumpTable();
                }
            } else {
                if (debug >= 2) {
                    System.out.println("  already done");
                }
            }
        } // while queue not empty
    } // walkGrammar

    /**
     * Determine the next state reached by a symbol.
     * Assume a completed table.
     * @return &gt; 0 if marked symbol found, but not the item;
     * = 0 if nothing was found
     */
    private int delta(String mem, int state) {
        int result = 0; // assume that neither item nor symbol is found yet
        int stix = 0;
        boolean busy = true;
        while (busy && stix < states.get(state).size()) {
            int item2 = states.get(state).get(stix);
            String mem2 = prods.get(item2);
            if (mem.equals(mem2)) { // marked symbold found
                busy = false;
                result = succs.get(state).get(stix);
            }
            stix++;
        } // while stix
        if (busy) {
            result = 0; // successor = 0
            if (debug >= 2) {
                System.out.println("  delta found no symbol " + mem + " in states[" + state + "]");
            }
        } else {
            if (debug >= 2) {
                System.out.println("  delta(mem=" + mem + ", state=" + state + ") -> state " + result);
            }
        }
        return result;
    } // delta

    /**
     *
     */
    private void linkToLAList(int succ, int state, int stix) {
        int ilah = lookAheads.size();
        succs.get(state).set(stix, -ilah);
        if (debug >= 2) {
            System.out.print("    addLookAheads(succ=" + succ + ", state=" + state + ", stix=" + stix + ") [" + ilah + "]: ");
        }
        int teix = 0;
        while (teix  < states.get(succ).size()) {
            int item = states.get(succ).get(teix);
            String mem = prods.get(item);
            if (!rules.containsKey(mem)) { // is terminal
                lookAheads.add(mem);
                ilah = lookAheads.size();
                if (debug >= 2) {
                    System.out.print(" " + mem);
                }
            } // terminal
            teix++;
        } // while teix
        if (ilah < lookAheads.size()) { // !!!
            lookAheads.set(ilah, String.valueOf(-state)); // end of sublist
        } else {
            lookAheads.add(String.valueOf(-state));
        }
        if (debug >= 2) {
            System.out.println(" ... [" + ilah + "] " + lookAheads.get(ilah));
        }
    } // linkToLAList

    /**
     * Determine the previous state that reached the marked symbol.
     * If the item is a reduce item, succ is the negative length of the right side,
     * succs is 0
     */
    private int findPredecessor(int item, int state) {
        int result = 0; // assume predecessor state for this item not yt found
        int ptix = 0;
        boolean busy = true;
        while (busy && ptix < preits.get(state).size()) { // while not found
            if (item == preits.get(state).get(ptix)) { // same item found
                busy = false;
                result = preds.get(state).get(ptix);
            } // same item
            ptix++;
        } // while ptix
        if (busy) {
            result = 0; // successor = 0
            if (debug >= 2) {
                System.out.println("  no predecessor found for item " + item + " in preits[" + state + "]");
            }
        } else {
            if (debug >= 2) {
                System.out.println("  predecessor " + result + " found for item " + item + " in preits[" + state + "]");
            }
        }
        return result;
    } // findPredecessor

    /**
     * For a reduce item, determine the state that follows on the shift of the left side:
     * the lookaheads are all terminals in that state.
     * item is a reduce item, member is negative length of the right side, succs is 0
     */
    private void walkBack(int item, int state, int stix) {
        if (debug >= 1) {
            System.out.println("walkBack(item=" + item + ", state=" + state + ", stix=" + stix + ")");
        }
        int prodLen = 0;
        try {
            prodLen = -Integer.parseInt(prods.get(item));
        } catch(Exception exc) {
            // ignore
        }
        int iprod = prodLen;
        int pred = state;
        boolean busy = true; // assume success
        while (iprod >= 1) { // count members backwards
            item--;
            pred = findPredecessor(item, pred);
            if (pred == 0) {
                busy = false; // some failure?
            }
            iprod--;
        } // while iprod
        if (busy) { // now state shifts the left side
            item--;
            String left = prods.get(item);
            int succ = delta(left, pred);
            if (debug >= 2) {
                System.out.println("  walkBack found pred=" + pred + ", left=" + left + ", succ=" + succ);
            }
            if (succ > 0) {
                linkToLAList(succ, state, stix);
            }
        }
    } // walkBack

    /**
     * For each state with potential conflicts:
     * assign lookahead symbols to all reduce items.
     */
    private void addLookAheads() {
        if (debug >= 1) {
            System.out.println("addLookAheads");
        }
        for (int state : conStates.keySet()) {
            int stix = 0;
            while (stix  < states.get(state).size()) { // while not found
                int item = states.get(state).get(stix);
                if (isEOP(item)) { // reduce item
                    walkBack(item, state, stix);
                }
                stix++;
            } // while stix
        }
    } // addLookAheads

} // class ParserGenerator

