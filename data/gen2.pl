#!perl

# Prototype parser generator, verson 2
# @(#) $Id$
# 2022-02-10, Georg Fischer

use strict;
use warnings;
use integer;

my $debug = 1;
my %rules   = (); # left -> list of indexes in prod
my @prods   = (); # flattened: left, mem1, mem2, ... memk, -k
my $hyper = "hyper_axiom";  # artificial first left side
my $axiom;  # user's first left side
my $left;   # symbol on the left side
my $right;  # a right side, several productions

sub initialize() {
    push(@prods, 0); # [0] is not used
    $rules{$hyper} = scalar(@prods);
    push(@prods, $hyper);
    push(@prods, $axiom);
    push(@prods, "eof");
    push(@prods, -2);
} # initialize

while (<DATA>) {
    my $line = $_;
    $line =~ s{\s+\Z}{}; # chompr
    if (0) {
    } elsif ($line =~ m{\A *\[ *(axiom) *\= *(\w+)}) { # axiom = @rights
        ($left, $right) = ($1, $2);
        $axiom = $left;
        &initialize();
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
            while ($prods[$iprod] !~ m{\A\-}) {
                my $mem = $prods[$iprod];
                print " $mem";
                $iprod ++;
            } # while 
        } # foreach $iprod
        print "\n";
    } # foreach $left
    print "]\n";
} # printGrammar

&printGrammar();

my @symQueue = ($hyper); # queue of (non-terminal, defined in %rules) symbols to be expanded
my %symDone  = (); # defined iff symbol is already expanded

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
            while ($prods[$iprod] !~ m{\A\-}) {
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
    print "]\n";
} # dumpGrammar

&dumpGrammar();

my %symbols = ();
my %states  = ();

#----------------
__DATA__
[axiom = S
    .S = A a | B b 
       | d A b | d B a
    .A = c
    .B = c
]
