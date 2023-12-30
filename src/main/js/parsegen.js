// Prototype parser generator, version 4: read input file
// @(#) $Id$
// 2022-02-12: LR(1) after 41 years?!
// 2022-02-11: walkLane
// 2022-02-10, Georg Fischer
"use strict";
let debug = 1;
let rules = {}; // left -> list of indexes in prod
let prods = []; // flattened: left, mem1, mem2, ... memk, -k
let hyper = "hyper_axiom"; // artificial first left side
let axiom; // first left side of the user's grammar
let left; // symbol on the left side
let right; // a right side, several productions
function initGrammar() {
    prods.push(0); // [0] is not used
    rules[hyper] = prods.length;
    prods.push(hyper);
    prods.push(axiom);
    prods.push("eof");
    prods.push(-2);
} // initGrammar
let lines = `__DATA__
[axiom = S
    .S = A a | B b
       | d A b | d B a
    .A = c
    .B = c
]`.split("\n");
let lineIndex = 0;
while (lineIndex < lines.length) {
    let line = lines[lineIndex];
    line = line.trim(); // chompr
    if (line === "") {
        lineIndex++;
        continue;
    }
    if (line.startsWith("[") && line.endsWith("]")) {
        let parts = line.substring(1, line.length - 1).split("=");
        left = parts[0].trim();
        right = parts[1].trim();
        axiom = left;
        initGrammar();
        appendToProds(left, right);
    } else if (line.startsWith(".")) {
        let parts = line.substring(1).split("=");
        left = parts[0].trim();
        right = parts[1].trim();
        appendToProds(left, right);
    } else if (line.startsWith("|")) {
        right = line.substring(1).trim();
        appendToProds(left, right);
    } else if (line === "]") {
        break;
    }
    lineIndex++;
} // while lineIndex
function appendToProds(left, right) {
    let rights = right.split("|");
    for (let i = 0; i < rights.length; i++) {
        let iprod = prods.length;
        if (rules.hasOwnProperty(left)) {
            rules[left] += "," + iprod;
        } else {
            rules[left] = iprod;
        }
        let prod = rights[i].trim();
        prods.push(left);
        prod = prod.trim();
        let mems = prod.split(" ");
        for (let j = 0; j < mems.length; j++) {
            prods.push(mems[j]);
        }
        prods.push(-mems.length);
    }
} // appendToProds
function printGrammar() { // write the grammar in alphabetical order of the left sides
    console.log("/* printGrammar */");
    let dot = "[  ";
    let lefts = Object.keys(rules).sort();
    for (let i = 0; i < lefts.length; i++) {
        let left = lefts[i];
        console.log(dot + left);
        dot = "  .";
        let indexes = rules[left].split(",");
        for (let j = 0; j < indexes.length; j++) {
            let iprod = parseInt(indexes[j]) + 1;
            let sep = " =";
            while (!isEOP(iprod)) {
                let mem = prods[iprod];
                console.log(sep + " " + mem);
                sep = " |";
                iprod++;
            }
        }
        console.log("");
    }
    console.log("]");
} // printGrammar
printGrammar();
let symQueue = [hyper]; // queue of (non-terminal, defined in rules) symbols to be expanded
let symDone = {}; // history of symQueue: defined iff symbol is already expanded
function dumpGrammar() { // expand the grammar tree
    console.log("/* dumpGrammar */");
    let dot = "[  ";
    while (symQueue.length > 0) { // queue not empty
        let left = symQueue.shift();
        let indexes = rules[left].split(",");
        for (let i = 0; i < indexes.length; i++) {
            console.log(dot + "[" + indexes[i] + "] " + left + " =");
            dot = "  .";
            let iprod = parseInt(indexes[i]) + 1;
            while (!isEOP(iprod)) {
                let mem = prods[iprod];
                console.log(" [" + iprod + "] " + mem);
                if (rules.hasOwnProperty(mem) && !symDone.hasOwnProperty(mem)) {
                    symQueue.push(mem);
                    symDone[mem] = 1;
                }
                iprod++;
            }
            let mem = prods[iprod];
            console.log(" [" + iprod + "] " + mem);
        }
    }
    console.log("]");
} // dumpGrammar
dumpGrammar();
// An item is an index into prods.
// The marker "@" is thought to be before the member prods[item].
let states = []; // state number -> array of items; [0] and [1] are not used.
let succs = []; // state number -> array of successor states
let preits = []; // state number -> array of items
let preds = []; // state number -> array of predecessor states
let itemQueue = []; // List of items with symbols that must be expanded.
let symStates = {}; // symbol -> list of states with an item that has the marker before this symbol
let acceptState; // the parser accepts the sentence when it reachs this state
let itemDone = {}; // history of itemQueue: defined iff the item was already enqueued (in this iteration)
let laheads = []; // succs(reduce item) -> index of (lalist, -1) when lookahead symbols are needed
let conStates = {}; // states with conflicts: they get lookaheads for all reduce items
function statistics() { // print counts of data structures
    console.log(sprintf("%4d rules", Object.keys(rules).length));
    console.log(sprintf("%4d members in productions", prods.length));
    console.log(sprintf("%4d states", states.length));
    console.log(sprintf("%4d successor states", succs.length));
    console.log(sprintf("%4d predecessor states", succs.length));
    console.log(sprintf("%4d potential conflicts", Object.keys(conStates).length));
    console.log(sprintf("%4d symStates", Object.keys(symStates).length));
    console.log(sprintf("%4d symDone", Object.keys(symDone).length));
    console.log(sprintf("%4d itemStates", itemQueue.length));
    console.log(sprintf("%4d itemDone", Object.keys(itemDone).length));
    console.log("");
} // statistics
statistics();
function markedItem(item, succ) { // legible item: the marker and the portion behind it, or a reduction
    let result = sprintf("%3d:", item);
    let sep;
    if (isEOP(item)) {
        sep = " ";
        if (succ < 0) {
            let ilah = -succ;
            while (laheads[ilah] !== "-") {
                sep += "," + laheads[ilah];
                ilah++;
            }
            if (sep.length >= 2) {
                sep = " " + sep.substring(2); // remove 1st comma
            }
        }
        sep += "=: ";
        succ = 0;
    } else {
        sep = " @";
    }
    let busy = 1;
    while (busy) {
        let mem = prods[item];
        if (isEOP(item)) { // last, @eop
            let left = prods[item + mem - 1];
            result += sep + "(" + left + "," + (-mem) + ")"; // reduce
            busy = 0;
        } else { // inside - shift
            result += sep + mem;
        }
        sep = " ";
        item++;
    }
    if (succ > 0) {
        result += " -> " + succ;
    }
    return result;
} // markedItem
function isEOP(item) { // whether the item's marker is at the end of a production
    return prods[item].startsWith("-") ? 1 : 0;
} // isEOP
function dumpTable() { // expand the grammar tree
    console.log("/* dumpTable */");
    //---- states
    for (let state = 2; state < states.length; state++) { // over all states
        let reduCount = 0; // number of reductions in this state
        let sep = sprintf("%-12s", sprintf("state [%3d]", state));
        let stix = 0;
        while (stix <= states[state].length) {
            let item = states[state][stix];
            if (isEOP(item)) {
                reduCount++;
            }
            if (succs[state][stix] === acceptState) {
                console.log(sep + sprintf("%3d:", item) + " =.");
            } else {
                console.log(sep + markedItem(item, succs[state][stix]));
            }
            sep = sprintf("%-12s", "");
            stix++;
        }
        if (reduCount > 0 && stix > 1) {
            conStates[state] = 1;
            console.log(sprintf("%-12s", "") + "==> potential conflict");
        }
    }
    //---- preits
    for (let succ = 4; succ < preds.length; succ++) { // over all predecessors
        let sep = sprintf("%-12s", sprintf("preds [%3d]", succ));
        let ptix = 0;
        while (ptix <= preits[succ].length) {
            let item = preits[succ][ptix];
            console.log(sep + markedItem(item, preds[succ][ptix]));
            sep = sprintf("%-12s", "");
            ptix++;
        }
    }
    //---- sysmStates
    let symbols = Object.keys(symStates).sort();
    for (let i = 0; i < symbols.length; i++) {
        let sym = symbols[i];
        let sep = "\t";
        let statesList = symStates[sym];
        console.log("symbol " + sym + " in states");
        for (let j = 0; j < statesList.length; j++) {
            console.log(sep + statesList[j]);
            sep = ", ";
        }
        console.log("");
    }
    //----laheads
    let nlah = laheads.length;
    if (nlah > 2) {
        console.log("lookahead lists:");
        for (let ilah = 0; ilah < nlah; ilah++) {
            let term = laheads[ilah];
            if (term.startsWith("-")) { // negative: end of list
                console.log(" <- state " + (-term));
            } else {
                console.log(" " + term);
            }
        }
        console.log("");
    }
    //----finally
    console.log("");
} // dumpTable
dumpTable();
function findSuccessor(item, state) { // Determine the next state reached by the marked symbol in an item.
    // Return
    // < 0 if item already present (negative successor)
    // > 0 if marked symbol found, but not the item
    // = 0 if nothing was found
    // and stix = index where to enter this item in states[state]
    let mem = prods[item];
    let result = 0; // neither item nor symbol found
    let stix = 0;
    let busy = 1;
    while (busy && stix <= states[state].length) { // while not found
        let item2 = states[state][stix];
        let mem2 = prods[item2];
        if (item === item2) { // same item found
            busy = 0;
            result = -succs[state][stix]; // negative successor
            console.log("  found item " + item2 + " in states[" + state + "][" + stix + "] => " + result);
        } else if (mem === mem2) { // marked symbol found
            busy = 0;
            result = succs[state][stix]; // positive successor
            console.log("  found member " + mem2 + " in states[" + state + "][" + stix + "] => " + result);
        }
        stix++;
    } // while stix
    if (busy === 1) {
        result = 0; // successor = 0
        console.log("  found no item " + item + " in states[" + state + "][" + stix + "] => " + result);
    }
    return result;
} // findSuccessor
function findPredecessor(item, state) { // Determine the previous state that reached the marked symbol.
    let result = 0; // predecessor state for this item not found
    let ptix = 0;
    let busy = 1;
    while (busy && ptix <= preits[state].length) { // while not found
        if (item === preits[state][ptix]) { // same item found
            busy = 0;
            result = preds[state][ptix];
        } // same item
        ptix++;
    } // while ptix
    if (busy === 1) {
        result = 0; // successor = 0
        console.log("  no predecessor found for item " + item + " in preits[" + state + "]");
    } else {
        console.log("  predecessor " + result + " found for item " + item + " in preits[" + state + "]");
    }
    return result;
} // findPredecessor
function chainStates(item, state) {
    let stix = states[state].length;
    states[state][stix] = item;
    succs[state][stix] = state;
    if (!isEOP(item)) { // succ is not valid otherwise
        let ptix = preds[state].length;
        preits[state][ptix] = item;
        preds[state][ptix] = state;
    }
    return state;
} // chainStates
function walkLane() { // follow a production starting at item, insert item in state and/or follow the lane
    let item = arguments[0];
    let state = arguments[1];
    console.log("walkLane from state " + state + " follow item " + markedItem(item, -1));
    let stix;
    let succ;
    let busy = 1;
    while (busy) {
        enqueueProds(prods[item], state);
        succ = findSuccessor(item, state); // > for symbol, < 0 for item, = 0 nothing found
        if (succ > 0) { // marked symbol found, but not the item: insert item anyway and follow to successor
            state = chainStates(item, state);
        } else if (succ < 0) { // same item found
            busy = 0; // break loop, quit lane
        } else if (succ === 0) { // succ === 0: allocate new state
            succ = states.length; // new state
            state = chainStates(item, state);
        }
        if (isEOP(item)) {
            busy = 0;
        }
        itemDone[item] = 1;
        item++;
    } // while busy, not at EOP
} // walkLane
function enqueueProds(left, state) {
    console.log("  enqueueProds(left=" + left + ", state=" + state + ")");
    let busy = 1;
    let syix = 0;
    while (busy === 1 && syix <= symStates[left].length) { // while not found
        if (state === symStates[left][syix]) { // found
            busy = 0;
            console.log("    found state " + state + " in symStates[" + left + "][" + syix + "]");
        }
        syix++;
    } // while
    if (busy === 1) { // not found
        symStates[left][syix] = state;
    }
    // now loop over the rule
    if (rules.hasOwnProperty(left)) { // is really a non-terminal
        let indexes = rules[left].split(",");
        for (let i = 0; i < indexes.length; i++) {
            let item = parseInt(indexes[i]) + 1; // $iprod and $item coincide
            if (!itemDone.hasOwnProperty(item)) { // not yet enqueued
                console.log("    enqueue item: " + left + " = " + markedItem(item, -1));
                itemQueue.push(item);
                //itemDone[item] = 1;
            } // not yet enqueued
        }
    } // if non-terminal
} // enqueueProds
function initTable() { // initialize the state table with
    acceptState = 4;
    states.push([0], [0]); // states 0, 1 are not used
    succs.push([0], [0]); // states 0, 1 are not used
    let state = 2;
    states.push([state]); // @axiom ...
    enqueueProds(axiom, state);
    state++;
    succs.push([state]); // ... -> 3
    states.push([state++]); // @eof
    succs.push([acceptState]); // ... "-> 4" = accept
    console.log("/* initTable, acceptState=" + acceptState + " */\n");
    laheads = [-1, -1];
} // initTable
initTable();
dumpTable();
function insertProdsIntoState(left, state) {
    console.log("insert prods(" + left + ") into " + state);
    let indexes = rules[left].split(",");
    for (let i = 0; i < indexes.length; i++) { // $iprod and $item coincide
        let item = parseInt(indexes[i]) + 1;
        walkLane(item, state);
    }
} // insertProdsIntoState
function walkGrammar() { // expand the grammar tree by inserting items from the queue
    console.log("/* walkGrammar */");
    itemDone = {}; // clear history of itemQueue
    while (itemQueue.length > 0) { // queue not empty
        let item = itemQueue.shift();
        let left = prods[item - 1];
        console.log("----------------");
        console.log("dequeue item: " + left + " = " + markedItem(item, -1));
        if (!itemDone.hasOwnProperty(item)) {
            // now insert the start of all productions of left into all states where left is marked in an item
            // follow those productions and eventually generate successor states
            for (let stix = 0; stix < symStates[left].length; stix++) {
                let state = symStates[left][stix];
                insertProdsIntoState(left, state);
            }
            dumpTable();
        } else {
            console.log("  already done");
        }
    }
} // walkGrammar
walkGrammar();
statistics();
function delta(mem, state) { // Determine the next state reached by a symbol. Assume a completed table.
    // > 0 if marked symbol found, but not the item
    // = 0 if nothing was found
    let result = 0; // neither item nor symbol found
    let stix = 0;
    let busy = 1;
    while (busy && stix <= states[state].length) { // while not found
        let item2 = states[state][stix];
        let mem2 = prods[item2];
        if (mem === mem2) { // marked symbol found
            busy = 0;
            result = succs[state][stix]; // positive successor
        }
        stix++;
    } // while stix
    if (busy === 1) {
        result = 0; // successor = 0
        console.log("  delta found no symbol " + mem + " in states[" + state + "]");
    } else {
        console.log("  delta(mem=" + mem + ", state=" + state + ") -> state " + result);
    }
    return result;
} // delta
function linkToLAList(succ, state, stix) {
    let ilah = laheads.length;
    succs[state][stix] = -ilah;
    console.log("    addLAheads(succ=" + succ + ", state=" + state + ", stix=" + stix + ") [" + ilah + "]: ");
    let teix = 0;
    while (teix <= states[succ].length) {
        let item = states[succ][teix];
        let mem = prods[item];
        if (!rules.hasOwnProperty(mem)) { // is terminal
            laheads[ilah++] = mem;
            console.log(" " + mem);
        } // terminal
        teix++;
    } // while teix
    laheads[ilah] = "-" + state; // end of sublist
    console.log(" ... [" + ilah + "] " + laheads[ilah]);
} // linkToLAList
function walkBack(item, state, stix) { // for a reduce item, determine the state that follows on the shift of the left side: the lookaheads are all terminals in that state
    console.log("/* walkBack(item=" + item + ", state=" + state + ", stix=" + stix + ") */");
    let prodLen = -prods[item];
    let iprod = prodLen;
    let pred = state;
    let busy = 1; // assume success
    while (iprod >= 1) { // count members backwards
        item--;
        pred = findPredecessor(item, pred);
        if (pred === 0) {
            busy = 0; // some failure?
        }
        iprod--;
    } // while iprod
    if (busy) { // now state shifts the left side
        item--;
        let left = prods[item];
        let succ = delta(left, pred);
        console.log("  walkBack found pred=" + pred + ", left=" + left + ", succ=" + succ);
        if (succ > 0) {
            linkToLAList(succ, state, stix);
        }
    }
} // walkBack
function addLAheads() { // for each state with potential conflicts: assign lookahead symbols to all reduce items
    console.log("/* addLAheads */");
    let statesList = Object.keys(conStates);
    for (let i = 0; i < statesList.length; i++) {
        let state = statesList[i];
        let stix = 0;
        while (stix <= states[state].length) { // while not found
            let item = states[state][stix];
            if (isEOP(item)) { // reduce item
                walkBack(item, state, stix);
            } // reduce item
            stix++;
        } // while stix
    }
} // addLAheads
addLAheads();
dumpTable();


