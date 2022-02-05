      SUBROUTINE ZZWS (LNG)
C     CONDITIONALLY WRITE 'SKIP' TO STREAM OUTPUT
C
      INCLUDE 'PARS.F'
      INCLUDE 'PRIS.F'
      INTEGER*2 I
     = ,LEN     ! =1000 IF 'LNG=0'
     = ,LNG      ! SKIP IF NO MORE 'LNG' CHARACTERS FREE
C
      LEN = LNG
      IF (LEN .EQ. 0) LEN = 1000
      IF (FPRI + LEN - 1 .LE. PRIHIB) GOTO 99
        LEN = FPRI / 2  ! WORDS
        WRITE (UPRI,2) (PRIBUF(I), I=1,LEN)
2         FORMAT(61A2)
        FPRI = 2 ! POSITION 1 = CARRIAGE CONTROL
99    CONTINUE
      RETURN
      END