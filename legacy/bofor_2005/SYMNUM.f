      SUBROUTINE SYMNUM (ENTITY,NUM)
C     CONVERT A SYMBOL 'ENTITY' TO AN INTEGER 'NUM'
C     GF 12.07.1980
C     GF 19.07.1980  BOTH PARAMETERS MAY BE IDENTICAL
C
      INCLUDE 'PARS.F'
      INCLUDE 'STRS.F'
      INCLUDE 'SYMS.F'
      INCLUDE 'ENDS.F'
      INTEGER*2 I
     = ,DIGIT   ! THE CODE OF A DIGIT FROM THE SYMBOL
     = ,ENTITY  ! -> TO THE SYMBOL TO BE CONVERTED
     = ,NUM     ! THE RESULTING NUMBER
     = ,ZERO    ! THE CODE OF THE DIGIT '0'
     = ,S,E     ! START- AND END-POSITIONS IN 'ENTITY'
C
      IF (ENTITY .GT. 0) GOTO 2
        NUM = - ENTITY ! IT WAS A CODED NUMBER
        GOTO 99
2     CONTINUE
      S = SYMPOS(ENTITY)
      E = SYMEND(ENTITY)
      NUM = 0
      CALL ZZCI ('0',1,ZERO)
      DO 1 I = S,E
        CALL ZZCI (STRNG,I,DIGIT)
        NUM = NUM * 10 + DIGIT - ZERO
1     CONTINUE
99    CONTINUE
      RETURN
      END