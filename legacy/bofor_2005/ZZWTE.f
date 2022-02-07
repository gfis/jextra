      PROGRAM ZZWTE
C     2022-02-07: no H format, english text
C     TEST OF 'ZZW' STREAM OUTPUT MODULES
C
      INCLUDE 'PARS.F'
      INCLUDE 'PRIS.F'
      INTEGER*2 T1(5),T2(5)
      DATA T1/'FI','RS','T ','LI','NE'/
      DATA T2/'IS',' W','RI','TT','EN'/
C
      FPRI = 2 ! POSITION 1 = CARRIAGE CONTROL
      CALL ZZWC(T1,1,10,0)
      CALL ZZWX(2)
      CALL ZZWC(T2,1,10,11)
      CALL ZZWC('!',1,1,1)
70    FORMAT (' step ', I2)

      WRITE (6,70) 1
      CALL ZZWS(0)

      WRITE (6,70) 2
      CALL ZZWS(0)

      WRITE (6,70) 3
      CALL ZZWC('5 digits with width 10:',1,23,24)

      WRITE (6,70) 4
      CALL ZZWI(12345,10)

      WRITE (6,70) 5
      CALL ZZWI(67,0)

      WRITE (6,70) 6
      CALL ZZWI(-4567,8)

      WRITE (6,70) 7
      CALL ZZWI(-4567,0)

      WRITE (6,70) 8
      CALL ZZWS(0)

      STOP
      END
