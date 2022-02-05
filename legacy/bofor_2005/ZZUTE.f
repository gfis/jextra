      PROGRAM ZZUTE
      INTEGER*2 TEXT(5)
      INTEGER*2 I,J,K
      DATA TEXT /'AB','CD','EF','GH','IJ'/
C
      DO 1 I = 1 ,10
        CALL ZZUC (TEXT,1,I,0)
        CALL ZZUS (0)
1     CONTINUE
      STOP
      END
