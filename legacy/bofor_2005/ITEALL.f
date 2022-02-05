      SUBROUTINE ITEALL (SYMBOL,POSIT,ACTION,SUCPRO,  I1,I2)
C     ALLOCATE AN ITEM
C     GF 20.08.1980
C     GF 28.12.1980: WITH 'SPAFRE'
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'SPAS.F'
      INTEGER*2
     =  ACTION  ! SET THIS ACTION IN 'ITEACT'
     = ,I1      ! -> BEFORE THE NEW ITEM
     = ,I2      ! INSERT BETWEEN 'I1' AND 'I2'
     = ,ITEM    ! -> THE NEW ITEM
     = ,POSIT   ! = 'ITEPOS'
     = ,SUCPRO  ! = 'ITESUC'
     = ,SYMBOL  ! = 'ITESYM'
C
      IF (FITE .LT. ITEHIB) GOTO 14
        IF (SPATES .LT. 0) GOTO 52
          CALL SPAFRE
        IF (FITE .LT. ITEHIB) GOTO 14
52        CONTINUE
          CALL ASSERT (21,ITEHIB,0)
          RETURN
14    CONTINUE
        ITEM = FITE
        FITE = ITE(ITEM)
        ITESYM(ITEM) = SYMBOL
        ITEPOS(ITEM) = POSIT
C       ITEACT(ITEM) = ACTION
        ITESUC(ITEM) = SUCPRO
        ITE   (ITEM) = I2
        I2 = ITEM
        ITE(I1) = I2
      RETURN
      END
