      PROGRAM ZZTTE
C     TEST 'ZZT'-MODULES
C
      INCLUDE 'PARS.F'
      INTEGER*2 I,J,K
      INTEGER*2 T1(4),T2(6)
      DATA T1/2H1.,2H Z,2HEI,2HLE/
      DATA T2/2H K,2HOM,2HMT,2H ',2HRA,2HUS/
C
      DO 1 I=1,20
        CALL ZZTC(T1,1,8,0)
        CALL ZZTX(10)
        CALL ZZTC(T2,1,11,20)
        CALL ZZTS(0)
1     CONTINUE
        CALL ZZTS(-1)
      DO 2 I = 1,30
        CALL ZZTI(12345,10)
        CALL ZZTI(67,0)
2     CONTINUE
        CALL ZZTS(0)
      STOP
      END
