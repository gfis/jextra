      SUBROUTINE RECEIV (STATEB,APPLY)
C     CALLS 'APPLY(STATEB,STATEZ,PRODZ)' FOR ALL REDUCTIONS 'PRODZ' IN
C       'STATEZ' THAT RECEIVE THEIR LOOK-AHEAD SYMBOLS FROM 'STATEB'
C     GF 09.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'PRES.f'
      INCLUDE 'PROS.f'
      INCLUDE 'STAS.f'
      INCLUDE 'SYMS.f'
      EXTERNAL APPLY
      INTEGER*2 I
     = ,PRED     ! -> A PREDECESSOR OF 'STATEA'
     = ,PROD     ! A PRODUCTION OF THE REACHING SYMBOL OF 'STATEB'
     = ,PRODZ    ! MUST BE = 'PROD'
     = ,STATEA   ! A PREDECESSOR OF 'STATEB'
     = ,STATEB   ! THE STATE THAT EMITTS THE LOOK-AHEAD SYMBOLS
     = ,STATEZ   ! THE STATE THAT HAS THE REDUCTION TO THE REACHING SYMB
C
      PROD = SYMPRO(STASYM(STATEB))
1     IF(PROD .GE. PROHIB) GOTO 2
        ! FOR ALL PRODUCTIONS OF THE REACHING SYMBOL OF 'STATEB'
        PRED = STAPRE(STATEB)
CXML
C       XML3 (RECEIV, STATEB, PROD, PRED)
        CALL XML3 ('RECEIV', 1, 6, STATEB,PROD,PRED)
3       IF(PRED .GE. PREHIB) GOTO 4
          STATEA = PRESTA(PRED)
          CALL ALONG(STATEA,PROMON(PROD),STATEZ,PRODZ)
          IF (PRODZ .NE. PROD)
     =      CALL ASSERT(24,PROD,PRODZ)
          IF (STATEZ .GT. 0)
     =      CALL APPLY(STATEB,STATEZ,PRODZ)
          ! ELSE
            ! 'LAGET' IS ISSUED WHEN REDUCTION IS INSERTED,'ITEINS'
          PRED = PRE(PRED)
        GOTO 3
4       CONTINUE ! ALL PREDECESSORS
        PROD = PRO(PROD)
      GOTO 1
2     CONTINUE ! ALL PRODUCTIONS
      RETURN! RECEIV
      END
