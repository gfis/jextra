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
    xxxx    1
    );
    my $infile = shift(@ARGV);
    my $line;
    my $key;
    my $name;
    my $parm;
    my $memname;
    my $value;
    my $count;
    my %includes    = (); # list of include files *.inc
    my %params      = (); # list of parameter names with their values
    my %depends     = (); # list of Fortran files and their includes
    my %ftns        = (); # list of Fortran files
    
    #---- determine the include files
    #---- remember the parameters
    open(SRC, "<", $infile) || die "cannot read $infile\n";
    while(<SRC>) {
        if (0) {
        } elsif(m{^ *\%INCLUDE *\( *(\w+)\)}) {
            $includes{$1} = 1;
        } elsif(m{^ *\%PARAMETER +(\w+) *\=\s*(\S*)}) {
            ($name, $value) = ($1, $2);
            $name =~ s{\AU}{h};
            $params{$name} = $value;
        }
    }
    close(SRC);
    #---- list the parameters
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
    #---- show list of *.inc include files
    if (1) { 
        print "includes:\n";
        for $key (sort(keys(%includes))) {
            print "$key.inc\n";
        }
    }
    # (3) write individual files *.ftn *.inc *.asm *.pli *.tkb, and populate %depends
    $memname = "";
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
                    } elsif ($name =~ m{\A(PAROLD|PRIXRE)\Z}) { # PL/1
                        $memname = "$name.pli";
                    } elsif ($name =~ m{\A(PUTCOQ)\Z}) { # ignore, duplicate?
                        $memname = "$name.fxx";
                    } elsif ($name =~ m{TB\Z}) { # DEC TKB?
                        $memname = "$name.tkb";
                    } else {
                        $memname = "$name.ftn";
                        $ftns{$name} = $memname;
                        $depends{$name} = "$name.ftn";
                        $count = 1;
                    }
                    open(TAR, ">", $memname) || die "cannot write $memname\n";
                    # print STDERR "writing $memname\n";
                    if ($name eq "PARS") { # write at the beginning
                        print TAR "      implicit none\n";
                        # and suppress IMPLICIT below
                    }
                }
            }
        } else { # modify and write normal source line to member
            if ($line =~ m{^\&END\s*\Z}) { # end of member
                $memname = "";
                $count   = 0;
                close(TAR);
            } else {
                my $ok = 1;
                $line =~ s{\s+\Z}{}; # chompr
                if (0) {
                } elsif(m{^ *IMPLICIT *COMPLEX}) { # IMPLICIT
                    $ok = 0; # suppress here
                } elsif(m{^ *\%PARAMETER +(\w+) *\=\s*(\S*)}) { # %PARAMETER
                    ($name, $value) = ($1, $2);
                    $name =~ s{\AU}{h};
                    print TAR "      INTEGER $name\n";
                    print TAR "      parameter $name=$value\n";
                    $ok = 0;
                } elsif ($line =~ m{\%INCLUDE *\( *(\w+) *\)}) { # %INCLUDE
                    my $incname = $1;
                    $line =~ s {\%INCLUDE.*}{include \'$incname\.inc\'};
                    $depends{$name} .= " $incname.inc";
                    $count ++;
                    if ($count % 8 == 0) {
                        $depends{$name} .= " \\\n\t\t";
                    }
                } elsif ($line =~ m{\A.{6} *OPEN *\(([^\)]+)}) { # OPEN(
                    $line =~ s{NAME\=}      {file\=};
                    $line =~ s{TYPE\=}      {status\=};
                    $line =~ s{ACCESS\=}    {position\=};
                    $line =~ s{\'SY\:}          {\'};
                    $line =~ s{\'DL1\[[^\:]+\:} {\'};
                } elsif ($line =~ m{\A.{6} *(READ|WRITE) *\(\w+\'}) { # WRITE(UNIT'RECORD)
                    $line =~ s{\'}{\, rec=};
                } else { # normal line
                    while ($line =~ m{\&(\w+)}) {
                        $name = $1;
                        $name =~ s{\AU}{h};
                        if ($line =~ m{FORMAT *\(}) {
                            $line =~ s{\&(\w+)}{$params{$name}}; # F77 does not replace paramters in FORMAT specs?
                        } else {
                            $line =~ s{\&(\w+)}{$name};
                        }
                    } # while
                    $line =~ s{(ZZ[A-Z])C( *\(\')}{${1}ch$2};
                    $line =~ s/\, *ASSOCIATE *VARIABLE=\w+//;
                    $line =~ s/\, *READONLY//;
                    $line =~ s/\, *SHARED//;
                    $line =~ s/\, *MAXREC=[\w\/\+\-\*\)\(]+//;
                    $line =~ s/\, *TYPE=\'SCRATCH\'//;
                    $line =~ s/\, *BUFFER *COUNT=\-1//;
                    $line =~ s/\, *CARRIAGE *CONTROL=\'LIST\'//;
                    $line =~ s/DL1\:\[20\,21\]//;
                }
                if( $ok) { # if not suppressed
                    print TAR "$line\n";
                }
            }
        } 
    }
    close(SRC);
    
    # (4) write source list to be included in makefile
    open(INC, ">", "include.make") || die "cannot write sources.mak\n";
    print INC "SRC= \\\n";
    $count = 0;
    for $key (sort(keys(%ftns))) {
        print INC "\t$key.ftn";
        $count ++;
        if ($count % 8 == 0) {
            print INC " \\\n";
        }
    }
    print INC "\t# end\n";

    # (5) write dependencies for *.o
    print INC "\n";
    for $key (sort(keys(%depends))) {
        print INC "$key.o:\t$depends{$key}\n";
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
