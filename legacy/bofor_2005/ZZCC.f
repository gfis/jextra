      SUBROUTINE ZZCC (CSN,SS,SE, CTN,TS,TE)
C     GF 10.10.2002 rewritten from PDP/11 assembler
      IMPLICIT COMPLEX (A-Z)
C     MOVE CHARACTERS
C
      INTEGER*2 SS,SE, TS,TE
      CHARACTER*16 CSN, CTN
      INTEGER*2 SI,TI
C
      SI = SS
      TI = TS
10    IF (SI .GT. SE .OR. TI .GT. TE) GOTO 20     
      CTN(TI:TI) = CSN(SI:SI)
      SI = SI + 1
      TI = TI + 1
      GOTO 10
20    CONTINUE
C     HERE THE COMMON LENGTH WAS MOVED
30    IF (TI .GT. TE) GOTO 40
      CTN(TI:TI) = ' '
      TI = TI + 1
      GOTO 30
40    CONTINUE
      RETURN
      END
