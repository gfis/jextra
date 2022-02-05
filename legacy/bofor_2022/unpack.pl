#!perl

# unpack BOFOR.ALL
# @(#) $Id: b3731991dc9da350ed8f4bd9a119240b4dbc11dd $
# 2022-02-04, Georg Fischer
#
# Usage:
#   perl unpack.pl BOFOR.ALL
#------------------------------------------------------------------
#
use strict;
use warnings;
use integer;

    my %excludes = qw(
    ZZTI	1
    );
    my $infile = shift(@ARGV);
    my $line;
    my $key;
    my $name;
    my $parm;
    my $memname;
    my $value;
    
    # (1) determine the include files
    # (2) remember the parameters
    my %includes = ();
    my %params = ();
    open(SRC, "<", $infile) || die "cannot read $infile\n";
    while(<SRC>) {
        if (0) {
        } elsif(m{^ *\%INCLUDE *\( *(\w+)\)}) {
            $includes{$1} = 1;
        } elsif(m{^ *\%PARAMETER +(\w+) *\=\s*(\S*)}) {
            $params{$1} = $2;
        }
    }
    close(SRC);
    for $key (sort(keys(%params))) {
        $value = $params{$key};
        while ($value =~ m{([A-Z]+)}) { # nested
            $parm = $1;
            if (defined($params{$parm})) {
                $value =~ s{$parm}{$params{$parm}};
            } else {
                $value =~ s{$parm}{99999999};
            }
        } # while nested
        $params{$key} = eval($value);
        print "parameter $key=$params{$key}\n";
    }
    print "includes:\n";
    for $key (sort(keys(%includes))) {
        print "$key\n";
    }

    # (3) write individual *.ftn and *.inc files
    my $memname = "";
    my %ftns = ();
    open(SRC, "<", $infile) || die "cannot read $infile\n";
    while(<SRC>) {
        $line = $_;
        if ($memname eq "") {
            if ($line =~ m{^\&\( *(\w+) *\)}) { # start of member
                $name = $1;
                if (! defined($excludes{$name})) {
                    if (0) {
                    } elsif (defined($includes{$name})) {
                        $memname = "$name.inc";
                    } elsif ($name =~ m{\AZZ[CIR][CIR]\Z}) {
                        $memname = "$name.asm";
                    } else {
                        $memname = "$name.ftn";
                        $ftns{$name} = $memname;
                    }
                    open(TAR, ">", $memname) || die "cannot write $memname\n";
                    print STDERR "writing $memname\n";
                }
            }
        } else { # write source line to member
            if ($line =~ m{^\&END\s*\Z}) { # end of member
                $memname = "";
                close(TAR);
            } else {
                my $ok = 1;
                $line =~ s{\s+\Z}{}; # chompr
                if (0) {
                } elsif(m{^ *\%PARAMETER +(\w+) *\=\s*(\S*)}) {
                    $params{$1} = $2;
                    $ok = 0;
                } elsif ($line =~ m{\%INCLUDE *\( *(\w+) *\)}) {
                    $name = $1;
                    $line =~ s {\%INCLUDE.*}{INCLUDE \'$name\.inc\'};
                } else { # normal line
                    while ($line =~ m{\&(\w+)}) {
                        $parm = $1;
                        if (defined($params{$parm})) {
                            $line =~ s{\&$parm}{$params{$parm}};
                            $line .= " ! $parm -> $params{$parm}";
                        } else {
                            print STDERR "unknown parameter $parm in $memname\n";
                            $line =~ s{\&$parm}{\?\?};
                        }
                    } # while
                }
                if( $ok) {
                    print TAR "$line\n";
                }
            }
        } 
    }
    close(SRC);
    
    # (4) write source list to be included in makefile
    open(INC, ">", "sources.mak") || die "cannot write sources.mak\n";
    print INC "SRC= \\\n";
    my $count = 0;
    for $key (sort(keys(%ftns))) {
        print INC "\t$key.FTN";
        $count ++;
        if ($count % 8 == 0) {
        	print INC "\\\n";
        }
    }
    print INC "\t# end\n";
    close(INC);
__DATA__
&(ALONG   )
      SUBROUTINE ALONG(STATEQ,POSQ,STATE,PROD)
C     WALK THROUGH THE STATES AND MOVE THE MARKER BEHIND A PRODUCTION
C     GF 20.08.80 : WITH CALL 'DELTA'
C
      %INCLUDE (PARS)
      %INCLUDE (ITES)
      %INCLUDE (MEMS)
      %INCLUDE (STAS)
C
101   CONTINUE !     DONE
      RETURN! ALONG
      END
&END
&(PARS    )
C-------GF 08.11.80------------------------------ P A R S
      %PARAMETER BUCH=127
      %PARAMETER CODH=128
      %PARAMETER ITEH=600

C     BUCS
      DATA BUCHIB /&BUCH/
      DATA BUCKET /&BUCH * &SYMH/
