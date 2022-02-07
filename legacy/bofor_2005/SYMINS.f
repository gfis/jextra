      SUBROUTINE SYMINS (CHANGE)
C     INSERT ALL (NEW) PRODUCTIONS OF A SYMBOL IN THE TABLE
C     GF 09.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'PRES.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SETS.f'
      INCLUDE 'STAS.f'
      INCLUDE 'SYMS.f'
      INTEGER*2 I
     = ,CHANGE   ! = 1 AS LONG AS THE PARSER CHANGED
     = ,I1       ! -> THE ELEMENT BEFORE THE ONE,BE DELETED
     = ,I2       ! -> THE ELEMENT,BE DELETED
     = ,ITEMEX   ! FOR CALL 'ITEINS', NOT USED
     = ,LEFT     ! INSERT PRODUCTIONS OF THIS SYMBOL
     = ,PRED     ! PREDECESSORS OF 'STATEB'
     = ,PROD     ! PRODUCTIONS OF 'LEFT'
     = ,STATEA   ! ALL STATES THAT SHIFT 'LEFT'
     = ,STATEB   ! ALL STATES THAT ARE REACHED,'LEFT
     = ,SYMEX    ! .LE.0 IF (A SYMBOL WAS NOT YET IN 'STATEA'
C
      SET(1) = SYMINH
      I1 = 1
      I2 = SET(I1)!
1     IF(I2 .EQ. SYMINT) GOTO 2
        LEFT = SETELE(I2)
        STATEB = SYMRST(LEFT)
        IF (STATEB .GE. STAHIB) GOTO 3 ! 'LEFT' REACHES SOME STATES
          ! DELETE 'LEFT' FROM THE QUEUE
          CHANGE = 1
          SET(I1) = SET(I2)
          SET(I2) = FSET
          FSET = I2!
          I2 = I1
          SYMMAR(LEFT) = SYMMAR(LEFT) - SYMINB
4         IF(STATEB .GE. STAHIB) GOTO 5
            PRED = STAPRE(STATEB)
6           IF(PRED .GE. PREHIB) GOTO 7
              STATEA = PRESTA(PRED)
              PROD = SYMPRO(LEFT)
8             IF(PROD .GE. PROHIB) GOTO 9
                CALL ITEINS(STATEA,PROMON(PROD),SYMEX,ITEMEX)
                IF (SYMEX .LE. 1) GOTO 10
                  ! STACLH = STACLT
                  CALL SEPUSH(SYMMAR,SYMEX,STACLT,STACLB)
10              CONTINUE ! SYMBOL DID NOT EXIST
                PROD = PRO(PROD)
              GOTO 8
9             CONTINUE ! ALL PRODUCTIONS
              CALL STACLO(STATEA)
              PRED = PRE(PRED)
            GOTO 6
7           CONTINUE ! ALL PREDECESSORS
            STATEB = STARST(STATEB)
          GOTO 4
5         CONTINUE ! ALL STATES REACHED,'LEFT'
3       CONTINUE ! 'LEFT' REACHES SOME STATES
        I1 = I2
        I2 = SET(I1)
      GOTO 1
2     CONTINUE ! ALL 'LEFT' IN 'SYMINS'-QUEUE
      SYMINH = SET(1)
      RETURN! SYMINS
      END
