      SUBROUTINE STAGAR
C     5GARBAGE COLLECTION FOR STATES THAT ARE NO MORE ACCESSIBLE
C     5'STAGAX' FOR ILL, 'STAGBX' FOR SURVIVING STATES
C     GF 12.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'PRES.f'
      INCLUDE 'SETS.f'
      INCLUDE 'STAS.f'
      INTEGER*2 I
     = ,ELEM     ! -> AN ELEMENT OF THE SETS
     = ,GOT     ! RESULT OF 'ITEMA1/2', =1 IF STATE WAS READ
     = ,ITEM
     = ,MARKAB   ! ILL AND SURVIVING BITS OF A STATE
     = ,P1       ! -> ONE BEFORE 'P2'
     = ,P2       ! -> CURRENT PREDECESSOR
     = ,PRED
     = ,STATE    ! A DEAD STATE
     = ,STATEA   ! A PREDECESSOR OF AN ILL STATE
     = ,STATEB   ! A SUCCESSOR OF A SURVIVING STATE
C
      ! ALL SUCCESSORS OF ILL STATES GET ILL
      ELEM = STAGAH
1     IF(ELEM .EQ. STAGAT) GOTO 2
        CALL ITEMA1 (SETELE(ELEM),  ITEM,GOT)
3       IF(ITEM .GE. ITEHIB) GOTO 4
          IF (ITEACT(ITEM) .NE. SHIFT .OR. ITESYM(ITEM) .LE. 1) GOTO 23
            CALL SEPUSH(STAMAR,ITESUC(ITEM),STAGAT,STAGAB)
23        CONTINUE
          ITEM = ITE(ITEM)
        GOTO 3
4       CONTINUE ! ALL ITEMS
        CALL ITEMA8 (SETELE(ELEM),GOT)
        ELEM = SET(ELEM)
      GOTO 1
2     CONTINUE ! ALL ILL STATES
C
      ! ILL STATES THAT HAVE A SOUND PREDECESSOR WILL SURVIVE
      ELEM = STAGAH
5     IF(ELEM .EQ. STAGAT) GOTO 6
        STATE = SETELE(ELEM)
        PRED = STAPRE(STATE)
7       IF(PRED .GE. PREHIB) GOTO 8
          STATEA = PRESTA(PRED)
          IF (MOD(STAMAR(STATEA),STAGAB+STAGAB) .GE. STAGAB ) GOTO 9
            ! PREDECESSOR IS NOT ILL
            CALL SEPUSH(STAMAR,STATE,STAGBT,STAGBB)
            GOTO 100
9         CONTINUE ! NOT MARKED "SURVIVING"
          PRED = PRE(PRED)
        GOTO 7
8       CONTINUE ! ALL PREDECESSORS
C
100     CONTINUE ! LEAVE:
        ELEM = SET(ELEM)
      GOTO 5
6     CONTINUE ! ALL ILL STATES
C
      ! ALL (ILL) SUCCESSORS OF SURVIVING STATES WILL SURVIVE
      ELEM = STAGBH
10    IF(ELEM .EQ. STAGBT) GOTO 11
        CALL ITEMA1 (SETELE(ELEM),  ITEM,GOT)
12      IF(ITEM .GE. ITEHIB) GOTO 13
          IF (ITEACT(ITEM) .NE. SHIFT .OR. ITESYM(ITEM) .LE. 1) GOTO 15
            ! REQUESTS FOR 'STASUC' ARE ALL PROCESSED
            STATEB = ITESUC(ITEM)
            IF (MOD(STAMAR(STATEB),STAGAB+STAGAB).LT.STAGAB ) GOTO 14
              ! SUCCESSOR IS ILL
              CALL SEPUSH(STAMAR,STATEB,STAGBT,STAGBB)
14          CONTINUE ! IS MARKED ILL
15        CONTINUE ! SHIFT-ITEM
          ITEM = ITE(ITEM)
        GOTO 12
13      CONTINUE ! ALL ITEMS
        CALL ITEMA8 (SETELE(ELEM),GOT)
        ELEM = SET(ELEM)
      GOTO 10
11    CONTINUE ! ALL ILL STATES
C
      ! DELETE ALL STATES THAT DID NOT SURVIVE
      ELEM = STAGAH
16    IF(ELEM .EQ. STAGAT) GOTO 17
        ! NOT 'SETPOP', ILL BIT IS TESTED AFTER 'STAFRE' TOO
        STATE = SETELE(ELEM)
        IF (MOD(STAMAR(STATE),STAGBB+STAGBB) .GE. STAGBB) GOTO 18
          ! NOT SURVIVING
          CALL STAFRE(STATE)
        GOTO 19
18      CONTINUE ! CORRECT THE SET OF PREDECESSORS
          PRE(1) = STAPRE(STATE)
          P1 = 1
          P2 = PRE(1)!
20        IF(P2 .GE. PREHIB) GOTO 21
            MARKAB = STAMAR(PRESTA(P2))
            IF (MOD(MARKAB,STAGBB+STAGBB) .GE. STAGBB
     =        ! NOT SURVIVING , 'STAMAR' IS NOT CLEARED,'STAFRE'
     =      .OR.  MOD(MARKAB,STAGAB+STAGAB) .LT. STAGAB ! AND ILL
     =      ) GOTO 22
              PRE(P1) = PRE(P2)
              PRE(P2) = FPRE
              FPRE = P2!
              P2 = P1
22          CONTINUE ! NOT SURVIVING
            P1 = P2
            P2 = PRE(P1)!
          GOTO 20
21        CONTINUE ! ALL PREDECESSORS
          STAPRE(STATE) = PRE(1)
19      CONTINUE ! CORRECT
        ELEM = SET(ELEM)
      GOTO 16
17    CONTINUE ! ALL ILL STATES
C
      ! DELETE BOTH SETS
      CALL SETFRE(STAMAR,STAGAH,STAGAT,STAGAB)
      CALL SETFRE(STAMAR,STAGBH,STAGBT,STAGBB)
      RETURN! STAGAR
      END
