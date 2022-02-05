      SUBROUTINE LINEXT
C     GET NEXT LINE FROM SOURCE-PROGRAM
C
      INCLUDE 'PARS.F'
      INCLUDE 'LINS.F'
      INCLUDE 'PROS.F'
      INTEGER*2 ZZCR
      INTEGER*2 I
     = ,MARRD2  ! RIGHT MARGIN IN WORDS
     = ,BL6(3)  ! 6 BLANKS
      DATA BL6 /2H  ,2H  ,2H  /
C
10    CONTINUE ! LIREAD:
      READ (ULIN,1,END=2) LINE
1     FORMAT(41A2)
C     DETERMINE THE LAST WORD NOT CONTAINING BLANKS
      MARRD2 = XXLINH + 1
4     CONTINUE
        MARRD2 = MARRD2 - 1
      IF(LINE(MARRD2) .EQ. BL6(1)) GOTO 4
      IF(MARRD2 .LE. 0) MARRD2 = 1
      LIMARR = MARRD2*2
      LINENO = LINENO + 1
      WRITE(UPRI,3) LINENO,FPRO,(LINE(I),I=1,MARRD2)
3     FORMAT(1X,2I5,2X,41A2)
      FLIN = LIMARL
      GOTO (101,102,103), LILANG
C--------------------------------------------------------
102   CONTINUE ! FORTRAN
C
      IF (ZZCR(LINE,1,1,'C',1,1) .EQ. 0 .OR.
     =    ZZCR(LINE,1,1,'*',1,1) .EQ. 0
     =) GOTO 10 ! LIREAD
      IF (ZZCR(LINE,6,6,'0',1,1) .EQ. 0)
     =  CALL ZZCC (BL6,1,1,LINE,6,6)
      IF (ZZCR(LINE,6,6,BL6,1,1) .NE. 0) GOTO 1021
C       NEW STATEMENT BEGINS
        LINOCO = 0
        FLIN = LIMARR + 2 ! BEHIND 'LIEOLC'
        CALL ZZIC (LIEOFC,LINE,FLIN)
      GOTO 1022
1021  CONTINUE
C       CONTINUATION LINE
        IF (ZZCR(LINE,1,5,BL6,1,5) .EQ. 0) GOTO 1023
          CALL ASSERT (145,0,0)
C           COLUMNS 1-5 OF CONTINUATION LINE NOT ALL BLANKS
1023    CONTINUE
        LINOCO = LINOCO + 1
        IF (LINOCO .LE. 19) GOTO 1024
          CALL ASSERT (146,19,0)
C           MORE THAN @ CONTINUATION LINES
1024    CONTINUE
        FLIN = 7
1022  CONTINUE
      GOTO 99
C-------------------------------------------------------
101   CONTINUE ! PL/1-LIKE
103   CONTINUE ! COBOL
C
      FLIN = LIMARL
      GOTO 99
C-------------------------------------------------------
99    CONTINUE
      CALL ZZIC (LIEOLC,LINE,LIMARR + 1) ! SET STOPPING CHAR.
      RETURN
C
C     PROCESS END OF FILE
2     CONTINUE
      FLIN = 1
      CALL ZZIC (LIEOFC,LINE,FLIN)
      LINENO = LINENO + 1
      RETURN ! AFTER EOF
      END
