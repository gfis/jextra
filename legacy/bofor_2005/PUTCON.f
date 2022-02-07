      SUBROUTINE PUTCON
C     PRINT ALL DIFFERENT CONFLICTS
C     2005-03-29: demingle MEMSETS, STASTRS
C     GF 20.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'MEMS.f'
      INCLUDE 'PRES.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SETS.f'
      INCLUDE 'STAS.f'
      INCLUDE 'STRS.f'
      INCLUDE 'SYMS.f'
      INTEGER*2 PARASK, ZZINDX
      INTEGER*2 I,J
     = ,CONH     ! HEAD OF CONFLICT-LIST IN 'PRE'
     = ,CONFL    ! =1 IF (A CONFLICT WAS FOUND
     = ,ELEM     ! ->  ELEMENT IN SPLIT-QUEUE
     = ,GOT     ! RESULT OF 'ITEMA1/2', =1 IF STATE WAS READ
     = ,I1       ! -> FIRST ITEM FOR COMPARISION
     = ,I2       ! -> 2ND   ITEM FOR COMPARISION
     = ,ITEM     ! -> CURRENT ITEM
     = ,ITEMA    ! FIRST ITEM WITH SYMBOL 'SYMA'
     = ,POS      !,FIND THE END OF THE PRODUCTION
     = ,PRED     ! -> PRE
     = ,PROD     ! A MARKED PRODUCTION INVOLVED IN THE CONFLICT
     = ,SAME     ! =1 IF (SAME CONFLICT ALREADY STORED
     = ,STATE    ! THE STATE WHICH CONTAINS THE CONFLICT
     = ,SYMA     ! = ITESYM(ITEMA)
C
      IF (PARASK('SINGLE',1,6,0) .EQ. 0) GOTO 1
        ELEM = SET(SYMINH)
        I = 0 ! COUNT UNREACHABLES
        IF (SYMINH .EQ. SYMINT) GOTO 3
2       IF(ELEM .EQ. SYMINT) GOTO 3
          I = I + 1
          ELEM = SET(ELEM)
        GOTO 2
3       CONTINUE
        CALL ZZWI (I,4)
      GOTO 34
1     CONTINUE ! IF (SINGLE
C     DO ! ONLY SPECIFIC INFORMATION ON INACCESIBLES AND CONFLICTS
        ! MARK TERMINALS IN CROSS-REFERENCE-TABLE
        CALL ASSERT (196,0,0)
        J = FSYM - 1
        DO 4 I = 2,J
          IF (SYMPRO(I) .LT. PROHIB) GOTO 5 ! TERMINALS
C           CALL OUTXRE(' ',SUBSTR(STRNG,SYMPOS(I),SYMEND(I)),'TERM',' '
            IF (ZZINDX(STRNG,SYMPOS(I),SYMEND(I),'_') .LE. 0) GOTO 38
              CALL PUTSYM (I)
              CALL ZZWS (0)
38          CONTINUE
5         CONTINUE ! IF TERMINAL
4       CONTINUE ! 2 ... FSYM -1
C
        IF (SYMINH .EQ. SYMINT) GOTO 6 !   IF HYPER_AXIOM IS ALREADY OFF
        ELEM = SET(SYMINH)
        IF (ELEM .EQ. SYMINT) GOTO 6 ! UNREACHABLE SYMBOLS DO EXIST
          CALL ASSERT(198,0,0)
7         IF (ELEM .EQ. SYMINT) GOTO 8
            CALL PUTSYM(SETELE(ELEM))
          CALL ZZWS (0)
            ELEM = SET(ELEM)
          GOTO 7
8         CONTINUE
6       CONTINUE ! UNREACHABLE SYMBOLS
C
        CONH = PREHIB ! THE LIST IS EMPTY INITIALLY
        ELEM = SPLITH
12      IF(ELEM .EQ. SPLITT) GOTO 13
          STATE = SETELE(ELEM)
          CALL ITEMA1 (STATE,  ITEMA,GOT)
          SYMA = ITESYM(ITEMA)!
14        IF(ITEMA .GE. ITEHIB) GOTO 15
            CONFL = 0
            ITEM = ITE(ITEMA)
16          IF(ITESYM(ITEM) .NE. SYMA) GOTO 17
              IF (ITEACT(ITEM) .NE. REDUCE) GOTO 18
                CONFL = 1
18            CONTINUE
              ITEM = ITE(ITEM)
            GOTO 16
17          CONTINUE ! = SYMA
            IF (CONFL .NE. 1) GOTO 19 ! CONFLICT FOR 'SYMA' FOUND
            WRITE (UPRI,36)
36          FORMAT(1X,8(10H----------))
            CALL ASSERT (197,-SYMA,0)
C             CONFLICT FOR SYMBOL @:
31          IF(ITESYM(ITEMA) .NE. SYMA) GOTO 32
              POS = ITEPOS(ITEMA)
29            IF(MEM(POS) .EQ. EOP) GOTO 30
                POS = POS + 1
              GOTO 29
30            CONTINUE ! .EQ. 1
              PROD = MEMNUC(POS)
              CALL OUTMAP(PROD,ITEPOS(ITEMA))
              CALL ZZWS(0)
              ITEMA = ITE(ITEMA)
            GOTO 31
32          CONTINUE ! = SYMA
19          CONTINUE ! CONFL = 1
            ITEMA = ITEM
            SYMA = ITESYM(ITEMA)!
          GOTO 14
15        CONTINUE ! .GE. ITEHIB
          CALL ITEMA8 (STATE,GOT)
          ELEM = SET(ELEM)
        GOTO 12
13      CONTINUE ! .EQ. SPLITT
34    CONTINUE ! SPECIFIC
      RETURN! PUTCON
      END
