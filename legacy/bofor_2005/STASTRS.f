C-------GF 28.08.1980------------------------------- S T A S T R S
      INTEGER*2 FSTR,STRHIB,STRNG(XXSTRH)
      COMMON /STRS/
     =  FSTR      ! 1ST FREE POSITION IN 'STRNG'
     = ,STRHIB
      EQUIVALENCE (STAPRE(1),STRNG(1))
