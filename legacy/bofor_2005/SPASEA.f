      SUBROUTINE SPASEA (STATE)
C     LOOK WHETHER 'STATE' IS YET AVAILABLE
C     GF 08.11.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'SPAS.F'
      INCLUDE 'STAS.F'
      INTEGER*2 I1,I2 ! -> SUCCESSIVE ELEMENTS IN 'SPAS'
     = ,STATE ! LOOK FOR THIS STATE
C
      IF (SPAHD .EQ. SPATL) RETURN
      I1 = SPAHD
      I2 = SPA(I1)
1     CONTINUE
        IF (SPASTA(I2) .NE. STATE) GOTO 3
C       STATE WAS FOUND - DELETE IT FROM 'SPAS'
        STAITE(STATE) = SPAIHD(I2)
        IF (I2 .NE. SPATL) GOTO 5
          SPATL = I1
        GOTO 6
5       CONTINUE
          SPA(I1) = SPA(I2)
          SPA(I2) = SPA(SPATL)
          SPA(SPATL) = I2
6       CONTINUE
        IF (SPATES .EQ. 1)
     =    WRITE (UPRI,7) I2,STATE,SPAIHD(I2),SPAITL(I2),SPAHD,SPATL
7         FORMAT(' FOUND: ',6I5)
        GOTO 99
3     CONTINUE
      IF (I2 .EQ. SPATL) GOTO 4
        I1 = I2
        I2 = SPA(I1)
      GOTO 1
4     CONTINUE
99    RETURN
      END
