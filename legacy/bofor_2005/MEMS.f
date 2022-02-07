C-------GF 28.08.1980-------------------------------- M E M S
      INTEGER*2 FMEM,MEMHIB
      INTEGER*2 EOP
      INTEGER*2 MEM(XXMEMH),MEMNUC(XXMEMH)
      COMMON /MEMS/
     =  FMEM      ! 1ST FREE MEMBER
     = ,MEMHIB
     = ,EOP      ! SYMBOL AT THE END OF A PRODUCTION
     = ,MEM      ! SYMBOL-NUMBER, =1: END OF PRODUCTION
      COMMON /MEMS/
     =  MEMNUC      ! ANCHOR FOR 'NUC'-LISTS
