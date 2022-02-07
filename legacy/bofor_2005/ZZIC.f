      SUBROUTINE ZZIC (SIN,  CTN,TP)
C     2022-02-07 implicit none
C     GF 10.10.2002 rewritten from PDP/11 assembler
C     THE INTEGER ASCII-VALUE CONTAINED IN SIN IS INSERTED IN
C     THE SUBSTRING CTN[TP:TP].
C
      IMPLICIT NONE
C
      INTEGER*2 SIN, TP
      CHARACTER*16 CTN
C
      CTN(TP:TP) = CHAR (SIN)
      RETURN
      END
