      PROGRAM ASSLOA
C     LOAD 'ASSERT'-TEXTS ON A DIRECT-FILE
C     2022-02-05: OPEN statements for gfortran; XXASSH had no type
C     GF 07.08.1980
C
      INCLUDE   'PARS.F'
      INTEGER*2 XXASSH
      PARAMETER XXASSH=40
      INTEGER*2 ZZCR
      INTEGER*4 OFFS4
      INTEGER*2 I,J
      INTEGER*2 CODE
      INTEGER*2 RECLEN
     = ,NUM     ! WRITE THE TEXT TO THIS RECORD OF 'UASS'
     = ,MAXNUM  ! HIGHEST POSSIBLE RECORD-NUMBER
     = ,LINE(XXASSH) ! BUFFER FOR THE TEXTS
      CHARACTER*3 NUM3
      DATA LINE/40*'  '/
      DATA MAXNUM /200/
      RECLEN = XXASSH * 2;
C
      CALL PARADD
      OPEN (UNIT=ULIN,file='ASSERT.f',status='OLD')
      OPEN (UNIT=UASS,file='ASSTEX.DIR'
     = ,STATUS='REPLACE',ACCESS='DIRECT',RECL=RECLEN)
      CALL ZZCC(' UNDEF : @,@',1,12,  LINE,1,RECLEN)
      WRITE (UPRI,7) (LINE(J),J=1,XXASSH)
7     FORMAT (1X,40A2)
      NUM = 1
      DO 1 I = 1,MAXNUM
        OFFS4 = (I - 1) * (RECLEN + 4)
C        CALL FSEEK (UASS, OFFS4, 0)
        WRITE (UASS,rec=I) (LINE(J),J=1,XXASSH)
1     CONTINUE
C
2     CONTINUE
        READ (ULIN,3,END=5) CODE, NUM3, (LINE(J),J=1,XXASSH)
3       FORMAT (A2, A3, 1X, 40A2)
        IF (ZZCR (CODE,1,2, 'C=',1,2) .NE. 0) GOTO 2
          READ (NUM3, '(I3)') NUM
          WRITE (UASS,rec=NUM) (LINE(J),J=1,XXASSH)
        GOTO 2
5     CONTINUE
      CLOSE (UNIT=UASS)
      WRITE (UPRI,9)
9     FORMAT (' ASSLOA END')
C
      DO 8 I = 1,MAXNUM
        CALL ASSERT (I,I,I)
8     CONTINUE
      STOP
      END
