      SUBROUTINE LACOPY (STATEB, STATEZ, PRODZ)
C     ALL SYMBOLS (THE TERMINALS) OF 'STATEB' ARE USED AS LOOK-AHEAD
C       SYMBOLS FOR PRODUCTION 'PRODZ' IN 'STATEZ'
C     CALLED AS 'APPLY' FROM 'LAGET' AND 'LAPUT'
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'PROS.F'
      INCLUDE 'SETS.F'
      INCLUDE 'STAS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,B2       ! AN ITEM OF 'STATEB' = FROM THE SOURCE
     = ,DIFF1    !,COMPARE THE SYMBOLS
     = ,DIFF2    !,COMPARE THE ACTIONS
     = ,DIFF3    !,COMPARE THE POSITS
     = ,GOTZ
     = ,GOTB    ! RESULT OF 'ITEMA2'
     = ,I1       ! -> ONE ELEMENT BEFORE THE ELEMENT INSPECTED
     = ,I2       ! THE CURRENT ITEM INSPECTED
     = ,ITEM     ! -> THE ITEM FINALLY INSERTED
     = ,POSIT ! INSERT AN ITEM WITH THE MARKER BEFORE THIS POSITION
     = ,PRODZ    ! GET THE LOOK-AHEAD SYMBOLS FOR THIS PRODUCTION
     = ,STATEB   ! TAKE SYMBOLS FROM THIS STATE
     = ,STATEZ   ! INSERT REDUCTIONS IN THIS STATE
     = ,SYMBOL   ! A LOOK-AHEAD SYMBOL OF 'STATEB'
C
      CALL ITEMA2 (STATEZ,  I1,I2,GOTZ)
      POSIT = PROMON(PRODZ) + PROLNG(PRODZ) ! ON THE DUMMY SYMBOL
      SYMBOL = 1
      CALL ITEMA1 (STATEB,  B2,GOTB)
1     IF(ITESYM(B2) .NE. SYMBOL) GOTO 2 ! SKIP OVER DUMMY SYMBOLS
        B2 = ITE(B2)
      GOTO 1
2     CONTINUE ! SKIP DUMMY
3     IF(B2 .GE. ITEHIB) GOTO 4 ! ALL IN SOURCE
      SYMBOL = ITESYM(B2)
5     IF(I1 .GE. ITEHIB) GOTO 6
        DIFF1 = SYMBOL - ITESYM(I2)
        IF (DIFF1 .GE. 0) GOTO 7 ! SYMBOL .GE.
          CALL SEPUSH(STAMAR,STATEZ,LAPUTT,LAPUTB)
          GOTO 100
C       CONTINUE ! SYMBOL .GE.
7       CONTINUE
        IF (DIFF1 .NE. 0) GOTO 9 ! SYMBOL =
          DIFF2 = REDUCE - ITEACT(I2)
          ! 'DIFF2 .GE. 0' NOT POSSIBLE
          IF (DIFF2 .NE. 0) GOTO 10 ! ANOTHER REDUCTION THERE
            DIFF3 =  POSIT - ITEPOS(I2)
            IF (DIFF3 .GE. 0) GOTO 11 ! POSIT .GE.
              GOTO 100
C           CONTINUE ! POSIT .GE.
11          CONTINUE
            IF (DIFF3 .NE. 0) GOTO 12 ! POSIT =
              GOTO 101
12          CONTINUE ! POSIT =
            ! ELSE POSIT > : TRY NEXT ELEMENT
10        CONTINUE ! ACTION =
          ! ELSE ACTION > : NOT POSSIBLE
9       CONTINUE ! SYMBOL =
        ! ELSE SYMBOL > : TRY NEXT ELEMENT
        I1 = I2
        I2 = ITE(I1)!
      GOTO 5
6     CONTINUE ! ALL ITEMS IN TARGET
C
100   CONTINUE !      INSERT:
      IF (PARASK('TERMLA',1,6,0) .NE. 0 .AND.
     =    SYMPRO(SYMBOL) .NE. PROHIB)
     =GOTO 13
        IF (ITESYM(I1) .EQ. SYMBOL .OR. ITESYM(I2) .EQ. SYMBOL)
     =    CALL SEPUSH(STAMAR,STATEZ,SPLITT,SPLITB)
        CALL ITEALL (SYMBOL,POSIT,REDUCE,PRODZ,  I1,I2)
13    CONTINUE ! TERMLA
C
101   CONTINUE !      DONE:
      B2 = ITE(B2) ! SKIP ALL FOLLOWING ITEMS WITH 'SYMBOL'
16    IF(ITESYM(B2) .NE. SYMBOL) GOTO 17
        B2 = ITE(B2)
17    CONTINUE ! SKIP FOLLOWING
      GOTO 3
4     CONTINUE ! ALL IN SOURCE
      CALL ITEMA8 (STATEB,GOTB)
      CALL ITEMA9 (STATEZ,GOTZ)
      RETURN! LACOPY
      END