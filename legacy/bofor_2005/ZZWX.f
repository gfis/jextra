      SUBROUTINE ZZWX (LNG)
C     WRITE 'LNG' BLANKS TO STREAM OUTPUT
C
      INCLUDE 'PARS.F'
      INCLUDE 'PRIS.F'
      INTEGER*2 BLANKS(XXPRIH)
     = ,LNG      ! SKIP IF NO MORE 'LNG' CHARACTERS FREE
      DATA BLANKS/XXPRIH * 2H  /
C
      CALL ZZWC(BLANKS,1,LNG,0)
99    RETURN
      END