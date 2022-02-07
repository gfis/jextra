      SUBROUTINE ZZTS (LNG)
C     CONDITIONALLY WRITE 'SKIP' TO STREAM OUTPUT
C     2022-02-07: ONLY 6 SPACES AT FORTRAN STATEMENT BEGIN, AND 'LNG=-2' MEANS COMMENT
C     GF 26.07.1980
C     GF 08.11.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'TARS.F'
      INTEGER*2 I
     = ,SP2     ! 2 SPACES
     = ,SPEQ    ! SPACE AND EQUAL-SIGN
     = ,CSP     ! 'C' AND SPACE
     = ,LEN     ! =1000 IF 'LNG=0'
     = ,LNG     ! SKIP IF NO MORE 'LNG' CHARACTERS FREE
      DATA SP2/'  '/,SPEQ/' ='/,CSP/'C '/
C
      LEN = LNG
      IF (LEN) 9,10,11
9     CONTINUE    ! LEN < 0
      IF (LEN .NE. -2) GOTO 8
C       -2 = COMMENT STARTS
        TARBUF(1) = CSP
        FTAR = 3
        GOTO 99
8     CONTINUE    ! LEN = -1
        LEN = FTAR / 2
        WRITE (UTAR,2) (TARBUF(I),I=1,LEN)
        FTAR = 1
        GOTO 99
10    CONTINUE    ! LEN = 0
        LEN = 1000
11    CONTINUE    ! LEN > 0
        IF (FTAR + LEN - 1 .LE. TARHIB) GOTO 99
        LEN = FTAR / 2
        WRITE (UTAR,2) (TARBUF(I),I=1,LEN)
2       FORMAT(40A2)
        TARBUF(1) = SP2
        TARBUF(2) = SP2
        TARBUF(3) = SPEQ
        FTAR = 7
99    CONTINUE
      RETURN
      END
