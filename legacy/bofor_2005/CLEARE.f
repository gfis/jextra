      SUBROUTINE CLEARE
C     CLEAR REDUCE- AND SHIFT-ITEMS
C     2005-03-29: demingle STASTRS
C     GF 16.07.1980
C     GF 04.04.1981: DO NOT 'CLEARE' ITEMS FOR IDENTIFIERS/KEYWORDS
C
C     ALL ITEMS FOR THE 1ST REDUCTION ARE DELETED FROM THE STATES
C     AND REPLACED BY AN ITEM WITH DUMMY LOOK-AHEAD 'EOP'
C     (EVEN THE 1ST MAY NOT EXIST, OR MAY BE THE ONLY ONE)
C
C     FOR SHIFT-ITEMS FOR THE SAME SYMBOL ALL BUT THE 1ST
C     MARKED PRODUCTION ARE DELETED, IF PARAMETER 'CLEASH' = 1
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'MEMS.F'
      INCLUDE 'PROS.F'
      INCLUDE 'STAS.F'
      INCLUDE 'STRS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 PARASK
      INTEGER*2 ZZCR
      INTEGER*2 I1,I2   ! -> 2 SUCCESSIVE ITEMS
     = ,CLEASH  ! = 'SHIFT' (0) IFF SHIFT-ITEMS ARE (NOT) TO BE CLEARED
     = ,DERED   ! NUMBER OF DELETED REDUCE-ITEMS
     = ,DESHI   ! ... SHIFT-ITEMS
     = ,GOT     ! RESULT OF 'ITEMA2'
     = ,MAXITE  ! MAX. NO. OF ITEMS IN A STATE BEFORE DELETION
     = ,NUMITE  ! NUMBER OF ITEMS IN A PARITCULAR STATE
      INTEGER*2 POS  ! -> 1ST CHARACTER OF 'SYMBOL'
     = ,RED     ! THE 1ST REDUCTION
     = ,RED2    ! AN EVENTUALLY PRESENT 2ND REDUCTION
     = ,STATE   ! ONE OF ALL STATES IN THE PARSING TABLE
     = ,STATEA  ! A SUCCESSOR OF 'STATE'
     = ,SUMITE  ! NUMBER OF ITEMS IN ALL STATES BEFORE DELETION
     = ,SYMBOL  ! IS THIS SYMBOL A KEYWORD OR IDENTIFIER ?
C
      DERED = 0
      DESHI = 0
      MAXITE = 0
      SUMITE = 0
      CLEASH = PARASK ('CLEASH',1,6,1) ! 1 => CLEASH = SHIFT
      DO 1 STATE = 2,FSTA
        IF (STAITE(STATE) .EQ. 0) GOTO 2 ! STATE EXISTS
          NUMITE = 0
          RED = 0  ! 1ST DOES NOT EXIST
          RED2 = 0 ! 2ND DOES NOT EXIST
          STATEA=0 ! SUCCESSOR DOES NOT YET EXIST
          CALL ITEMA2 (STATE,  I1,I2,GOT)
3         IF(I2 .GE. ITEHIB) GOTO 4 ! FOR ALL ITEMS 'I2'
            NUMITE = NUMITE + 1
            IF (ITEACT(I2) .NE. REDUCE) GOTO 5
            SYMBOL = ITESYM(I2) ! <---- was ITEM???
            POS = SYMPOS(SYMBOL)
            IF (ZZCR (STRNG,POS,POS,'A',1,1) .GE. 0) GOTO 5
C             HERE IT IS NO IDENTIFIER OR KEYWORD
              IF (RED .NE. 0) GOTO 6 ! 1ST RED IN THE STATE
                RED = ITESUC(I2)
6             CONTINUE
              IF (ITESUC(I2) .NE. RED)
     =          GOTO 100 ! KEEP
              DERED = DERED + 1 ! WILL BE DELETED
            GOTO 7
5           CONTINUE ! .NE. REDUCE
            IF (ITEACT(I2) .NE. CLEASH) GOTO 8
              IF (ITESUC(I2) .EQ. STATEA) GOTO 9
                STATEA = ITESUC(I2)
                GOTO 100 ! KEEP
9             CONTINUE
              DESHI = DESHI + 1 ! WILL BE DELETED
            GOTO 7
8           CONTINUE
            GOTO 100 ! KEEP
7           CONTINUE
C
101         CONTINUE ! DELETE:
            ITE(I1) = ITE(I2)
            ITE(I2) = FITE
            FITE = I2
            I2 = I1
C
100         CONTINUE ! KEEP:
            I1 = I2
            I2 = ITE(I1)
          GOTO 3
4         CONTINUE ! ALL ITEMS
C
          IF (NUMITE .GT. MAXITE) MAXITE = NUMITE
          SUMITE = SUMITE + NUMITE
C
          IF (RED .EQ. 0) GOTO 10
C           INSERT 'RED' WITH DUMMY LA 'EOP'
            DERED = DERED - 1
            I1 = 1
            I2 = ITE(I1)
            CALL ITEALL (EOP,PROMON(RED)+PROLNG(RED),REDUCE,RED, I1,I2)
            IF (RED2 .EQ. 0) GOTO 11
              CALL ASSERT(60,STATE,RED2)
C               STATE @ CONTAINS AT LEAST A 2ND REDUCTION @
11          CONTINUE
10        CONTINUE ! RED .NE. 0
          CALL ITEMA9 (STATE,GOT)
2       CONTINUE ! STATE EXISTS
1     CONTINUE ! ALL STATES
C
      CALL INFSTO (6,MAXITE,SUMITE)
      CALL ASSERT (130,DERED,DESHI)
C       @ REDUCE- AND @ SHIFT-ITEMS DELETED
      RETURN
      END
