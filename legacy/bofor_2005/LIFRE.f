      SUBROUTINE LIFRE(A,FA,AHEAD,ATAIL)
C     PREFIX THE FREE LIST WITH A LIST
C
      INTEGER*2 I
     = ,A(1)     ! THE ARRAY FOR THE POINTERS OF THE LIST
     = ,AHEAD    ! -> FIRST ELEMENT
     = ,AHIB     ! HBOUND(A,1)
     = ,ATAIL    ! -> LAST ELEMENT
     = ,FA       ! -> THE 1ST FREE ELEMENT
     = ,I1       ! -> THE ELEMENT BEFORE 'I2'
     = ,I2       ! -> CURRENT ELEMENT
C
      IF (AHEAD .EQ. ATAIL) GOTO 3
        A(1) = AHEAD
        I1 = 1
        I2 = A(I1)
11      IF(I2 .EQ. ATAIL) GOTO 2
            I1 = I2
            I2 = A(I1)
        GOTO 11
2       CONTINUE ! ALL ELEMENTS
        ! NOW PREFIX THE FREE LIST WITH 'A(AHEAD : I1)'
        A(I1) = FA
        FA = AHEAD
        AHEAD = ATAIL
3     CONTINUE ! AHEAD .EQ. ATAIL
      RETURN ! LIFRE
      END
