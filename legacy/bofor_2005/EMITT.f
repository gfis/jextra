      SUBROUTINE EMITT (STATEZ,PRODZ,APPLY)
C     CALLS 'APPLY(STATEB,STATEZ,PRODZ)' FOR ALL 'STATEB' THAT GIVE
C       LOOK-AHEAD SYMBOLS,REDUCTION 'PRODZ' IN 'STATEZ'
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'PRES.F'
      INCLUDE 'PROS.F'
      INCLUDE 'SETS.F'
      INCLUDE 'STAS.F'
      EXTERNAL APPLY
      INTEGER*2 I
     = ,ACTION  ! RESULT OF 'DELTA'
     = ,ITEM     ! -> AN ITEM IN 'STATEB'
     = ,LEFT     ! THE LEFT SIDE OF 'PRODZ'
     = ,PRED     ! -> PREDECESSORS OF 'STATEB'
     = ,PRODZ    ! THIS PRODUCTION IN 'STATEZ' GETS THE SYMBOLS
     = ,STATE    ! A STATE IN THE TARGET SET
     = ,STATEB   ! THIS STATE EMITTS THE SYMBOLS
     = ,STATEZ   ! THIS STATE GETS THE SYMBOLS
     = ,SUCPRO  ! RESULT OF 'DELTA'
     = ,TARGET   ! ->,AN ELEMENT OF THE SET GENERATED,MOVING BACK 1
     = ,TEMP     ! FOR INTERCHANGING SOURCE AND TARGET
C
      ! EMITTH = EMITTT, EMITSH = EMITST
      CALL SEPUSH(STAMAR,STATEZ,EMITST,EMITSB) ! START WITH 'STATEZ
      STAMAR(STATEZ) = STAMAR(STATEZ) - EMITSB
        ! DO NOT MARK IN 'EMITS'-SET
C
      ! MOVE THE MARKER BACK 'PROLNG' POSITS IN A TREE OF STATES
      I = 1
1     IF(I .GT. PROLNG(PRODZ)) GOTO 2
        ! GENERATE TARGET = PRE(SOURCE)
3       IF(EMITSH .EQ. EMITST) GOTO 4
          TEMP = 0
          CALL SETPOP(STAMAR,STATEB,EMITSH,TEMP)
          PRED = STAPRE(STATEB)
5         IF(PRED .GE. PREHIB) GOTO 6
            ! COPY PREDECESSORS INTO TARGET SET
            CALL SEPUSH(STAMAR,PRESTA(PRED),EMITTT,EMITTB)
            PRED = PRE(PRED)
          GOTO 5
6         CONTINUE ! ALL PREDECESSORS
        GOTO 3
4       CONTINUE ! ALL IN SOURCE SET
C
        ! UNMARK ALL STATES IN TARGET SET
        TARGET = EMITTH
7       IF(TARGET .EQ. EMITTT) GOTO 8
          STATE = SETELE(TARGET)
          STAMAR(STATE) = STAMAR(STATE) - EMITTB
          TARGET = SET(TARGET)
        GOTO 7
8       CONTINUE ! UNMARK
C
        ! INTERCHANGE TARGET AND SOURCE SETS (THE LATTER IS EMPTY)
        TEMP = EMITSH
        EMITSH = EMITTH!
        EMITTH = TEMP!
        TEMP = EMITST
        EMITST = EMITTT!
        EMITTT = TEMP!
        I = I + 1
      GOTO 1
2     CONTINUE ! I = 1 ... PROLNG
C
      ! NOW THE MARKER IS BEFORE THE 1ST MEMBER OF 'PRODZ' IN ALL STATES
      !   IN THE SOURCE SET. SHIFT THE LEFT SIDE AND GENERATE A TARGET S
      LEFT = PROLEF(PRODZ)
9     IF(EMITSH .EQ. EMITST) GOTO 10
        TEMP = 0
        CALL SETPOP(STAMAR,STATEB,EMITSH,TEMP)
        CALL DELTA (STATEB,LEFT,  ACTION,SUCPRO)
        IF (ACTION .NE. SHIFT) GOTO 12
            CALL SEPUSH(STAMAR,SUCPRO,EMITTT,EMITTB)
            GOTO 100
12      CONTINUE ! ALL ITEMS
C       CALL ASSERT(3,LEFT,STATEB)
C       CALL ASSERT(3,ACTION,SUCPRO)
C
100     CONTINUE !        LEAVE:
      GOTO 9
10    CONTINUE ! ALL IN SOURCE SET
C
      ! NOW CALL 'APPLY' AND UNMARK THE STATES IN THE TARGET SET
14    IF(EMITTH .EQ. EMITTT) GOTO 15
        CALL SETPOP(STAMAR,STATEB,EMITTH,EMITTB)
        CALL SEPUSH(STAMAR,STATEB,LAPUTT,LAPUTB)
      GOTO 14
15    CONTINUE ! ALL IN TARGET SET
      RETURN! EMITT
      END
