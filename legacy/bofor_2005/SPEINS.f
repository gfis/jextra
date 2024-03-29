      SUBROUTINE SPEINS (CHARN,CHARS,CHARE,  SYMBOL)
C     INSERT AN ELEMENT IN THE LIST OF SPECIAL CHARACTERS
C     GF 19.07.1980: 'FSYM > SYMHIB' DISABLES INSERTION
C
      INCLUDE 'PARS.f'
      INCLUDE 'STRS.f'
      INCLUDE 'SYMS.f'
      INTEGER*2 ZZCR
      INTEGER*2 I
     = ,CHARS,CHARE,CHARN(1) ! INSERT THIS STRING
     = ,I1      ! INSERT AFTER THIS SYMBOL
     = ,I2      ! INSERT BEFORE ...
     = ,POS     ! MOVE 'CHARN' HERE
     = ,POE
     = ,LNG     ! LENGTH OF STRING
     = ,SYMBOL  ! RESULT FOR CODE ASSIGNING
C
      POS = FSTR
      LNG = CHARE - CHARS + 1
      POE = POS + LNG - 1
      IF (FSTR + LNG .GE. STRHIB) GOTO 13
        FSTR = FSTR + LNG
        CALL ZZCC (CHARN,CHARS,CHARE,STRNG,POS,POE)
      GOTO 14 ! NO 'STR'-OVERFLOW
13    CONTINUE
        CALL ASSERT(28,FSTR,STRHIB)
        GOTO 101 ! DONINS
14    CONTINUE ! OVERFLOW
C
      I1 = SPEH ! THERE IS A MINIMAL ELEMENT, 'SPEH' ->
      I2 = SYMLNK(I1)
CCC   PRINT *, 'SPEINS14:', POS, POE, I1, I2, SYMPOS(I2), SYMEND(I2)
15    IF(I1 .GE. SYMHIB) GOTO 16
CCC     PRINT *, 'SPEINS15:', POS, POE, I1, I2, SYMPOS(I2), SYMEND(I2)
        IF (ZZCR (STRNG,POS,POE
     =           ,STRNG,SYMPOS(I2),SYMEND(I2)) .GE. 0)
     =  GOTO 17
          IF (FSYM .GE. SYMHIB) GOTO 19
            SYMBOL = FSYM
            FSYM = FSYM + 1!
            SYMPOS(FSYM) = FSTR
            SYMLNK(SYMBOL) = I2
            SYMLNK(I1) = SYMBOL
            SYMPOS(SYMBOL) = POS
CEND        SYMEND(SYMBOL) = POE
          GOTO 20 ! NO 'SYM'-OVERFLOW
19        CONTINUE
            IF (FSYM .NE. SYMHIB) GOTO 22
C             USUAL OVERFLOW OF 'SYMS'
              CALL ASSERT (8,SYMHIB,0)
            GOTO 23
22          CONTINUE
C             SPECIAL CASE WHEN CALLED BY 'SEMANT'
C             DO NOT INSERT IF NOT FOUND
              SYMBOL = 0 ! INDICATES "NOT FOUND"
23          CONTINUE
20        CONTINUE
          GOTO 101 !DONINS
17      CONTINUE
CCC     PRINT *, 'SPEINS17:', POS, POE, I1, I2, SYMPOS(I2), SYMEND(I2)
        IF (ZZCR (STRNG,POS,POE
     =           ,STRNG,SYMPOS(I2),SYMEND(I2)) .NE. 0)
     =  GOTO 21
          SYMBOL = I2
          FSTR = POS ! DELETE THE TAIL OF 'STRNG'
          GOTO 101 ! DONINS
21      CONTINUE ! =
18      CONTINUE
CCC     PRINT *, 'SPEINS18:', POS, POE, I1, I2, SYMPOS(I2), SYMEND(I2)
        ! CONTINUE.LE. : TRY NEXT ELEMENT OF THE LIST
        I1 = I2
        I2 = SYMLNK(I1)!
      GOTO 15
16    CONTINUE ! WHILE .GE. SYMHIB
C
101   CONTINUE !       DONINS:
      ! NO RESTORING OF 'SYMLNK(1)' BECAUSE 'SPEH' -> MINIMAL ELEMENT
      ! 'CODTAB' IS ALREADY INITIALIZED WITH 'SPEC'
      IF (FSYM .LE. SYMHIB) GOTO 24
C       REPAIR THE SPECIAL CALL BY 'SEMANT'
        FSYM = FSYM - SYMHIB
        FSTR = POS ! 'SYMBOL' IS NOT INSERTED
24    CONTINUE
      RETURN ! SPEINS
      END
