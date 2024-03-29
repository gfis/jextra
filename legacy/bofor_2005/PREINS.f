      SUBROUTINE PREINS(STATEA,STATEB)
C     INSERT 'STATE' IN THE SET OF PREDECESSORS OF 'STATEB'
C     GF 09.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'PRES.f'
      INCLUDE 'STAS.f'
      INTEGER*2 I
     = ,DIFF     !,COMPARE THE PREDECESSOR-STATES
     = ,P1       ! -> ELEMENT BEFORE 'P2'
     = ,P2       ! -> CURRENT PREDECESSOR OF 'STATEB'
     = ,PRED     ! -> NEW PREDECESSOR INSERTED
     = ,STATEA   ! INSERT THIS STATE
     = ,STATEB   ! INSERT IN THE SET OF PREDECESSORS OF THIS STATE
C
      PRE(1) = STAPRE(STATEB)
      P1 = 1
      P2 = PRE(P1)!
1     IF(P1 .GE. PREHIB) GOTO 2
        DIFF = STATEA - PRESTA(P2)
        IF (DIFF .GE. 0) GOTO 3 ! INSERT BETWEEN 'P1' AND 'P2'
          IF (FPRE .GE. PREHIB) GOTO 6
            PRED = FPRE
            FPRE = PRE(FPRE)!
            PRESTA(PRED) = STATEA
            PRE(PRED) = P2
            PRE(P1) = PRED
          GOTO 7 ! NO 'PRE'-OVERFLOW
6         CONTINUE
            CALL ASSERT(11,STATEA,STATEB)
7         CONTINUE
          GOTO 100
C       GOTO 4 ! STATEA .GE.
3       CONTINUE
        IF (DIFF .NE. 0) GOTO 5 ! 'STATEA' ALREADY IN 'PRE'
          CALL ASSERT(23,STATEA,STATEB)
          GOTO 100
5       CONTINUE ! STATEA =
4       CONTINUE  ! TRY NEXT ELEMENT
        P1 = P2
        P2 = PRE(P1)!
      GOTO 1
2     CONTINUE ! ALL PREDECESSORS
      CALL ASSERT(43,STATEB,STATEA)
C
100   CONTINUE ! DONE
      STAPRE(STATEB) = PRE(1)
      PRINT *, 'return from preins'
      RETURN! PREINS
      END
