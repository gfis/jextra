      INTEGER*2 FUNCTION STASYM(STATE)
C     THE SYMBOL WHICH ACCESSES A STATE
C     REPLACES AN ARRAY SET BY 'STAALL'
C     GF 20.08.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'MEMS.f'
C     INCLUDE 'STAS.f'
      INTEGER*2 ITEM
     = ,GOT
     = ,POS     ! POSITION FOR THE TEST FOR NUCLEUS-ITEM
     = ,SYMB    ! THE SYMBOL BEFORE 'POS'
     = ,STATE   ! INDEX FOR 'STASYM'
C
      CALL ITEMA1 (STATE,  ITEM,GOT)
1     IF(ITE(ITEM) .EQ. ITEHIB) GOTO 2
        POS = ITEPOS(ITEM)
        SYMB = MEM(POS - 1)
        IF (SYMB .EQ. EOP) GOTO 3
          STASYM = SYMB
          GOTO 4
3       CONTINUE
        ITEM = ITE(ITEM)
      GOTO 1
2     CONTINUE
C     HERE WAS NO NUCLEUS-ITEM FOUND
      CALL ASSERT (140,STATE,0)
C       CANNOT COMPUTE STASYM(@)
      STASYM = ITESYM(ITEM)
C
4     CONTINUE
      CALL ITEMA8 (STATE,GOT)
      RETURN
      END
