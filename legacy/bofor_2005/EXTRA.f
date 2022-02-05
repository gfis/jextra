      PROGRAM EXTRA
C     EXTENSIBLE TRANSLATOR MAIN PROGRAM
C     GF 12.07.1980 : WITH OPEN ULIN, PARADD WITHOUT PARAMETERS
C     GF 27.12.1980: DIRECT(7) = OPEN READONLY
C
      INTEGER*2 PARASK
      EXTERNAL SCANS
      INTEGER*2 I
     = ,WHAT    ! PARAMETER FOR 'PREPAR'
C
      CALL PARADD
      IF (PARASK('GENER',1,5,0) .NE. 0) GOTO 2
        WHAT = 6
        GOTO 1
2     CONTINUE
C---------------------------------------------------------
      WHAT = 1
      CALL PREPAR (WHAT)
      CALL GRAMAR
C---------------------------------------------------------
      WHAT = WHAT + 1
      CALL PREPAR (WHAT)
      CALL DIRECT (5) ! OPEN
      CALL REORG ! META-GRAMMAR
C-------------------------------------------------------
      WHAT = WHAT + 1
      CALL PREPAR (WHAT)
C------------------------------------------------------
      WHAT = WHAT + 1
      CALL PREPAR (WHAT)
      CALL PARSER (SCANS) ! USER-GRAMMAR
C------------------------------------------------------
      WHAT = WHAT + 1
      CALL PREPAR (WHAT)
      CALL REORG ! USER-GRAMMAR
C-----------------------------------------------------
      WHAT = WHAT + 1
      CALL DIRECT (4) ! WRITE ALL
      CALL DIRECT (6) ! CLOSE
      CALL PREPAR (WHAT)
C******************************************************
1     CONTINUE
      WHAT = WHAT + 1
      CALL DIRECT (5) ! OPEN
      CALL DIRECT (3) ! READ ALL
      CALL PREPAR (WHAT)
      I = PARASK('OUTSTA',1,6,0)
      IF (I .EQ. 0) GOTO 3
        CALL OUTSTA (I)
        STOP
3     CONTINUE
      CALL PARSER (SCANS) ! USER-PROGRAM
C-----------------------------------------------------
      CALL DIRECT (6) ! CLOSE
      WHAT = WHAT + 1
      CALL PREPAR (WHAT)
      CALL TARGET
C---------------------------------------------------------
      WHAT = WHAT + 1
      CALL PREPAR(WHAT)
C---------------------------------------------------------
      STOP
      END
