      SUBROUTINE ZZCI (CSN,SP,  TIN)
C     2022-02-07 implicit none
C     GF 10.10.2002 rewritten from PDP/11 assembler
C
      IMPLICIT NONE
C     use ICHAR intrinsic
C     THE ASCII-VALUE OF THE SUBSTRING CSN[SP:SP] IS RETURNED
C     IN TIN AS AN INTEGER.
C
      INTEGER*2 SP, TIN
      CHARACTER*16 CSN
C
      TIN = ICHAR (CSN(SP:SP))
      RETURN
      END
