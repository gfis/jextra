      SUBROUTINE ZZTS (LNG)
C     CONDITIONALLY WRITE 'SKIP' TO STREAM OUTPUT
C     GF 26.07.1980
C     GF 08.11.1980: ONLY 6 BLANKS, AND 'LNG=-2' MEANS COMMENT
C
      INCLUDE 'PARS.F'
      INCLUDE 'TARS.F'
      INTEGER*2 I
     = ,BL2     ! 2 BLANKS
     = ,BLEQ    ! BLANK AND EQUAL-SIGN
     = ,CBL     ! 'C' AND BLANK
     = ,LEN     ! =1000 IF 'LNG=0'
     = ,LNG      ! SKIP IF NO MORE 'LNG' CHARACTERS FREE
      DATA BL2/'  '/,BLEQ/' ='/,CBL/'C '/
C
      LEN = LNG
      IF (LEN) 9,10,11
9     CONTINUE
      IF (LEN .NE. -2) GOTO 8
C       -2 = COMMENT STARTS
        TARBUF(1) = CBL
        FTAR = 3
        GOTO 99
8     CONTINUE
      LEN = FTAR / 2
      WRITE (UTAR,2) (TARBUF(I),I=1,LEN)
      FTAR = 1
        GOTO 99
10    LEN = 1000
11    IF (FTAR + LEN - 1 .LE. TARHIB) GOTO 99
      LEN = FTAR / 2
      WRITE (UTAR,2) (TARBUF(I),I=1,LEN)
2     FORMAT(40A2)
      TARBUF(1) = BL2
      TARBUF(2) = BL2
      TARBUF(3) = BLEQ
      FTAR = 7
99    CONTINUE
      RETURN
      END
