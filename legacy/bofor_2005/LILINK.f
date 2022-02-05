      SUBROUTINE LILINK(AHIB,A,FA)
C     SET HIGH-BOUND, FREE-POINTER AND LINK ALL ELEMENTS
C
      INTEGER*2 I
     = ,A(1)     ! THE ARRAY FOR THE POINTERS OF THE LIST
     = ,AHEAD    ! -> FIRST ELEMENT
     = ,AHIB     ! HBOUND(A,1)
     = ,ATAIL    ! -> LAST ELEMENT
     = ,FA       ! -> THE 1ST FREE ELEMENT
      A(AHIB) = AHIB
      FA = 2
      A(1) = 0
      DO 1 I = FA,AHIB
        A(I) = I + 1
1     CONTINUE
      A(AHIB) = AHIB
      RETURN ! LILINK
      END
