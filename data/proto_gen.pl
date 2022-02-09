#!perl

# Prototype parser generator
# @(#) $Id$
# 2022-02-10, Georg Fischer

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
        print "[ axiom = $start\n";
        foreach my $left(sort(keys(%rules))) {
            print "  .$left = $rules{$left}\n";
        }
        print "]\n";
} # dump input grammar

__DATA__
[axiom = S
    .S = A a | B b | d A b | d B a
    .A = c
    .B = c
]
