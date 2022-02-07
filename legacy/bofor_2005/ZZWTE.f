      PROGRAM ZZWTE
C     2022-02-07: no H format, english text
C     TEST OF 'ZZW' STREAM OUTPUT MODULES
C
      INCLUDE 'PARS.F'
      INTEGER*2 T1(4),T2(5)
      DATA T1/'1S','T ','LI','NE'/
      DATA T2/'IS',' W','RI','TT','EN'/
C
      CALL ZZWC(T1,1,8,0)
      CALL ZZWX(10)
      CALL ZZWC(T2,1,10,20)
      CALL ZZWS(0)
      CALL ZZWS(0)
      CALL ZZWC('5 digits with width 10:',1,23,24)
      CALL ZZWI(12345,10)
      CALL ZZWI(67,0)
      CALL ZZWI(-4567,8)
      CALL ZZWI(-4567,0)
      CALL ZZWS(0)
      STOP
      END
