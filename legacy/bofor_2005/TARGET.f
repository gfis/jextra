      SUBROUTINE TARGET
C     WRITE THE RESULT OF THE TRANSLATION ON A FILE
C     GF 27.07.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'STKS.F'
      INCLUDE 'TRAS.F'
      INCLUDE 'TRES.F'
      EXTERNAL TREPUT
      INTEGER*2 I
     = ,ACT     ! -> 'TRA'
     = ,ANCH    ! AN ANCHOR FOR THE REST OF 'TRA'
C
C     STACK CONTENTS AFTER 'ACCEPT' IN 'PARSER'
C     1 = 0
C     2 = TRAHIB
C     3 -> EOSTMT
C     4...FSTK-2 -> REST OF 'TRA'
C
      ANCH = TRAHIB
      ACT = FSTK - 2
      DO 1 I = 4,ACT
        CALL TRAPEN (ANCH,STKTRA(I))
1     CONTINUE
      ACT = FTRE
      CALL TRADO (ANCH,TREPUT)
      CALL TRAPIM (ANCH,TGOTO,0)
      DO 2 I = 1,TREHIB
        CALL TREPUT (ANCH) ! PUSH OUT LAST BUFFER
2     CONTINUE
      CALL TREXPA (ACT)
      END