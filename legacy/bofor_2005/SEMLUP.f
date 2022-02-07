        SUBROUTINE SEMLUP (PROD,SYMB,INC,  SON)
C       LOOK-UP A MEMBER IN THE RIGTH SIDE OF 'PROD'
C
        INCLUDE 'PARS.f'
        INCLUDE 'MEMS.f'
        INCLUDE 'PROS.f'
        INCLUDE 'SEMS.f'
        INTEGER*2 I
     = ,INC     ! DESIRED OCCURRENCE OF 'SYMB'
     = ,OCCUR   ! CURRENT ...
     = ,PROD    ! LOOK IN THIS PRODUCTION
     = ,SON     ! = 1...PROLNG IF FOUND, 0 OTHERWISE
     = ,SYMB    ! LOOK FOR THIS SYMBOL
C
      SON = 0
      OCCUR = 0
      I = PROMON(PROD)
1     IF(I .GT. PROMON(PROD) + PROLNG(PROD) - 1) GOTO 2
        IF (MEM(I) .NE. SYMB) GOTO 3
          OCCUR = OCCUR + 1
          IF (OCCUR .LT. INC) GOTO 4 ! WORKS ALSO FOR 'INC <= 0'
            SON = I - PROMON(PROD) + 1
C           MEMNUC(I) = - ABS(MEMNUC(I)) ! WAS USED
            CALL SEMWRI(0,SOCO,SON)
            RETURN
4         CONTINUE
3       CONTINUE
        I = I + 1
      GOTO 1
2     CONTINUE
C     NOT FOUND, MUST BE ACCU ('INC=0') OR NEW TERMINAL ('INC<0')
      IF (INC .LT. 0) GOTO 5
        CALL SEMWRI(0,ACCO,SYMB)
        CALL SEMWRI(0,ACCU,INC)
      GOTO 6
5     CONTINUE
        CALL SEMWRI(0,SYCO,SYMB)
6     CONTINUE
      RETURN ! SEMLUP
      END
