C-------GF 28.08.1980------------------------------ I T E S
      INTEGER*2 FITE,ITEHIB,ACCEPT,REDUCE,SHIFT,ERROR
      INTEGER*2 ITE(XXITEH),ITESYM(XXITEH),ITEPOS(XXITEH)
      INTEGER*2 ITEACT,ITESUC(XXITEH)
      INTEGER*2 ITEPAG
      COMMON /ITES/
     =  FITE
     = ,ITEHIB
     = ,ACCEPT      ! PARSER ACTION, OCCURS ONLY ONCE IN STATE 3
     = ,REDUCE      !      <= 'SHIFT'
     = ,SHIFT      !      >= 'REDUCE'
     = ,ERROR      ! GENERATED BY 'DELTA'
     = ,ITE      ! -> NEXT ITEM IN A STATE
     = ,ITESYM      ! THE MARKED SYMBOL
     = ,ITEPOS      ! THE MARKER IS BEFORE THIS MEMBER
     = ,ITESUC  ! SHIFT: SUCCESSOR, REDUCE: PRODUCTION
     = ,ITEPAG  ! = 1 (0): DO (NOT) PAGE 'ITES'
