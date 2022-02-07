      SUBROUTINE SPAALL (STATE,IHD,ITL)
C     PUT A 'STATE' IN 'SPAS'-RING
C     GF 08.11.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'SPAS.f'
      INTEGER*2 I2 ! -> SUCCESSIVE ELEMENTS IN 'SPAS'
     = ,IHD     ! -> FIRST ITEM OF 'STATE'
     = ,ITL     ! -> LAST  ...
     = ,STATE ! LOOK FOR THIS STATE
C
      I2 = SPA(SPATL)
      IF (I2 .NE. SPAHD) GOTO 1
        IF (SPAHD .EQ. SPATL) GOTO 99
        CALL SPAFRE
1     CONTINUE
C     THIS IS THE NEWEST
      SPASTA(I2) = STATE
      SPAIHD(I2) = IHD
      SPAITL(I2) = ITL
      SPATL = I2
      IF (SPATES .EQ. 1)
     =  WRITE (UPRI,7) I2,STATE,IHD,ITL
7     FORMAT(' ALLOC: ',4I5)
99    RETURN
      END
