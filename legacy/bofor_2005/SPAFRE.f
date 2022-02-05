      SUBROUTINE SPAFRE
C     PUT A 'STATE' IN 'SPAS'-RING
C     GF 08.11.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'SPAS.F'
      INTEGER*2 I2 ! -> SUCCESSIVE ELEMENTS IN 'SPAS'
     = ,IHD     ! -> FIRST ITEM OF 'STATE'
     = ,ITL     ! -> LAST  ...
     = ,STATE ! LOOK FOR THIS STATE
C
2     CONTINUE
        IF (SPAHD .EQ. SPATL) GOTO 99
C       THROW THE OLDEST
        SPAHD = SPA(SPAHD)
        IHD = SPAIHD(SPAHD)
        ITL = SPAITL(SPAHD)
        IF (SPATES .EQ. 1)
     =    WRITE (5,7) SPAHD,SPASTA(SPAHD),IHD,ITL
7         FORMAT(' FREED: ',4I5)
      IF (IHD .EQ. ITEHIB) GOTO 2
      ITE(ITL) = FITE
      FITE = IHD
99    RETURN
      END
