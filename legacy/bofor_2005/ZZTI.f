      SUBROUTINE ZZTI (INT,WIDTH)
C         WRITE AN INTEGER TO STREAM OUTPUT
C
      INCLUDE 'PARS.F'
      INCLUDE 'TARS.F'
      INTEGER*2 I
     = ,INT      ! THE NUMBER TO BE ENCODED
     = ,WIDTH      ! WRITE SO MUCH CHARACTERS
     = ,LNG      ! TO DETERMINE THE WIDTH IF 'WIDTH=0'
      CHARACTER*10 IBUF! ENCODE IN THIS ARRAY
      INTEGER*4 LNG4      ! TO DETERMINE 'LNG', <= 100000
      CHARACTER*2 IFORM
      INTEGER*2 I0
C
      LNG = WIDTH
      IF (LNG .NE. 0) GOTO 5
        LNG4 = 1
        DO 6 I = 1,5
          LNG4 = LNG4 * 10
          IF (ABS(INT) .GE. LNG4) GOTO 8
            LNG = I + 1 ! ALLOW FOR MINUS-SIGN
             GOTO 5
8         CONTINUE
6       CONTINUE
5     CONTINUE
C
      IFORM = 'I0'
      CALL ZZCI (IFORM,2, I0)
      I0 = I0 + LNG
      CALL ZZIC (I0,  IFORM,2)
      WRITE(IBUF,IFORM) INT
      CALL ZZTC (IBUF,1,LNG,0)
      RETURN
      END
