      SUBROUTINE ZZTX (LNG)
C     2022-02-07: no H format
C     WRITE 'LNG' BLANKS TO STREAM OUTPUT
C
      INCLUDE 'PARS.f'
      INCLUDE 'TARS.f'
      INTEGER*2 BLANKS(XXTARH)
     = ,LNG      ! SKIP IF NO MORE 'LNG' CHARACTERS FREE
      DATA BLANKS/XXTARH * '  '/
C
      CALL ZZTC(BLANKS,1,LNG,0)
99    RETURN
      END
