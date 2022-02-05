      SUBROUTINE STAALL(STATE,SYMBOL)
C     ALLOCATE A NEW STATE
C     2005-03-29: demingle MEMSETS
C     GF 09.07.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'MEMS.F'
      INCLUDE 'PRES.F'
      INCLUDE 'PROS.F'
      INCLUDE 'SETS.F'
      INCLUDE 'STAS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 I
     = ,STATE    ! THE NUMBER OF THE ALLOCATED STATE
     = ,SYMBOL   ! 'STATE' IS REACHED,THIS SYMBOL
     = ,I1       ! -> ONE ELEMENT BEFORE 'I2'
     = ,I2       ! -> CURRENT ELEMENT IN 'STARST'-LIST
     = ,POS
C
      IF (FSTA .GE. STAHIB) GOTO 1
        STATE = FSTA
        FSTA = STAPRE(FSTA)!
        STAITE(STATE) = ITEHIB
        STAPRE(STATE) = PREHIB
        STAMAR(STATE) = 0
        STASYM(STATE) = SYMBOL
        STARST(STATE) = SYMRST(SYMBOL)
        SYMRST(SYMBOL) = STATE
      GOTO 2 ! NO OVERFLOW
1     CONTINUE
        CALL ASSERT(12,STATE,SYMBOL)
2     CONTINUE ! OVERFLOW
CXML
C     XML2 (STAALL, STATE, SYMBOL)
      CALL XML2 ('STAALL', 1, 6, STATE,SYMBOL)
      RETURN ! STAALL
C-----------------------------------------------------------------
      ENTRY STAFRE (STATE)
C     FREE A STATE, DELETE IT FROM ALL LISTS/SETS/QUEUES
C
      ! DELETE 'STATE' FROM 'STARST'-LIST
      SYMBOL = STASYM(STATE)
      STARST(1) = SYMRST(SYMBOL)
      I1 = 1
      I2 = STARST(I1)!
11    IF(I2 .GE. STAHIB) GOTO 12
        IF (I2 .NE. STATE) GOTO 3 ! 'STATE' IS FOUND
          STARST(I1) = STARST(I2)
          GOTO 100
3       CONTINUE ! 'STATE' FOUND
        I1 = I2
        I2 = STARST(I1)!
      GOTO 11
12    CONTINUE ! ALL IN 'STARST'-LIST
      ! 'STATE' WAS NOT FOUND HERE
      CALL ASSERT(27,STATE,SYMBOL)
C
100   CONTINUE ! DONE
      SYMRST(SYMBOL) = STARST(1)
C
      CALL LIFRE (ITE,FITE,STAITE(STATE),ITEHIB)
      CALL LIFRE (PRE,FPRE,STAPRE(STATE),PREHIB)
C
      ! DELETE REQUESTS FOR 'STASUC', 'LAGET', 'LAPUT', 'SPLIT'
      CALL SETDEL (STAMAR,STATE,STASUH,STASUT,STASUB)
      CALL SETDEL (STAMAR,STATE,LAGETH,LAGETT,LAGETB)
      CALL SETDEL (STAMAR,STATE,LAPUTH,LAPUTT,LAPUTB)
      CALL SETDEL (STAMAR,STATE,SPLITH,SPLITT,SPLITB)
C
      ! INSERT 'STATE' IN THE FREE LIST AND MARK IT "UNUSED"
      STAPRE(STATE) = FSTA
      FSTA = STATE
      STAITE(STATE) = 0
      RETURN! STAFRE
      END
