      PROGRAM ASSETE
C     TEST 'ASSERT' BY PRINTING ALL MESSAGES
C     2022-02-07: comments
C     2005-04-07, Georg Fischer
C
      INTEGER*2 I
C
      DO 10 I = 1, 200
        CALL ASSERT(I,I,I)
 10   CONTINUE
      END
