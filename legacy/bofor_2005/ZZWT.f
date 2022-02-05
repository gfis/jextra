      SUBROUTINE ZZWT (POS)
C     TABULATE TO POSITION 'POS' IN STREAM-OUTPUT
C     GF 16.07.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'PRIS.F'
      INTEGER*2 POS
C
      IF (FPRI .LE. POS) GOTO 1
        CALL ZZWS(0)
1     CONTINUE
      IF (FPRI .EQ. POS) GOTO 2
        CALL ZZWX (POS - FPRI)
2     CONTINUE
      RETURN
      END