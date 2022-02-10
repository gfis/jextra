#!perl

# Prototype parser generator, version 1
# @(#) $Id$
# 2022-02-09, Georg Fischer

use strict;
use warnings;
use integer;

my %rules   = ();
my %prods   = ();
my %symbols = ();
my %states  = ();
my $start;

while (<DATA>) {
    my $line = $_;
    $line =~ s{\s+\Z}{}; # chompr
    if (0) {
    } elsif ($line =~ m{\A *\[ *axiom *\= *(\w+)}) {
        $start = $1;
        $rules{"axiom"} = $start;
    } elsif ($line =~ m{\A *\. *(\w+) *\= *(.+)}) {
        my ($left, $right) = ($1, $2);
        my @prods = map {
            s/ +/\,/g;
            $_
            } split(/ *\| */, $right);
        $rules{$left} = join("|", @prods);
    } elsif ($line =~ m{\A *\]}) {
        last;
    }
} # while <>

if (1) { # dump input grammer
        print "[ hyper_axiom = axiom eof\n";
        foreach my $left(sort(keys(%rules))) {
            print "  .$left = $rules{$left}\n";
        }
        print "]\n";
} # dump input grammar

my @symqueue = ("axiom");
my %symused  = ();
my @states;
#  state 1 is not used
&addItem(2, "axiom", "->3")
&addItem(3, "eof"  , "=.")

while (scalar(@symqueue) > 0) { # queue not empty
    my $left = shift(@symqueue);
    foreach my $prod (split(/\|/, $rules{$left})) {
        &insert($left, $prod);
    } # foreach $prod
} # while queue not empty
#----
sub insert {
    my ($left, $prod) = @_;
    print "insert prod: $left = $prod.\n";
    foreach my $memb (split(/\,/, $prod)) {
        if (defined($rules{$memb}) && ! defined($symused{$memb})) {
            $symused{$memb} = 1;
            push(@symqueue, $memb);
        }
        
    } # foreach $memb
} # insert
#----
sub additem {
    my ($id, $sym, $action) = @_;
    my %hash;
    if (! defined($states[$id])) {
        %hash = qw($sym, $action);
    } else {
        %hash = $states[$id];
        $hash{$sym} = $action;
    }
    $states[$id] = %hash;
} # addItem
#----
#----------------
__DATA__
[axiom = S
    .S = A a | B b | d A b | d B a
    .A = c
    .B = c
]
    2 axiom ->  3 eof =.
    | S     ->  4 eof =: axiom,1
    | A     ->  5 a ->  9 eof =: S,2
    | d     ->  6 A -> 10 b -> 13 eof =: S,3
    |           | B -> 11 a -> 14 eof =: S,3
    |           | c ->  8 b =: A,1
    |                   | a =: B,1
    | B     ->  7 b -> 12 eof =: S,2
    | c     -> 15 a =: A,1
                | b =: B,1
