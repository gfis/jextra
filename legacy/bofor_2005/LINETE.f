      PROGRAM LINETE
C     TEST LINEXT
C     2022-02-07, Georg Fischer: no UPRI output
C
      INCLUDE 'PARS.F'
      INTEGER*2 I
C
      CALL LINIT
      DO 1 I = 1,16
        CALL LINEXT
1     CONTINUE
      STOP
      END
