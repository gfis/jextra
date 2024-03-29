      INTEGER*2 FUNCTION ITEACT (ITEM)
C     REPLACES AN ARRAY
C     GF 29.08.1980
C
      INCLUDE 'PARS.f'
        INTEGER*2 FITE,ITEHIB,ACCEPT,REDUCE,SHIFT,ERROR
        INTEGER*2 ITE(XXITEH),ITESYM(XXITEH),ITEPOS(XXITEH)
        INTEGER*2 ITESUC(XXITEH)
        COMMON /ITES/
     =  FITE
     = ,ITEHIB
     = ,ACCEPT  ! PARSER ACTION, OCCURS ONLY ONCE IN STATE 3
     = ,REDUCE  !       <= 'SHIFT'
     = ,SHIFT   !       >= 'REDUCE'
     = ,ERROR   ! GENERATED BY 'DELTA'
     = ,ITE     ! -> NEXT ITEM IN A STATE
     = ,ITESYM  ! THE MARKED SYMBOL
     = ,ITEPOS  ! THE MARKER IS BEFORE THIS MEMBER
     = ,ITESUC  ! SHIFT: SUCCESSOR, REDUCE: PRODUCTION
      INCLUDE 'MEMS.f'
      INCLUDE 'SYMS.f'
      INTEGER*2 ITEM
     = ,POS     ! -> 'MEM'
C
      IF (ITEM .NE. ITEHIB) GOTO 1
        ITEACT = ERROR
        GOTO 99
1     CONTINUE
      POS = ITEPOS(ITEM)
      IF (MEM(POS) .NE. EOP) GOTO 2
        ITEACT = REDUCE
        GOTO 99
2     CONTINUE
      IF (MEM(POS) .NE. EOFILE) GOTO 3
        ITEACT = ACCEPT
        GOTO 99
3     CONTINUE
        ITEACT = SHIFT
99    CONTINUE
      RETURN
      END
