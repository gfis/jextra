      INTEGER FUNCTION ZZCR (CSN,SS,SE, CTN,TS,TE)
C     2022-02-07: implicit none
C     GF 10.10.2002 rewritten from PDP/11 assembler
C     COMPARE CHARACTERS:
C     RETURN -1 IF CSN < CTN
C             0        =
C             1        >
C
      IMPLICIT NONE
      INTEGER*2 SS,SE, TS,TE
      CHARACTER*16 CSN, CTN
      INTEGER*2 SI,TI
C
      SI = SS
      TI = TS
10    CONTINUE
      IF (SI .GT. SE .OR. TI .GT. TE) GOTO 20
      IF (CSN(SI:SI) .LT. CTN(TI:TI)) GOTO 40
      IF (CSN(SI:SI) .GT. CTN(TI:TI)) GOTO 60
      SI = SI + 1
      TI = TI + 1
      GOTO 10
C     LOOP EXIT
20    CONTINUE
C     HERE THE COMMON SUBSTRING WAS EQUAL
      IF (SI .LE. SE) GOTO 60
      IF (TI .LE. TE) GOTO 40
C
30    CONTINUE
C     BOTH WERE EQUAL (MAYBE ZERO LENGTH)
      ZZCR = 0
      RETURN
40    CONTINUE
C     CSN WAS LESS
      ZZCR = -1
      RETURN
60    CONTINUE
C     CSN WAS GREATER
      ZZCR = 1
      RETURN
      END
