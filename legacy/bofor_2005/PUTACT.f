        SUBROUTINE PUTACT (ITEM)
C       PRINT THE ACTION OF AN ITEM
C       GF 11.07.1980
C
        INCLUDE 'PARS.F'
        INCLUDE 'ITES.F'
        INCLUDE 'PROS.F'
        INTEGER*2
     =  ACT     ! THE ACTION OF THE PARSER
     = ,ITEM    ! THE ITEM THE ACTION OF WHICH IS TO BE PRINTED
     = ,PROD    ! THE PRODUCTION FOR 'ACT = REDUCE'
     = ,MNEMO(4) ! THE MNEMONICS FOR THE ACTIONS
        DATA MNEMO/'->', '=:', '=.', '??'/
C
        ACT = ITEACT(ITEM)
        CALL ZZWC (MNEMO(ACT),1,2,3)
        PROD = ITESUC (ITEM)
        CALL ZZWI (PROD,0)
        IF (ACT .NE. REDUCE) GOTO 2
          CALL ZZWC (': ',1,2,0)
          CALL OUTMAP (PROD,0)
2       CONTINUE
        RETURN ! PUTACT
        END
