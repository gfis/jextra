      SUBROUTINE ZZWI (INT,WIDTH)
C         WRITE AN INTEGER TO STREAM OUTPUT
C
      INCLUDE 'PARS.F'
      INCLUDE 'PRIS.F'
      INTEGER*2 IBHIB
      PARAMETER (IBHIB=10)
      INTEGER*2 I
     = ,INT      ! THE NUMBER TO BE ENCODED
     = ,WIDTH      ! WRITE SO MUCH CHARACTERS
     = ,LNG      ! TO DETERMINE THE WIDTH IF 'WIDTH=0'
     = ,IBPOS    ! IN IBUF
     = ,INTA     ! ABS(INT)
     = ,DIGIT    ! CURRENT DIGIT FROM INTA
     = ,NULL     ! VALUE OF '0'
     = ,ZZT      ! WHETHER TO CALL ZZWC OR ZZTC
     = ,TEMP
      CHARACTER*10 IBUF   ! ENCODE IN THIS ARRAY
      INTEGER*4 LNG4      ! TO DETERMINE 'LNG', <= 100000
      ZZT = 0
      GOTO 1
C
      ENTRY      ZZTI (INT,WIDTH)
      ZZT = 1
1     CONTINUE
      WRITE(IBUF,44) INT
44    FORMAT(I10)
      IBPOS = 10 - WIDTH
      IF (WIDTH .GT. 0) GOTO 40
7       CONTINUE
          IF (IBUF(IBPOS:IBPOS) .EQ. ' ' .OR. IBPOS .LE. 1) GOTO 40
          IBPOS = IBPOS - 1
        GOTO 7
8     CONTINUE
      GOTO 40
      IBPOS = IBHIB
      INTA = ABS(INT)
      CALL ZZCI ('0',1,  NULL)
9     CONTINUE
      IF (INTA .EQ. 0 .OR. IBPOS .LE. 1) GOTO 10
C       EXTRACT DIGITS FROM THE END
        DIGIT = MOD(INTA,10) + NULL
        CALL ZZIC (DIGIT,  IBUF,IBPOS)
        IBPOS = IBPOS - 1
        INTA = INTA / 10
        GOTO 9
10    CONTINUE
      IF (IBPOS .LT. IBHIB) GOTO 20
C       ONLY 0
        TEMP = 0
        CALL ZZIC (TEMP, IBUF,IBPOS)
        IBPOS = IBPOS - 1
20    CONTINUE
      IF (INT .EQ. ABS(INT)) GOTO 30
C       INSERT THE SIGN
        CALL ZZCC ('-',1,1, IBUF,IBPOS,IBPOS)
        IBPOS = IBPOS - 1
30    CONTINUE
      IF (WIDTH .LE. 0) GOTO 40
31      CONTINUE
        IF (IBHIB - IBPOS .GE. WIDTH .OR. IBPOS .LT. 1) GOTO 40
C         PAD WITH LEADING SPACES
          CALL ZZCC (' ',1,1,  IBUF,IBPOS,IBPOS)
          IBPOS = IBPOS - 1
        GOTO 31
40    CONTINUE
      IF (ZZT .EQ. 1) GOTO 98
        CALL ZZWC (IBUF,IBPOS+1,IBHIB,0)
        RETURN
98    CONTINUE
        CALL ZZTC (IBUF,IBPOS+1,IBHIB,0)
        RETURN
      END
