      SUBROUTINE TRACOP (ANCH,LAST)
C     APPEND A COPY OF A RING (<- 'LAST') TO 'ANCH'
C     GF 16.07.1980
C     GF 24.07.1980: WITH 'TRAPIM'
C
      INCLUDE 'PARS.F'
      INCLUDE 'TRAS.F'
      INTEGER*2 I
     = ,ACT      ! RESULT OF *TRALOC
     = ,ANCH     ! APPEND TO THIS RING
     = ,LAST     ! COPY THIS RING
     = ,TEMP    ! FOR EXCHANGING IN *TRAPEN
      INCLUDE 'ENDS.F'
C
      IF (LAST .EQ. TRAHIB) GOTO 1
        I = LAST
C
100     CONTINUE
        I = TRA(I)
        CALL TRAPIM (ANCH,TRASYM(I),TRAENT(I))
        IF (I .NE. LAST) GOTO 100
C
1     CONTINUE
      RETURN ! TRACOP
      END
