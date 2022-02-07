      SUBROUTINE LADEL(STATEB,STATEZ,PRODZ)
C     DELETE LOOK-AHEAD SYMBOLS OF 'PRODZ' IN 'STATEZ' AND PROPAGATE
C       THIS DELETION
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SETS.f'
      INCLUDE 'STAS.f'
      INTEGER*2 I
     = ,GOT     ! RESULT OF 'ITEMA1/2', =1 IF STATE WAS READ
     = ,I1       ! -> ITEM BEFORE ITEM 'I2'
     = ,I2       ! -> CURRENT ITEM
     = ,ITEMEX   ! FOR CALL OF 'ITEINS'
     = ,LESS     ! = 1 IF ('STATEZ' LOOSES SOME SYMBOLS
     = ,PRODZ    ! DELETE FROM THIS REDUCTION
     = ,POSIT ! BEHIND 'PRODZ'
     = ,STATEB   ! NOT USED
     = ,STATEZ   ! DELETE FROM THIS STATE
     = ,SYMEX    ! FOR CALL OF 'ITEINS'
C
      LESS = 0
      POSIT = PROMON(PRODZ) + PROLNG(PRODZ) ! BEHIND THE PRODUCTION
      CALL ITEMA2 (STATEZ,  I1,I2,GOT)
1     IF(I2 .GE. ITEHIB) GOTO 2
        IF (ITEPOS(I2) .NE. POSIT) GOTO 3
          LESS = I2
          CALL ITEFRE (  I1,I2)
3       CONTINUE ! DELETE-ITEM FOUND
        I1 = I2
        I2 = ITE(I1)!
      GOTO 1
2     CONTINUE ! ALL ITEMS
      CALL ITEMA9 (STATEZ,GOT)
      IF (LESS .LE. 0) GOTO 4
        CALL SEPUSH(STAMAR,STATEZ,LAGART,LAGARB)
4     CONTINUE ! 'STATEZ' LOST SOME LOOK-AHEAD SYMBOLS
      CALL ITEINS(STATEZ,POSIT,SYMEX,ITEMEX)
      RETURN! LADEL
      END
