        SUBROUTINE SEMWRI (POS,CODE,SYMB)
C       WRITE A SINGLE ACTION TO 'SEM'
C       GF 11.07.1980
C
        INCLUDE 'PARS.f'
        INCLUDE 'SEMS.f'
        INTEGER*2 I
     = ,CODE    ! TO BE WRITTEN
     = ,POS     ! DESIRED PLACE (= 0 : FSEM, +=1)
     = ,SYMB    ! TO BE WRITTEN IN 'SEMSYM'
C
        I = POS
        IF (I .NE. 0) GOTO 1
          I = FSEM
          IF (FSEM .GE. SEMHIB) GOTO 2
            FSEM = FSEM + 1
          GOTO 3
2         CONTINUE
            CALL ASSERT(91,FSEM,0)
C             INCREASE 'SEMHIB'
3         CONTINUE
1       CONTINUE
        SEM   (I) = CODE
        SEMSYM(I) = SYMB
        RETURN ! SEMWRI
        END
