      SUBROUTINE CODINI(CODE)
C     INITIALIZE THE CODE-TABLE
C
      INCLUDE 'PARS.F'
      INCLUDE 'CODS.F'
      INTEGER*2 I
     = ,TABPOS
     = ,CODE
C
      CODHIB = XXCODH
      CODE = 1
      DO 1 I = 1,CODHIB
        CODTAB(I) = CODE ! CLEAR TABLE WITH CODE 'INVALID'
1     CONTINUE
      FCOD = CODE + 1
      RETURN ! CODINI
      END