      PROGRAM LINETE
C     TEST 'LINEXT'
C
      INCLUDE 'PARS.F'
      INTEGER*2 I
C
      CALL LINIT
      WRITE(UPRI,2) ULIN
2     FORMAT(' ULIN=',I5)
      DO 1 I = 1,15
        CALL LINEXT
1     CONTINUE
      STOP
      END
