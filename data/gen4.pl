#!perl

# Prototype parser generator, version 4: read input file
# @(#) $Id$
# 2024-08-20: reordered subroutines
# 2022-02-12: LR(1) after 41 years?!
# 2022-02-11: walkLane
# 2022-02-10, Georg Fischer

use strict;
use warnings;
use integer;

    my $debug   = 1;
    my %rules   = (); # left -> list of indexes in prod
    my @prods   = (); # flattened: left, mem1, mem2, ... memk, -k
    my $hyper   = "hyper_axiom";  # artificial first left side
    my $axiom;  # first left side of the user's grammar
    my $left;   # symbol on the left side
    my $right;  # a right side, several productions
    # An item is an index into @prods.
    # The marker "@" is thought to be before the member prods[item].
    my @states    = (); # state number -> array of items; [0] and [1] are not used.
    my @succs     = (); # state number -> array of successor states
    my @preits    = (); # state number -> array of items
    my @preds     = (); # state number -> array of predecessor states
    my @itemQueue = (); # List of items with symbols that must be expanded.
    my %symStates = (); # symbol -> list of states with an item that has the marker before this symbol
    my $acceptState;    # the parser accepts the sentence when it reachs this state
    my %itemDone  = (); # history of %itemQueue: defined iff the item was already enqueued (in this iteration)
    my @laheads   = (); # $succs(reduce item) -> index of (lalist, -1) when lookahead symbols are needed
    my %conStates = (); # states with conflicts: they get lookaheads for all reduce items
    my @symQueue = ($hyper); # queue of (non-terminal, defined in %rules) symbols to be expanded
    my %symDone  = (); # history of @symQueue: defined iff symbol is already expanded
    
    while (scalar(@ARGV) > 0 and ($ARGV[0] =~ m{\A[\-\+]})) {
        my $opt = shift(@ARGV);
        if (0) {
        } elsif ($opt  =~ m{d}) {
            $debug     =  shift(@ARGV);
        } else {
            die "invalid option \"$opt\"\n";
        }
    } # while $opt
    
    while (<>) {
        my $line = $_;
        $line =~ s{\s+\Z}{}; # chompr
        if (0) {
        } elsif ($line =~ m{\A *\[ *(\w+) *\= *(\w+)}) { # [ axiom = @rights
            ($left, $right) = ($1, $2);
            $axiom = $left;
            &initGrammar();
            &appendToProds($left, $right);
        } elsif ($line =~ m{\A *\. *(\w+) *\= *(.+)})  { # .left = @rights
            ($left, $right) = ($1, $2);
            &appendToProds($left, $right);
        } elsif ($line =~ m{\A *\| *(.+)})             { # | @rights
            ($right) = ($1);
            &appendToProds($left, $right);
        } elsif ($line =~ m{\A *\]}) {
            last;
        }
    } # while <>
    # end main
    #----------------
    sub appendToProds() {
        my ($left, $right) = @_;
        my @rights = split(/ *\| */, $right);
        foreach my $prod (@rights) {
            my $iprod = scalar(@prods);
            if (defined($rules{$left})) {
                $rules{$left} .= ",$iprod";
            } else {
                $rules{$left} = $iprod;
            }
            # print "prod[$iprod]: $prod\n" if ($debug > 0);
            push(@prods, $left);
            $prod =~ s{\A +}{};
            $prod =~ s{ +\Z}{};
            my @mems = split(/ +/, $prod);
            foreach my $mem (@mems) {
                push(@prods, $mem);
            } # foreach $mem
            push(@prods, - scalar(@mems));
        } # foreach $prod
        # print "rules{$left} = $rules{$left}\n" if ($debug > 0);
    } # appendToProds
    
    sub initGrammar() {
        push(@prods, 0); # [0] is not used
        $rules{$hyper} = scalar(@prods);
        push(@prods, $hyper);
        push(@prods, $axiom);
        push(@prods, "eof");
        push(@prods, -2);
    } # initGrammar
    
    sub printGrammar() { # write the grammar in alphabetical order of the left sides
        print "/* printGrammar */\n";
        my $dot = "[  ";
        foreach my $left(sort(keys(%rules))) {
            print "$dot$left";
            $dot = "  .";
            my $sep = " =";
            foreach my $iprod (split(/\,/, $rules{$left})) {
                $iprod ++;
                print $sep;
                $sep = " |";
                while (! &isEOP($iprod)) {
                    my $mem = $prods[$iprod];
                    print " $mem";
                    $iprod ++;
                } # while
            } # foreach $iprod
            print "\n";
        } # foreach $left
        print "]\n\n";
    } # printGrammar
    
    &printGrammar();
    &dumpGrammar();
    &statistics();
    &initTable();
    &dumpTable();
    &walkGrammar();
    &statistics();
    &addLookAheads();
    &dumpTable();
    
    sub dumpGrammar() { # expand the grammar tree
        my $mem;
        print "/* dumpGrammar */\n";
        my $dot = "[  ";
        while (scalar(@symQueue) > 0) { # queue not empty
            my $left = shift(@symQueue);
            foreach my $iprod (split(/\,/, $rules{$left})) {
                print "${dot}[$iprod] $left =";
                $dot = "  .";
                $iprod ++;
                while (! &isEOP($iprod)) {
                    $mem = $prods[$iprod];
                    print " [$iprod] $mem";
                    if (defined($rules{$mem}) && ! defined($symDone{$mem})) {
                        push(@symQueue, $mem);
                        $symDone{$mem} = 1;
                        if ($debug > 1) {
                            print "\n\tsymDone{" . $mem . "} = true\n";
                        }
                    }
                    $iprod ++;
                } # while
                $mem = $prods[$iprod];
                print " [$iprod] $mem\n";
            } # foreach $iprod
        } # while queue not empty
        print "]\n\n";
    } # dumpGrammar
    
    sub statistics() { # print counts of data structures
        print sprintf("%4d rules"                 , scalar(keys(%rules)      )) . "\n";
        print sprintf("%4d members in productions", scalar(     @prods       )) . "\n";
        print sprintf("%4d states"                , scalar(     @states      )) . "\n";
        print sprintf("%4d successor states"      , scalar(     @succs       )) . "\n";
        print sprintf("%4d predecessor states"    , scalar(     @succs       )) . "\n";
        print sprintf("%4d potential conflicts"   , scalar(keys(%conStates)  )) . "\n";
        print sprintf("%4d symStates"             , scalar(keys(%symStates)  )) . "\n";
        print sprintf("%4d symDone"               , scalar(keys(%symDone)    )) . "\n";
        print sprintf("%4d itemStates"            , scalar(     @itemQueue   )) . "\n";
        print sprintf("%4d itemDone"              , scalar(keys(%itemDone)   )) . "\n";
        print "\n";
    } # statistics
    
    sub markedItem() { # legible item: the marker and the portion behind it, or a reduction
        my ($item, $succ) = @_;
        my $result = sprintf("%3d:", $item);
        my $sep;
        if (&isEOP($item)) {
            $sep = " ";
            if ($succ < 0) {
                my $ilah = - $succ;
                while ($laheads[$ilah] !~ m{\A\-}) {
                    $sep .= ",$laheads[$ilah]";
                    $ilah ++;
                } # while $ilah
                if (length($sep) >= 2) {
                    $sep = " " . substr($sep, 2); # remove 1st comma
                }
            }
            $sep .= "=: ";
            $succ = 0;
        } else {
            $sep = " @";
        }
        my $busy = 1;
        while ($busy) {
            my $mem = $prods[$item];
            if (&isEOP($item)) { # last, @eop
                my $left = $prods[$item + $mem - 1];
                $result .= "$sep($left," . (- $mem) . ")"; # reduce
                $busy = 0;
            } else { # inside - shift
                $result .= "$sep$mem";
            }
            $sep = " ";
            $item ++;
        } # while $busy
        if (1 || $succ > 0) {
            $result .= " -> $succ";
        }
        return $result;
    } # markedItem
    
    sub isEOP() { # whether the item's marker is at the end of a production
        my ($item) = @_;
        return ($prods[$item] =~ m{\A\-}) ? 1 : 0;
    } # isEOP
    
    sub dumpTable() { # expand the grammar tree
        print "/* dumpTable */\n";
        #---- states
        for my $state (2 .. $#states) { # over all states
            my $reduCount = 0; # number of reductions in this state
            my $sep = sprintf("%-12s", sprintf("state [%3d]", $state));
            my $stix = 0;
            while ($stix <= $#{$states[$state]}) {
                my $item = $states[$state][$stix];
                if (&isEOP($item)) {
                    $reduCount ++;
                }
                if ($debug == 4) {
                    print "# cp4: state=$state, stix=$stix, succs[state][stix]=$succs[$state][$stix]\n";
                }
                if (0) {
                } elsif ($succs[$state][$stix] == $acceptState) {
                    print "$sep" . sprintf("%3d:", $item) . " =.\n";
                } else {
                    print "$sep" . &markedItem($item, $succs[$state][$stix]) . "\n";
                }
                $sep = sprintf("%-12s", "");
                $stix ++;
            } # while $stix
            if ($reduCount > 0 && $stix > 1) {
                $conStates{$state} = 1;
                print sprintf("%-12s","") . "==> potential conflict\n";
            }
        } # for @states
        #---- succs
        for my $succ  (4 .. $#preds ) { # over all predecessors
            my $sep = sprintf("%-12s", sprintf("preds [%3d]", $succ ));
            my $ptix = 0;
            while ($ptix <= $#{$preits[$succ ]}) {
                my $item = $preits[$succ ][$ptix];
                if (0) {
                } else {
                    print "$sep" . &markedItem($item, $preds[$succ ][$ptix]) . "\n";
                }
                $sep = sprintf("%-12s", "");
                $ptix ++;
            } # while $ptix
        } # for $succ
        #---- sysmStates
        foreach my $sym (sort(keys(%symStates))) {
            my $sep = "\t";
            print "symbol $sym in states";
            for my $syix (0 .. $#{$symStates{$sym}}) {
                print "$sep$symStates{$sym}[$syix]";
                $sep = ", ";
            }
            print "\n";
        } # foreach $sym
        #----lookAheads
        my $nlah = scalar(@laheads);
        if ($nlah > 2) {
            print "lookahead lists:\n";
            for (my $ilah = 0; $ilah < $nlah; $ilah ++) {
                my $term = $laheads[$ilah];
                if ($term =~ m{\A\-}) { # negative: end of list
                    print " <- state " . (- $term) . "\n";
                } else {
                    print " $term";
                }
            } # for $ilah
            print "\n";
        } # $nlah > 2
        #----finally
        print "\n";
    } # dumpTable
    
    sub findSuccessor() { # Determine the next state reached by the marked symbol in an item.
        # Return
        # < 0 if item already present (negative successor)
        # > 0 if marked symbol found, but not the item
        # = 0 if nothing was found
        # and $stix = index where to enter this item in $states[$state]
        my ($item, $state) = @_;
        my $mem = $prods[$item];
        my $result = 0; # neither item nor symbol found
        my $stix = 0;
        my $busy = 1;
        while ($busy && $stix <= $#{$states[$state]}) { # while not found
            my $item2 = $states[$state][$stix];
            my $mem2 = $prods[$item2];
            if (0) {
            } elsif ($item == $item2) { # same item found
                $busy = 0;
                $result = - $succs[$state][$stix]; # negative successor
                print "  found item $item2 in states[$state][$stix] => $result\n";
            } elsif ($mem eq $mem2) { # marked symbol found
                $busy = 0;
                $result = $succs[$state][$stix]; # positive successor
                print "  found member $mem2 in states[$state][$stix] => $result\n";
            }
            $stix ++;
        } # while $stix
        if ($busy == 1) {
            $result = 0; # successor = 0
            print "  found no item $item in states[$state][$stix] => $result\n";
        }
        print "    findSuccessor: scalar(states)=" . scalar(@states) ."\n";
        return $result;
    } # findSuccessor
    
    sub chainStates() {
        my ($item, $state, $succ) = @_;
        if ($debug == 4) {
            print "# chainStates($item, $state, $succ)\n";
        }
        my $stix = $#{$states[$state]} + 1;
        $states[$state][$stix] = $item;
        $succs [$state][$stix] = $succ;
        if (! &isEOP($item)) { # $succ is not valid otherwise
            my $ptix = $#{$preds [$succ ]} + 1;
            $preits[$succ ][$ptix] = $item;
            $preds [$succ ][$ptix] = $state;
        }
        print "    chainStates: scalar(states)=" . scalar(@states) ."\n";
        return $succ;
    } # chainStates
    
    sub walkLane() { # follow a production starting at $item, insert $item in $state and/or follow the lane
        my ($item, $state) = @_;
        print "walkLane from state $state follow item " . &markedItem($item, -1) . "\n";
        my $stix;
        my $succ;
        my $busy = 1;
        while ($busy) {
            &enqueueProds($prods[$item], $state);
            $succ = &findSuccessor($item, $state); # > for symbol, < 0 for item, = 0 nothing found
            if ($debug == 4) {
                print "# walkLane1: item=$item, state=$state, succ=$succ, busy=$busy\n";
            }
            if (0) {
            } elsif ($succ >  0) { # marked symbol found, but not the item: insert item anyway and follow to successor
                $state = &chainStates($item, $state, $succ);
            } elsif ($succ <  0) { # same item found
                $busy = 0; # break loop, quit lane
            } else { # succ == 0: allocate new state
                $succ = scalar(@states); 
                if ($debug == 4) {
                    print "# walkLane2: item=$item, state=$state, succ=$succ, busy=$busy\n";
                }
                $state = &chainStates($item, $state, $succ);
            }
            if (&isEOP($item)) {
                $busy = 0;
            }
            if ($debug == 4) {
                print "# walkLane3: item=$item, state=$state, succ=$succ, busy=$busy\n";
            }
            $itemDone{$item} = 1;
            $item ++;
        } # while $busy, not at EOP
    } # walkLane
    
    sub enqueueProds() {
        # enqueue items for all productions of $left with the marker at the beginning,
        # and insert them in $state
        # insert $state into $symStates[$left] if not yet present
        my ($left, $state) = @_;
        print "  enqueueProds(left=$left, state=$state)\n";
        my $busy = 1;
        my $syix = 0;
        if (defined($symStates{$left})) {
            while ($busy == 1 && $syix <= $#{$symStates{$left}}) { # while not found
                if ($state == $symStates{$left}[$syix]) { # found
                    $busy = 0;
                    print "    found state $state in symStates{$left}[$syix]\n";
                }
                $syix ++;
            } # while
        } # defined
        if ($busy == 1) { # not found
            $symStates{$left}[$syix] = $state;
        }
        # now loop over the rule
        if (defined($rules{$left})) { # is really a non-terminal
            foreach my $item (split(/\,/, $rules{$left})) { # $iprod and $item coincide
                $item ++; # skip over left side
                if (! defined($itemDone{$item})) { # not yet enqueued
                    print "    enqueue item: $left = " . &markedItem($item, -1) . "\n";
                    push(@itemQueue, $item);
                    #$itemDone{$item} = 1;
                } # not yet enqueued
            } # foreach $item
        } # if non-terminal
        print "    enqueueProds: scalar(states)=" . scalar(@states) ."\n";
    } # enqueueProds
    
    sub initTable() { # initialize the state table with
        $acceptState = 4;
        push(@states, [0], [0]); # states 0, 1 are not used
        push(@succs , [0], [0]); # states 0, 1 are not used
        my $state = 2;
        push(@states, [$state]); # @axiom ...
        &enqueueProds($axiom, $state);
        $state ++;
        push(@succs,  [$state]); # ... -> 3
        push(@states, [$state ++]); # @eof
        push(@succs,  [$acceptState]); # ... "-> 4" = accept
        print "/* initTable, acceptState=$acceptState, scalar(states)=" . scalar(@states) . " */\n\n";
        @laheads = (-1, -1);
    } # initTable
    
    sub insertProdsIntoState() {
        my ($left, $state) = @_;
        print "insert prods($left) into $state\n";
        foreach my $item (split(/\,/, $rules{$left})) { # $iprod and $item coincide
            $item ++; # skip over left side
            &walkLane($item, $state);
        } # foreach $item
    } # insertProdsIntoState
    
    sub walkGrammar() { # expand the grammar tree by inserting items from the queue
        my $mem;
        print "/* walkGrammar */\n";
        %itemDone = (); # clear history of %itemQueue
        while (scalar(@itemQueue) > 0) { # queue not empty
            my $item = shift(@itemQueue);
            my $left = $prods[$item - 1];
            print "----------------\n";
            print "dequeue item: $left = " . &markedItem($item, -1) . "\n";
            if (! defined($itemDone{$item})) {
                # now insert the start of all productions of $left into all states where $left is marked in an item
                # follow those productions and eventually generate successor states
                for my $stix (0 .. $#{$symStates{$left}}) {
                    my $state = $symStates{$left}[$stix];
                    &insertProdsIntoState($left, $state);
                } # for $stix
                &dumpTable();
            } else {
                print "  already done\n";
            }
        } # while queue not empty
    } # walkGrammar
    
    sub delta() { # Determine the next state reached by a symbol. Assume a completed table.
        # > 0 if marked symbol found, but not the item
        # = 0 if nothing was found
        my ($mem, $state) = @_;
        my $result = 0; # neither item nor symbol found
        my $stix = 0;
        my $busy = 1;
        while ($busy && $stix <= $#{$states[$state]}) { # while not found
            my $item2 = $states[$state][$stix];
            my $mem2 = $prods[$item2];
            if ($mem eq $mem2) { # marked symbol found
                $busy = 0;
                $result = $succs[$state][$stix]; # positive successor
            }
            $stix ++;
        } # while $stix
        if ($busy == 1) {
            $result = 0; # successor = 0
            print "  delta found no symbol $mem in states[$state]\n";
        } else {
            print "  delta(mem=$mem, state=$state) -> state $result\n";
        }
        return $result;
    } # delta
    
    sub linkToLAList() {
        my ($succ, $state, $stix) = @_;
        my $ilah = scalar(@laheads);
        $succs[$state][$stix] = - $ilah;
        print "    addLookAheads(succ=$succ, state=$state, stix=$stix) [$ilah]: ";
        my $teix = 0;
        while ($teix <= $#{$states[$succ]}) {
            my $item = $states[$succ][$teix];
            my $mem = $prods[$item];
            if (! defined($rules{$mem})) { # is terminal
                $laheads[$ilah ++] = $mem;
                print " $mem";
            } # terminal
            $teix ++;
        } # while $teix
        $laheads[$ilah] = -$state; # end of sublist
        print " ... [$ilah] $laheads[$ilah]\n"
    } # linkToLAList
    
    sub findPredecessor() { # Determine the previous state that reached the marked symbol.
        my ($item, $state) = @_; # if the $item is a reduce item, $succ is the negative length of the right side, $succs is 0
        my $result = 0; # predecessor state for this item not found
        my $ptix = 0;
        my $busy = 1;
        while ($busy && $ptix <= $#{$preits[$state]}) { # while not found
            if ($item == $preits[$state][$ptix]) { # same item found
                $busy = 0;
                $result = $preds [$state][$ptix];
            } # same item
            $ptix ++;
        } # while $ptix
        if ($busy == 1) {
            $result = 0; # successor = 0
            print "  no predecessor found for item $item in preits[$state]\n";
        } else {
            print "  predecessor $result found for item $item in preits[$state]\n";
        }
        return $result;
    } # findPredecessor
    
    sub walkBack() { # for a reduce item, determine the state that follows on the shift of the left side: the lookaheads are all terminals in that state
        my ($item, $state, $stix) = @_; # $item is a reduce item, member is negative length of the right side, $succs is 0
        print "/* walkBack(item=$item, state=$state, stix=$stix) */\n";
        my $prodLen = - $prods[$item];
        my $iprod = $prodLen;
        my $pred = $state;
        my $busy = 1; # assume success
        while ($iprod >= 1) { # count members backwards
            $item --;
            $pred = &findPredecessor($item, $pred);
            if ($pred == 0) {
                $busy = 0; # some failure?
            }
            $iprod --;
        } # while $iprod
        if ($busy) { # now $state shifts the left side
            $item --;
            my $left = $prods[$item];
            my $succ = &delta($left, $pred);
            print "  walkBack found pred=$pred, left=$left, succ=$succ\n";
            if ($succ > 0) {
                &linkToLAList($succ, $state, $stix);
            }
        }
    } # walkBack
    
    sub addLookAheads() { # for each state with potential conflicts: assign lookahead symbols to all reduce items
        print "/* addLookAheads */\n";
        foreach my $state (sort(keys(%conStates))) {
            my $stix = 0;
            while ($stix <= $#{$states[$state]}) { # while not found
                my $item = $states[$state][$stix];
                if (&isEOP($item)) { # reduce item
                    &walkBack($item, $state, $stix);
                } # reduce item
                $stix ++;
            } # while $stix
        }
    } # addLookAheads
#----------------
__DATA__
/* Test grammar, example 4.2.1-1, page 73         */
/* Aho and Ullman (1972) give an example (7.27) for a grammar which is LR(1) but not LALR(1)                       */
/* Dr. Georg Fischer 1980-08-01                   */
[axiom = S
    .S = A a | B b
       | d A b | d B a
    .A = c
    .B = c
]
