      PROGRAM SEPUTE
C     TEST SEPUSH
C     2022-02-05: POT2 was in SETS.f
C     2005-03-27, Georg Fischer
C
      INCLUDE 'PARS.f'
      INCLUDE 'SETS.f'
      INCLUDE 'STAS.f'
      INTEGER*2 PARASK
     = ,I
     = ,I1       ! -> THE ELEMENT BEFORE 'I2'
     = ,I2       ! -> CURRENT ELEMENT
     = ,X        ! ELEMENT,BE AMRKED
     = ,XBIT     ! THE BIT THAT IS MARKED
     = ,XHEAD    ! -> BEGIN AND
     = ,XMAR(1)  ! ARRAY THAT CONTAINS THE MARKINGS
     = ,XTAIL    ! APPEND TO THIS SET
C
      CALL PARADD
      I1 = 17
      I2 = 18
      CALL SETINI
      PRINT *, 'STASUB=', STASUB, ', STASUH=', STASUH
      CALL SEPUSH(STAMAR,I1,STASUT,STASUB)
      CALL SEPUSH(STAMAR,I2,STASUT,STASUB)
      CALL SETPOP(STAMAR,X,STASUH,STASUB)
      PRINT *, 'SETPOP: ', X
      CALL SETPOP(STAMAR,X,STASUH,STASUB)
      PRINT *, 'SETPOP: ', X
      CALL SEPUSH(STAMAR,I1,STASUT,STASUB)
      CALL SEPUSH(STAMAR,I2,STASUT,STASUB)
      CALL SETSIN();
      CALL SETDEL(STAMAR,I1,STASUH,STASUT,STASUB)
      CALL SETPOP(STAMAR,X,STASUH,STASUB)
      PRINT *, 'SETPOP: ', X
      CALL SETPOP(STAMAR,X,STASUH,STASUB)
      PRINT *, 'SETPOP: ', X
      RETURN
      END
      