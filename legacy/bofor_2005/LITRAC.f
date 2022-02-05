      SUBROUTINE LITRAC(A,AHEAD,ATAIL,APPLY,NEGATE)
C     DO SOMETHING WITH ALL ELEMENTS OF A LIST  AND MARK THEM EVENTUAL
C
      INTEGER*2 J
     = ,A(1)     ! THE ARRAY FOR THE POINTERS OF THE LIST
     = ,AHEAD    ! -> FIRST ELEMENT
     = ,AHIB     ! HBOUND(A,1)
     = ,ATAIL    ! -> LAST ELEMENT
     = ,FA       ! -> THE 1ST FREE ELEMENT
     = ,ELEM     ! ->,CURRENT ELEMENT
     = ,NEGATE   ! = -1 : MARK THE ELEMENTS, = +1 : DO NOT MARK
     = ,REF      ! = 'A(ELEM)'
      EXTERNAL APPLY
C
      ELEM = AHEAD
      I = 128
12    IF(ELEM .EQ. ATAIL) GOTO 4
        I = I - 1
        IF (I .GT. 0) GOTO 6
          CALL ASSERT(33,AHEAD,ATAIL)
          GOTO 5
6       CONTINUE ! LOOP-CHECK
        CALL APPLY(ELEM)
        REF = A(ELEM)
        IF (REF .GE. 0) GOTO 7 ! ALREADY MARKED - MUST BE A WRONG LIST
          CALL ASSERT(25,ELEM,ATAIL)
          GOTO 5
7       CONTINUE ! WRONG LIST
        A(ELEM) = REF * NEGATE ! * (+/- 1)
        ELEM = REF
      GOTO 12
4     CONTINUE ! ALL ELEMENTS
      A(ATAIL) = A(ATAIL) * NEGATE
5     CONTINUE
      RETURN ! LITRAC
      END
