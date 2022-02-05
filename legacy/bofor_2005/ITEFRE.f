      SUBROUTINE ITEFRE (  I1,I2)
C     FREE (DELETE) A SINGLE ITEM
C     GF 20.08.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INTEGER*2 I1,I2 ! DELETE 'I2'. 'I1,I2' MAY BE IDENTICAL
C
      ITE(I1) = ITE(I2)
      ITE(I2) = FITE
      FITE = I2
      I2 = I1
      RETURN
      END
