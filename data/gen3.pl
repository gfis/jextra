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
my $acceptState;
my %itemDone  = (); # history of %itemQueue: defined iff the item was already enqueued (in this iteration)

sub initTable() {
    $acceptState = 0;
    push(@states, [ 0], [0]); # states 0, 1 are not used
    push(@succs , [ 0], [0]); # states 0, 1 are not used
    my $state = 2;
    # push(@itemQueue, $state);
    $symStates{$axiom}[0] = $state;
    push(@states, [ $state ++]); # @axiom ...
    push(@succs,  [ $state]); # ... -> 3
    push(@states, [ $state ++]); # @eop
    push(@succs,  [ $acceptState]); # ... "-> 4" = accept
    &enqueueProds($axiom);
    print "/* initTable, acceptState=$acceptState */\n\n";
} # initTable

&initTable();

sub markedItem() { # get the marker and the portion behind it
    my ($item, $succ) = @_;
    my $result = "";
    my $sep = "[$item] @";
    my $left;
    if (&isEOP($item)) { # last, @eop, accept
        my $mem = $prods[$item];
        $left = $prods[$item + $mem - 1];
        $result = "[$item] =: $left," . (- $mem); # accept
    } else { # not last
        my $busy = 1;
        while ($busy) {
            if (&isEOP($item)) { # last, @eop
                $busy = 0;
            } else { # inside - shift
                $result.= "$sep$prods[$item]";
                $sep = " ";
            }
            $item ++;
        } # while $busy
        if ($succ > 0) {
            $result .= " -> $succ";
        }
    } # not last
    return $result;
} # markedItem

sub isEOP() { # whehter the item's marker is at the end of a production
    my ($item) = @_;
    return ($prods[$item] =~ m{\A\-}) ? 1 : 0;
} # isEOP

sub dumpTable() { # expand the grammar tree
    print "/* dumpTable */\n";
    for my $state (2 .. $#states) {
        my $sep = "\t";
        print "state $state:";
        for my $stix (0 .. $#{$states[$state]}) {
            my $item = $states[$state][$stix];
            my $mem = $prods[$item];
            if (0) {
            } elsif ($succs[$state][$stix] == $acceptState) {
                print "${sep}[$item] =.\n";
            } else {
                print "$sep" . &markedItem($item, $succs[$state][$stix]) . "\n";
            }
            $sep = "\t\t";
        } # for $item
        # print "\n";
    } # for $state
    foreach my $sym (sort(keys(%symStates))) {
        my $sep = "\t";
        print "symbol $sym in states";
        for my $syix (0 .. $#{$symStates{$sym}}) {
            if (! defined($symStates{$sym}[$syix])) {
                print "undefined sep=$sep, symStates{$sym}[$syix]\n";
                $symStates{$sym}[$syix] = 0;
            }
            print "$sep$symStates{$sym}[$syix]";
            $sep = ", ";
        }
        print "\n";
    } # foreach $sym
    print "\n";
} # dumpTable

sub enqueueProds() { # enqueue items for all productions of a left side with the marker at the beginning
    my ($mem, $state) = @_;
    # insert $state into $symStates[$mem] if not yet present
    my $busy = 1;
    my $syix = 0;
    while ($busy == 1 && $syix <= $#{$symStates{$mem}}) { # while not found
        if ($state == $symStates{$mem}[$syix]) { # found
            $busy = 0;
            print "    found $state in symStates{$mem}[$syix]\n";
        }
        $syix ++;
    } # while
    if ($busy == 1) { # not found
        $symStates{$mem}[$syix] = $state;
    }
    # now loop over the rule
    if (defined($rules{$mem})) { # is really a non-terminal
        foreach my $item (split(/\,/, $rules{$mem})) { # $iprod and $item coincide
            $item ++; # skip over left side
            if (! defined($itemDone{$item})) { # not yet enqueued
                print "enqueue item: $mem = " . &markedItem($item, -1) . "\n";
                push(@itemQueue, $item);
                $itemDone{$item} = 1;
            } # not yet enqueued
        } # foreach $item
    } # if non-terminal
} # enqueueProds

sub findSuccessor() { # Determine the next state reached by the marked symbol.
    # Return
    # < 0 if item already present (negative successor)
    # > 0 if marked symbol found, but not the item
    # = 0 if nothing was found
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
            print "  found item [$item] in states[$state][$stix] => $result\n";
        } elsif ($mem eq $mem2) { # marked symbol found
            $busy = 0;
            $result = $succs[$state][$stix]; # positive successor
            print "  found \@ $mem in states[$state][$stix] => $result\n";

        }
        $stix ++;
    } # while $stix
    if ($busy == 1) {
        $result = 0; # successor = 0
        print "  found no item [$item] in states[$state][$stix] => $result\n";
    }
    return $result;
} # findSuccessor

sub walkLane() { # follow a production starting at $item, insert $item in $state and/or follow the lane
    my ($item, $state) = @_;
    my $stix;
    my $busy = 1;
    while ($busy && ! &isEOP($item)) {
        my $succ = &findSuccessor($item, $state); # > for symbol, < 0 for item, = 0 nothing found
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
            &enqueueProds($prods[$item], $state);
            $stix = $#{$states[$state]} + 1;
            $states[$state][$stix] = $item;
            $succs [$state][$stix] = $succ;
            $state = $succ;
        }
        $item ++;
    } # while $busy, not at EOP
    $states[$state][0] = $item;
    $succs [$state][0] = 1;
} # walkLane

sub insertProdsIntoState() {
    my ($left, $state) = @_;
    print "insert prods($left) into $state\n";
    foreach my $item (split(/\,/, $rules{$left})) { # $iprod and $item coincide
        $item ++; # skip over left side
        &walkLane($item, $state);
    } # foreach $item
} # insertProdsIntoState

&dumpTable();

sub walkGrammar() { # expand the grammar tree by inserting items from the queue
    my $mem;
    print "/* walkGrammar */\n";
    %itemDone = (); # clear history of %itemQueue
    while (scalar(@itemQueue) > 0) { # queue not empty
        my $item = shift(@itemQueue);
        my $left = $prods[$item - 1];
        print "dequeue item: $left = " . &markedItem($item, -1) . "\n";
        # now insert the start of all productions of $left into all states where $left is marked in an item
        # follow those productions and eventually generate successor states
        for my $stix (0 .. $#{$symStates{$left}}) {
            my $state = $symStates{$left}[$stix];
            &insertProdsIntoState($left, $state);
        } # for $stix
        &dumpTable();
    } # while queue not empty
} # walkGrammar

&walkGrammar();

#----------------
__DATA__
[axiom = S
    .S = A a | B b
       | d A b | d B a
    .A = c
    .B = c
]
