      PROGRAM ZZTTE
C     TEST 'ZZT'-MODULES
C     2022-02-07, Georg Fischer: no H format
C
      INCLUDE 'PARS.f'
      INTEGER*2 I
      INTEGER*2 T1(6),T2(6)
      DATA T1/'SO','ME',' F','OR','TR','AN'/
      DATA T2/' S','TA','TE','ME','NT','-'/
C
      CALL ZZTC ('      ',1,6,0)
      DO 1 I=1,4
        CALL ZZTC(T1,1,12,0)
        CALL ZZTX(10)
        CALL ZZTC(T2,1,11,20)
        CALL ZZTS(0)
1     CONTINUE

      CALL ZZTS(-1)
      CALL ZZTC ('      ',1,6,0)
      DO 2 I = 1,16
        CALL ZZTI(12345,10)
        CALL ZZTI(67,0)
2     CONTINUE
      CALL ZZTS(0)
      STOP
      END
