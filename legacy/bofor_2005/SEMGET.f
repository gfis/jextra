      SUBROUTINE SEMGET (ROOT,POS,  SYMB)
C     GET A MEMBER OF THE PARSED PRODUCTION
C     GF 16.07.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'STKS.F'
      INCLUDE 'SYMS.F'
      INCLUDE 'TRAS.F'
      INTEGER*2 I
     = ,ROOT    ! -> 1ST MEMBER OF THE PARSED PRODUCTION
     = ,POS     ! NUMBER OF THE DESIRED MEMBER, 1,2,...
     = ,SYMB    ! RESULTING ENTITY
C
C     POS = +-1, +-2, ...
C     IF 'POS < 0', THE MEMBER IS ALREADY CONVERTED TO AN INTEGER
C
      I = ROOT + ABS(POS) - 1
      I = STKTRA(I)
      IF (TRASYM(I) .LT. TIDEN .OR. TRASYM(I) .GT. TSTRI) GOTO 1
C       HERE IT IS AN ENTITY (IDENTIFIER, NUMBER OR STRING)
        SYMB = TRAENT(I)
      GOTO 2
1     CONTINUE
        CALL ASSERT (97,POS,0)
        SYMB = ERRSYM
2     CONTINUE
      IF (ABS(POS) .EQ. POS) GOTO 3
        CALL SYMNUM (SYMB,SYMB) ! CONVERT DIGIT-SEQUENCE TO INTEGER
3     CONTINUE
      RETURN ! SEMGET
      END
