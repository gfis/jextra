      SUBROUTINE SEPUSH (XMAR,X,XTAIL,XBIT)
C     PUSH AN ELEMENT IN A SET
C
      INCLUDE 'PARS.f'
      INCLUDE 'SETS.f'
      INTEGER*2 PARASK
     = ,I
     = ,I1       ! -> THE ELEMENT BEFORE 'I2'
     = ,I2       ! -> CURRENT ELEMENT
     = ,X        ! ELEMENT TO BE MARKED
     = ,XBIT     ! THE BIT THAT IS MARKED
     = ,XHEAD    ! -> BEGIN AND
     = ,XMAR(1)  ! ARRAY THAT CONTAINS THE MARKINGS
     = ,XTAIL    ! APPEND TO THIS SET
C
CXML
C     XML3 (SEPUSH, X, XTAIL, XBIT)
      CALL XML3 ('SEPUSH', 1, 6, X,XTAIL,XBIT)
      IF (MOD(XMAR(X),XBIT+XBIT) .GE. XBIT) GOTO 3 ! NOT YET IN THE SET
        XMAR(X) = XMAR(X) + XBIT ! MARK THE VALUE
        IF (FSET .GE. SETHIB) GOTO 4
          SETELE(XTAIL) = X ! STORE THE VALUE
          SET   (XTAIL) = FSET
          XTAIL = FSET
          FSET = SET(FSET)
        GOTO 5 ! 'SET' NOT EXHAUSTED
4       CONTINUE
          CALL ASSERT(20,XTAIL,X)
5     CONTINUE
3     CONTINUE ! NOT MARKED
      RETURN ! SEPUSH
C------------------------------------------------------
      ENTRY SETALL (XHEAD,XTAIL,XBIT)
C     ALLOCATE A NEW SET
C
      XBIT = POT2
      POT2 = POT2 + POT2
      IF (FSET .GE. SETHIB) GOTO 1
        XHEAD = FSET
        XTAIL = XHEAD
        FSET = SET(FSET) 
      GOTO 2 ! .GE. SETHIB
1     CONTINUE
        CALL ASSERT(5,FSET,SETHIB)
2     CONTINUE
      RETURN ! SETALL
C----------------------------------------------------------
      ENTRY SETBIN
C     RESET 'POT2' FOR SUCCESSIVE CALLS OF 'SETALL'
C
      POT2 = 1
      RETURN ! SETBIN
C----------------------------------------------------------
      ENTRY SETDEL (XMAR,X,XHEAD,XTAIL,XBIT)
C     DELETE A SINGLE ELEMENT OF A LIST/SET
C
      IF (MOD(XMAR(X),XBIT+XBIT)  .LT. XBIT) GOTO 8 ! 'X' IS MARKED
        XMAR(X) = XMAR(X) - XBIT
        SET(1) = XHEAD
        I1 = 1
        I2 = SET(I1)!
13      IF(I2 .EQ. XTAIL) GOTO 9
          IF (SETELE(I2) .NE. X) GOTO 10 ! RIGHT ELEMENT FOUND
            SET(I1) = SET(I2)
            SET(I2) = FSET
            FSET = I2!
            GOTO 100
10        CONTINUE ! FOUND
          I1 = I2
          I2 = SET(I1)!
        GOTO 13
9       CONTINUE ! ALL ELEMENTS
        ! 'X' WAS NOT FOUND HERE
        CALL ASSERT(13,X,XTAIL)
C
100     CONTINUE
        XHEAD = SET(1)
8     CONTINUE ! WAS MARKED
      RETURN ! SETDEL
C------------------------------------------------------------------
      ENTRY SETFRE (XMAR,XHEAD,XTAIL,XBIT)
C     DELETE AN ENTIRE SET AND UNMARK ALL ELEMENTS
C
14    IF(XHEAD .EQ. XTAIL) GOTO 12
        I1 = SETELE(XHEAD)
        XMAR(I1) = XMAR(I1) - XBIT
        I = XHEAD
        XHEAD = SET(XHEAD)
        SET(I) = FSET
        FSET = I!
      GOTO 14
12    CONTINUE ! WHILE NOT EMPTY
      RETURN ! SETFRE
C------------------------------------------------------------
      ENTRY SETPOP (XMAR,X,XHEAD,XBIT)
C     TAKE AN ELEMENT FROM THE HEAD OF A QUEUE
C
      X = SETELE(XHEAD)
      XMAR(X) = XMAR(X) - XBIT
      I = XHEAD
      XHEAD = SET(XHEAD)
      SET(I) = FSET
      FSET = I!
      RETURN ! SETPOP
      END
