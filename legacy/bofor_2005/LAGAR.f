      SUBROUTINE LAGAR
C     GARBAGE COLLECTION FOR LOOK-AHEAD SYMBOLS
C
      INCLUDE 'PARS.F'
      INCLUDE 'SETS.F'
      INCLUDE 'STAS.F'
      INTEGER*2 I
     = ,ELEM     ! -> A STATE IN THE 'LAGAR'-SET
     = ,STATEB   ! CURRENT STATE OF THE 'LAGAR'-SET
      EXTERNAL LADEL
C
      ELEM = LAGARH
1     IF(ELEM .EQ. LAGART) GOTO 2
        STATEB = SETELE(ELEM)
        CALL RECEIV(STATEB,LADEL)
        ELEM = SET(ELEM)
      GOTO 1
2     CONTINUE ! ALL IN SET
      CALL SETFRE(STAMAR,LAGARH,LAGART,LAGARB)
      RETURN! LAGAR
      END
