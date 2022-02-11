#!perl

# Prototype parser generator, version 3
# @(#) $Id$
# 2022-02-11: walkLane
# 2022-02-10, Georg Fischer

use strict;
use warnings;
use integer;

my $debug = 1;
my %rules   = (); # left -> list of indexes in prod
my @prods   = (); # flattened: left, mem1, mem2, ... memk, -k
my $hyper   = "hyper_axiom";  # artificial first left side
my $axiom;  # first left side of the user's grammar
my $left;   # symbol on the left side
my $right;  # a right side, several productions

sub initGrammar() {
    push(@prods, 0); # [0] is not used
    $rules{$hyper} = scalar(@prods);
    push(@prods, $hyper);
    push(@prods, $axiom);
    push(@prods, "eof");
    push(@prods, -2);
} # initGrammar

while (<DATA>) {
    my $line = $_;
    $line =~ s{\s+\Z}{}; # chompr
    if (0) {
    } elsif ($line =~ m{\A *\[ *(axiom) *\= *(\w+)}) { # axiom = @rights
        ($left, $right) = ($1, $2);
        $axiom = $left;
        &initGrammar();
        &appendToProds($left, $right);
    } elsif ($line =~ m{\A *\. *(\w+) *\= *(.+)})    { # .left = @rights
        ($left, $right) = ($1, $2);
        &appendToProds($left, $right);
    } elsif ($line =~ m{\A *\| *(.+)})               { # | @rights
        ($right) = ($1);
        &appendToProds($left, $right);
    } elsif ($line =~ m{\A *\]}) {
        last;
    }
} # while <>

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

my @symQueue = ($hyper); # queue of (non-terminal, defined in %rules) symbols to be expanded
my %symDone  = (); # history of @symQueue: defined iff symbol is already expanded

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
                }
                $iprod ++;
            } # while
            $mem = $prods[$iprod];
            print " [$iprod] $mem\n";
        } # foreach $iprod
    } # while queue not empty
    print "]\n\n";
} # dumpGrammar

&dumpGrammar();

# An item is an index into @prods.
# The marker "@" is thought to be before the member prods[item].
my @states    = (); # state number -> array of items; [0] and[1] are not used.
my @succs     = (); # state number -> array of successor states
my @itemQueue = (); # List of items with symbols that must be expanded.
my %symStates = (); # symbol -> list of states with an item that has the marker before this symbol
my $acceptState;    # the parser accepts the sentence when it reachs this state
my %itemDone  = (); # history of %itemQueue: defined iff the item was already enqueued (in this iteration)

sub statistics() { # print counts of data structures
    print sprintf("%4d rules\n"                 , scalar(keys(%rules)      ));
    print sprintf("%4d members in productions\n", scalar(     @prods       ));
    print sprintf("%4d states\n"                , scalar(     @states      ));
    print sprintf("%4d successor states\n"      , scalar(     @succs       ));
    print sprintf("%4d symStates\n"             , scalar(keys(%symStates)  ));
    print sprintf("%4d symDone\n"               , scalar(keys(%symDone)    ));
    print sprintf("%4d itemStates\n"            , scalar(     @itemQueue   ));
    print sprintf("%4d itemDone\n"              , scalar(keys(%itemDone)   ));
    print "\n";
} # statistics

&statistics();

sub markedItem() { # legible item: the marker and the portion behind it, or a reduction
    my ($item, $succ) = @_;
    my $result = sprintf("%3d:", $item);
    my $sep;
    if (&isEOP($item)) {
        $sep = " =: ";
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
    if ($succ > 0) {
        $result .= " -> $succ";
    }
    return $result;
} # markedItem

sub isEOP() { # whehter the item's marker is at the end of a production
    my ($item) = @_;
    return ($prods[$item] =~ m{\A\-}) ? 1 : 0;
} # isEOP

sub dumpTable() { # expand the grammar tree
    print "/* dumpTable */\n";
    for my $state (2 .. $#states) { # over all states
        my $sep = sprintf("%-12s", sprintf("state [%3d]", $state));
        for my $stix (0 .. $#{$states[$state]}) {
            my $item = $states[$state][$stix];
            my $mem = $prods[$item];
            if (0) {
            } elsif ($succs[$state][$stix] == $acceptState) {
                print "$sep" . sprintf("%3d:", $item) . " =.\n";
            } else {
                print "$sep" . &markedItem($item, $succs[$state][$stix]) . "\n";
            }
            $sep = sprintf("%-12s", "");
        } # for $item
        # print "\n";
    } # for $state
    foreach my $sym (sort(keys(%symStates))) {
        my $sep = "\t";
        print "symbol $sym in states";
        for my $syix (0 .. $#{$symStates{$sym}}) {
            print "$sep$symStates{$sym}[$syix]";
            $sep = ", ";
        }
        print "\n";
    } # foreach $sym
    print "\n";
} # dumpTable

sub findSuccessor() { # Determine the next state reached by the marked symbol.
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
    return ($result, $stix);
} # findSuccessor

sub walkLane() { # follow a production starting at $item, insert $item in $state and/or follow the lane
    my ($item, $state) = @_;
    print "walkLane from state $state follow item " . &markedItem($item, -1) . "\n";
    my $stix;
    my $succ;
    my $busy = 1;
    while ($busy && ! &isEOP($item)) {
        &enqueueProds($prods[$item], $state);
        ($succ, $stix) = &findSuccessor($item, $state); # > for symbol, < 0 for item, = 0 nothing found
        if (0) {
        } elsif ($succ > 0) { # marked symbol found, but not the item: insert item anyway and follow to successor
            $stix = $#{$states[$state]} + 1;
            $states[$state][$stix] = $item;
            $succs [$state][$stix] = $succ;
            $state = $succ;
        } elsif ($succ < 0) { # same item found
            $busy = 0; # break loop, quit lane
        } else { # $succ == 0: allocate new state
            $succ = scalar(@states); # new state
            $stix = $#{$states[$state]} + 1;
            $states[$state][$stix] = $item;
            $succs [$state][$stix] = $succ;
            $state = $succ;
        }
        $itemDone{$item} = 1;
        $item ++;
    } # while $busy, not at EOP
    # now at EOP
    if ($busy) { # not same item found
        $stix = $#{$states[$state]} + 1;
        $states[$state][$stix] = $item;
        $succs [$state][$stix] = 0;
    }
} # walkLane

sub enqueueProds() {
    # enqueue items for all productions of $left with the marker at the beginning,
    # and insert them in $state
    # insert $state into $symStates[$left] if not yet present
    my ($left, $state) = @_;
    print "  enqueueProds(left=$left, state=$state)\n";
    my $busy = 1;
    my $syix = 0;
    while ($busy == 1 && $syix <= $#{$symStates{$left}}) { # while not found
        if ($state == $symStates{$left}[$syix]) { # found
            $busy = 0;
            print "    found state $state in symStates{$left}[$syix]\n";
        }
        $syix ++;
    } # while
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
} # enqueueProds

sub initTable() { # initialize the state table with 
    $acceptState = 4;
    push(@states, [ 0], [0]); # states 0, 1 are not used
    push(@succs , [ 0], [0]); # states 0, 1 are not used
    my $state = 2;
    # push(@itemQueue, $state);
#   $symStates{$axiom}[0] = $state;
    push(@states, [ $state]); # @axiom ...
    &enqueueProds($axiom, $state);
    $state ++;
    push(@succs,  [ $state]); # ... -> 3
    push(@states, [ $state ++]); # @eof
    push(@succs,  [ $acceptState]); # ... "-> 4" = accept
    print "/* initTable, acceptState=$acceptState */\n\n";
} # initTable

&initTable();
&dumpTable();

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

&walkGrammar();
&statistics();
#----------------
__DATA__
[axiom = S
    .S = A a | B b
       | d A b | d B a
    .A = c
    .B = c
]
