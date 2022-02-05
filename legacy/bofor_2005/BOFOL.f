      PROGRAM BOFOL
C     CLEAR REDUCE-ITEMS MAIN PROGRAM
C     GF 04.04.1981
C
      INTEGER*2 PARASK
      EXTERNAL SCANS
      INTEGER*2 I
     = ,WHAT    ! PARAMETER FOR 'PREPAR'
C
      CALL PARADD
      CALL DIRECT (5) ! OPEN
      CALL DIRECT (3) ! READ ALL
      CALL SPAINI
C-----------------------------------------------------
      CALL CLEARE
C-----------------------------------------------------
      CALL DIRECT (4) ! WRITE ALL
      CALL DIRECT (6) ! CLOSE
      STOP
      END
