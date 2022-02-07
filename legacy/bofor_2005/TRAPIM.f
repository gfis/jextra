      SUBROUTINE TRAPIM (ANCH,SYM,ENT)
C     APPEND ONE IMMEDIATE 'TRA'-ELEMENT TO 'ANCH'
C     GF 24.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'TRAS.f'
      INCLUDE 'ENDS.f'
      INTEGER*2 ACT
     = ,ANCH    ! APPEND TO THIS ANCHOR
     = ,ENT     ! THE NEW 'TRAENT'
     = ,SYM     ! THE NEW 'TRASYM'
C
      ACT = TRA(FTRA) ! GET A FREE ELEMENT
      IF (ACT .NE. FTRA) GOTO 1
        CALL ASSERT (129,TRAHIB,FTRA)
        CALL TRADUM (0)
1     CONTINUE
      TRA(FTRA) = TRA(ACT)
      TRASYM(ACT) = SYM
      TRAENT(ACT) = ENT
C
      IF (ANCH .EQ. TRAHIB) GOTO 2
        TRA(ACT) = TRA(ANCH)
        TRA(ANCH) = ACT
      GOTO 3
2     CONTINUE ! APPEND
        TRA(ACT) = ACT
3     CONTINUE
      ANCH = ACT
      RETURN
      END
