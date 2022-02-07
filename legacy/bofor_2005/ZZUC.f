      SUBROUTINE ZZUC(CHARN,CHARS,CHARE,WIDTH)
C     WRITE CHARACTERS TO STREAM-OUTPUT
C
      INCLUDE 'PARS.f'
      INCLUDE 'PRIS.f'
      INTEGER*2 CHARS,CHARE,CHARN(1),WIDTH
      INTEGER*2 LNG
C
      LNG = WIDTH
      IF (LNG .EQ. 0)
     =    LNG = CHARE - CHARS + 1
      CALL ZZUS(LNG)
      CALL ZZCC(CHARN,CHARS,CHARE,PRIBUF,FPRI,FPRI + LNG)
      FPRI = FPRI + LNG
      RETURN
      END
C------------------------------------------------------------------
      SUBROUTINE ZZUS (LNG)
C     CONDITIONALLY WRITE 'SKIP' TO STREAM OUTPUT
C
      INCLUDE 'PARS.f'
      INCLUDE 'PRIS.f'
      INTEGER*2 I
     = ,LEN     ! =1000 IF 'LNG=0'
     = ,LNG      ! SKIP IF NO MORE 'LNG' CHARACTERS FREE
C
      LEN = LNG
      IF (LEN .EQ. 0) LEN = 1000
      IF (FPRI + LEN - 1 .LE. PRIHIB) GOTO 99
        LEN = FPRI / 2  ! WORDS
        WRITE (UPRI) (PRIBUF(I), I=1,LEN)
        FPRI = 2 ! POSITION 1 = CARRIAGE CONTROL
99    CONTINUE
      RETURN
      END
