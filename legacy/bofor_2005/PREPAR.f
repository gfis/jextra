      SUBROUTINE PREPAR (WHAT)
C     PREPARE FILES AND DATA STRUCTURES FOR PROCESSING MODULES
C     GF 23.08.1980
C     GF 08.11.1980: CARRIAGECONTROL='NONE' FOR 'TARGET.DAT'
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'LINS.F'
      INCLUDE 'MEMS.F'
      INCLUDE 'PROS.F'
      INCLUDE 'SPAS.F'
      INCLUDE 'STAS.F'
      INCLUDE 'STAT1.F'
      INCLUDE 'SYMS.F'
      INCLUDE 'TRES.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,WHAT    ! CODE FOR THE LOCATION IN PROGRAM 'EXTRA' (1...7)
C
CXML
C     XML1 (PREPAR, WHAT)
      CALL XML1 ('PREPAR', 1, 6, WHAT)
      GOTO (101,102,103,104,105,106,107,108,109),WHAT
C------------------------------------------------------------
C     1 -                       BEFORE META:GRAMMAR
C
101   CONTINUE
      OPEN (UNIT=ULIN,NAME='meta2.grm',TYPE='OLD')
      CALL HEADER ('meta2.grm',9,1)
      MEM(1) = EOP
      ITEPAG = 0
      NEWNUM = PARASK('NEWNUM',1,6,7952)
      IF (SPATES .LT. 0) GOTO 51
      CALL SPAINI
51    CONTINUE
      CALL LILINK (PROHIB,PRO   ,FPRO)
CAXI
      CALL SETINI
      GOTO 99
C------------------------------------------------------------
C     2 - AFTER META:GRAMMAR,   BEFORE META:REORG
C
102   CONTINUE
      GOTO 99
C------------------------------------------------------------
C     3 - AFTER META:REORG,     BEFORE GRAM:LRAXIO
C
103   CONTINUE
      IF (PARASK('PARADD',1,6,0) .NE. 0) CALL PARADD
      GOTO 99
C------------------------------------------------------------
C     4 - AFTER GRAM:LRAXIO,    BEFORE GRAM:PARSER
C
104   CONTINUE
      AXIOM = FSYM
      GRAMAX = 0 ! SEE 'SCANS': NEVER A KEYWORD
      GOTO 99
C------------------------------------------------------------
C     5 - AFTER GRAM:PARSER,    BEFORE GRAM:REORG
C
105   CONTINUE
      ITEPAG = PARASK ('ITEPAG',1,6,360)
      IF (ITEPAG .LE. 2) GOTO 1061
      IF (FMEM .GE. ITEPAG) GOTO 1062
        ITEPAG = 0
        GOTO 1061
1062  CONTINUE
        ITEPAG = 1
1061  CONTINUE
      GOTO 99
C------------------------------------------------------------
C     6 - AFTER GRAM:REORG,     BEFORE PROG:PARSER
C
106   CONTINUE
      CLOSE (UNIT=ULIN)
      GOTO 99
C-----------------------------------------------------------
C     7 - WHEN TRANSLATION ONLY, BEFORE PROG:PARSER
C
107   CONTINUE
      CALL HEADER ('SOURCE.DAT',13,1)
      IF (SPATES .LT. 0) GOTO 52
      CALL SPAINI
52    CONTINUE
      OPEN  (UNIT=ULIN,NAME='SOURCE.DAT',TYPE='OLD'
     = 
     = )
      LILANG = PARASK ('LANG',1,4,2) ! FORTRAN
      LINENO = 0
      CALL LINEXT
      CALL CODGET ! LOOK-AHEAD OF THE SCANNER
      IF (PARASK('PARADD',1,6,0) .NE. 0) CALL PARADD
      NEWNUM = PARASK('NEWNUM',1,6,7952)
      OPEN (UNIT=UTRE,ACCESS='DIRECT'
     = ,RECORDSIZE=XXTREH/2
     = ,NAME='TRE.DAT'
     = )
      GRAMAX = FSYM - 1 ! SEE 'SCANS'
      GOTO 99
C-----------------------------------------------------------
C     8 - AFTER PROG:PARSER,    BEFORE PROG:TARGET
C
108   CONTINUE
      CLOSE (UNIT=ULIN)
      IF (PARASK('PARADD',1,6,0) .NE. 0) CALL PARADD
      OPEN (UNIT=UTAR,TYPE='NEW'
     = ,NAME='TARGET.DAT'
     = 
     = )
      GOTO 99
C-----------------------------------------------------------
C     9 - AFTER PROG:TARGET
C
109   CONTINUE
      CLOSE (UNIT=UTAR)
      CLOSE (UNIT=UTRE)
      GOTO 99
C-----------------------------------------------------------
99    CONTINUE
      RETURN
      END
