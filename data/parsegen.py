# Prototype parser generator, version 4: read input file
# @(#) $Id$
# 2022-02-12: LR(1) after 41 years?!
# 2022-02-11: walkLane
# 2022-02-10, Georg Fischer
import sys

debug = 1
rules = {}   # left -> list of indexes in prod
prods = []   # flattened: left, mem1, mem2, ... memk, -k
hyper = "hyper_axiom"  # artificial first left side
axiom = None  # first left side of the user's grammar
left = None   # symbol on the left side
right = None  # a right side, several productions

def initGrammar():
    prods.append(0) # [0] is not used
    rules[hyper] = len(prods)
    prods.append(hyper)
    prods.append(axiom)
    prods.append("eof")
    prods.append(-2)

def appendToProds(left, right):
    iprod = len(prods)
    if left in rules:
        rules[left] += ",{}".format(iprod)
    else:
        rules[left] = str(iprod)
    prods.append(left)
    right = right.strip()
    mems = right.split()
    for mem in mems:
        prods.append(mem)
    prods.append(-len(mems))

def printGrammar():
    print("/* printGrammar */")
    dot = "[  "
    for left in sorted(rules.keys()):
        print("{}{}".format(dot, left), end="")
        dot = "  ."
        sep = " ="
        for iprod in rules[left].split(","):
            iprod = int(iprod) + 1
            print("{}{}".format(sep, prods[iprod]), end="")
            sep = " |"
            iprod += 1
            while not isEOP(iprod):
                mem = prods[iprod]
                print(" {}".format(mem), end="")
                iprod += 1
        print()
    print("]\n")

def dumpGrammar():
    print("/* dumpGrammar */")
    dot = "[  "
    symQueue = [hyper] # queue of (non-terminal, defined in rules) symbols to be expanded
    symDone = {}  # history of symQueue: defined iff symbol is already expanded
    while len(symQueue) > 0: # queue not empty
        left = symQueue.pop(0)
        for iprod in rules[left].split(","):
            print("{}[{}] {} =".format(dot, int(iprod) + 1, left), end="")
            dot = "  ."
            iprod = int(iprod) + 1
            while not isEOP(iprod):
                mem = prods[iprod]
                print(" [{}] {}".format(iprod, mem), end="")
                if mem in rules and mem not in symDone:
                    symQueue.append(mem)
                    symDone[mem] = 1
                iprod += 1
            mem = prods[iprod]
            print(" [{}] {}".format(iprod, mem))
        print()
    print("]\n")

def statistics():
    print("{:4d} rules".format(len(rules)))
    print("{:4d} members in productions".format(len(prods)))
    print("{:4d} states".format(len(states)))
    print("{:4d} successor states".format(len(succs)))
    print("{:4d} predecessor states".format(len(succs)))
    print("{:4d} potential conflicts".format(len(conStates)))
    print("{:4d} symStates".format(len(symStates)))
    print("{:4d} symDone".format(len(symDone)))
    print("{:4d} itemStates".format(len(itemQueue)))
    print("{:4d} itemDone".format(len(itemDone)))
    print()

def markedItem(item, succ):
    result = "{:3d}:".format(item)
    sep = " "
    if isEOP(item):
        if succ < 0:
            ilah = -succ
            while not laheads[ilah].startswith("-"):
                sep += ",{}".format(laheads[ilah])
                ilah += 1
            if len(sep) >= 2:
                sep = " " + sep[2:] # remove 1st comma
        sep += "=: "
        succ = 0
    else:
        sep = " @"
    busy = True
    while busy:
        mem = prods[item]
        if isEOP(item): # last, @eop
            left = prods[item + mem - 1]
            result += "{}({},-{})".format(sep, left, -mem) # reduce
            busy = False
        else: # inside - shift
            result += "{}{}".format(sep, mem)
        sep = " "
        item += 1
    if succ > 0:
        result += " -> {}".format(succ)
    return result

def isEOP(item):
    return prods[item] < 0

def dumpTable():
    print("/* dumpTable */")
    for state in range(2, len(states)): # over all states
        reduCount = 0 # number of reductions in this state
        sep = "{:<12s}".format("state [{}]".format(state))
        stix = 0
        while stix <= len(states[state]):
            item = states[state][stix]
            if isEOP(item):
                reduCount += 1
            if succs[state][stix] == acceptState:
                print("{}{:3d}: =.".format(sep, item))
            else:
                print("{}{}".format(sep, markedItem(item, succs[state][stix])))
            sep = "{:<12s}".format("")
            stix += 1
        if reduCount > 0 and stix > 1:
            conStates[state] = 1
            print("{:<12s}==> potential conflict".format(""))
    for succ in range(4, len(preds)): # over all predecessors
        sep = "{:<12s}".format("preds [{}]".format(succ))
        ptix = 0
        while ptix <= len(preits[succ]):
            item = preits[succ][ptix]
            print("{}{}".format(sep, markedItem(item, preds[succ][ptix])))
            sep = "{:<12s}".format("")
            ptix += 1
    for sym in sorted(symStates.keys()):
        sep = "\t"
        print("symbol {} in states".format(sym), end="")
        for syix in range(len(symStates[sym])):
            print("{}{}".format(sep, symStates[sym][syix]), end="")
            sep = ", "
        print()
    nlah = len(laheads)
    if nlah > 2:
        print("lookahead lists:")
        ilah = 0
        while ilah < nlah:
            term = laheads[ilah]
            if term.startswith("-"): # negative: end of list
                print(" <- state {}".format(-int(term)))
            else:
                print(" {}".format(term))
            ilah += 1
        print()

def findSuccessor(item, state):
    mem = prods[item]
    result = 0 # neither item nor symbol found
    stix = 0
    busy = True
    while busy and stix <= len(states[state]): # while not found
        item2 = states[state][stix]
        mem2 = prods[item2]
        if item == item2: # same item found
            busy = False
            result = -succs[state][stix] # negative successor
        elif mem == mem2: # marked symbol found
            busy = False
            result = succs[state][stix] # positive successor
        stix += 1
    if busy:
        result = 0 # successor = 0
    return result

def findPredecessor(item, state):
    result = 0 # predecessor state for this item not found
    ptix = 0
    busy = True
    while busy and ptix <= len(preits[state]): # while not found
        if item == preits[state][ptix]: # same item found
            busy = False
            result = preds[state][ptix]
        ptix += 1
    return result

def chainStates(item, state):
    stix = len(states[state])
    states[state].append(item)
    succs[state].append(0)
    if not isEOP(item): # succ is not valid otherwise
        ptix = len(preits[succ])
        preits[succ].append(item)
        preds[succ].append(state)
    return succ

def walkLane(item, state):
    print("walkLane from state {} follow item {}".format(state, markedItem(item, -1)))
    succ = 0
    busy = True
    while busy:
        enqueueProds(prods[item], state)
        succ = findSuccessor(item, state) # > for symbol, < 0 for item, = 0 nothing found
        if succ > 0: # marked symbol found, but not the item: insert item anyway and follow to successor
            state = chainStates(item, state)
        elif succ < 0: # same item found
            busy = False # break loop, quit lane
        elif succ == 0: # succ == 0: allocate new state
            succ = len(states) # new state
            state = chainStates(item, state)
        if isEOP(item):
            busy = False
        itemDone[item] = 1
        item += 1

def enqueueProds(left, state):
    print("  enqueueProds(left={}, state={})".format(left, state))
    busy = True
    syix = 0
    while busy and syix <= len(symStates[left]): # while not found
        if state == symStates[left][syix]: # found
            busy = False
    if busy: # not found
        symStates[left].append(state)
    if left in rules: # is really a non-terminal
        for item in rules[left].split(","): # iprod and item coincide
            item = int(item) + 1
            if item not in itemDone: # not yet enqueued
                print("    enqueue item: {} = {}".format(left, markedItem(item, -1)))
                itemQueue.append(item)
                itemDone[item] = 1

def initTable():
    global acceptState
    acceptState = 4
    states.append([0]) # states 0, 1 are not used
    succs.append([0]) # states 0, 1 are not used
    state = 2
    states.append([state]) # @axiom ...
    enqueueProds(axiom, state)
    state += 1
    succs.append([state]) # ... -> 3
    states.append([state]) # @eof
    succs.append([acceptState]) # ... "-> 4" = accept
    print("/* initTable, acceptState={} */\n".format(acceptState))
    laheads.extend([-1, -1])

def insertProdsIntoState(left, state):
    print("insert prods({}) into {}".format(left, state))
    for item in rules[left].split(","): # iprod and item coincide
        item = int(item) + 1
        walkLane(item, state)

def walkGrammar():
    print("/* walkGrammar */")
    itemDone.clear() # clear history of itemQueue
    while len(itemQueue) > 0: # queue not empty
        item = itemQueue.pop(0)
        left = prods[item - 1]
        print("----------------")
        print("dequeue item: {} = {}".format(left, markedItem(item, -1)))
        if item not in itemDone:
            # now insert the start of all productions of left into all states where left is marked in an item
            # follow those productions and eventually generate successor states
            for stix in range(len(symStates[left])):
                state = symStates[left][stix]
                insertProdsIntoState(left, state)
            dumpTable()
        else:
            print("  already done")

def delta(mem, state):
    result = 0 # neither item nor symbol found
    stix = 0
    busy = True
    while busy and stix <= len(states[state]): # while not found
        mem2 = prods[states[state][stix]]
        if mem == mem2: # marked symbol found
            busy = False
            result = succs[state][stix] # positive successor
        stix += 1
    if busy:
        result = 0 # successor = 0
    return result

def linkToLAList(succ, state, stix):
    ilah = len(laheads)
    succs[state][stix] = -ilah
    print("    addLAheads(succ={}, state={}, stix={}) [{}]: ".format(succ, state, stix, ilah), end="")
    teix = 0
    while teix <= len(states[succ]):
        item = states[succ][teix]
        mem = prods[item]
        if mem not in rules: # is terminal
            laheads.append(mem)
            print(" {}".format(mem), end="")
        teix += 1
    laheads.append(-state) # end of sublist
    print(" ... [{}] {}".format(ilah, laheads[ilah]))

def walkBack(item, state, stix): # for a reduce item, determine the state that follows on the shift of the left side: the lookaheads are all terminals in that state
    print("/* walkBack(item={}, state={}, stix={}) */".format(item, state, stix))
    prodLen = -prods[item]
    iprod = prodLen
    pred = state
    busy = True # assume success
    while iprod >= 1: # count members backwards
        item -= 1
        pred = findPredecessor(item, pred)
        if pred == 0:
            busy = False # some failure?
        iprod -= 1
    if busy: # now state shifts the left side
        item -= 1
        left = prods[item]
        succ = delta(left, pred)
        print("  walkBack found pred={}, left={}, succ={}".format(pred, left, succ))
        if succ > 0:
            linkToLAList(succ, state, stix)

def addLAheads(): # for each state with potential conflicts: assign lookahead symbols to all reduce items
    print("/* addLAheads */")
    for state in sorted(conStates.keys()):
        stix = 0
        while stix <= len(states[state]): # while not found
            item = states[state][stix]
            if isEOP(item): # reduce item
                walkBack(item, state, stix)
            stix += 1

initGrammar()
while True:
    line = sys.stdin.readline()
    if not line:
        break
    line = line.rstrip() # chompr
    if line.startswith("["):
        left, right = line[1:].split("=", 1)
        left = left.strip()
        right = right.strip()
        axiom = left
        initGrammar()
        appendToProds(left, right)
    elif line.startswith("."):
        left, right = line[1:].split("=", 1)
        left = left.strip()
        right = right.strip()
        appendToProds(left, right)
    elif line.startswith("|"):
        right = line[1:].strip()
        appendToProds(left, right)
    elif line.startswith("]"):
        break

printGrammar()
symQueue = [hyper] # queue of (non-terminal, defined in rules) symbols to be expanded
symDone = {}  # history of symQueue: defined iff symbol is already expanded
dumpGrammar()
states = [[0], [0]] # states 0, 1 are not used
succs = [[0], [0]] # states 0, 1 are not used
preits = [[] for _ in range(2)] # state number -> array of items
preds = [[] for _ in range(2)] # state number -> array of predecessor states
itemQueue = [] # List of items with symbols that must be expanded.
symStates = {} # symbol -> list of states with an item that has the marker before this symbol
acceptState = None # the parser accepts the sentence when it reachs this state
itemDone = {} # history of itemQueue: defined iff the item was already enqueued (in this iteration)
laheads = [] # succs(reduce item) -> index of (lalist, -1) when lookahead symbols are needed
conStates = {} # states with conflicts: they get lookaheads for all reduce items
statistics()
initTable()
dumpTable()
walkGrammar()
statistics()
addLAheads()
dumpTable()


