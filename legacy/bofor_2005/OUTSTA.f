        SUBROUTINE OUTSTA (STATE)
C       PRINT A STATE OF THE PARSING TABLE
C       GF 11.10.1980
C
        INCLUDE 'PARS.f'
        INCLUDE 'ITES.f'
        INCLUDE 'PRES.f'
        INCLUDE 'PROS.f'
        INCLUDE 'STAS.f'
        INCLUDE 'SYMS.f'
        INTEGER*2 PARASK
        INTEGER*2 I
     = ,GOT     ! RESULT OF 'ITEMA1/2', =1 IF STATE WAS READ
     = ,STATE   ! THE STATE TO BE PRINTED
     = ,SYM     ! 'STATE' IS REACHED BY 'SYM'
     = ,SYMB    ! FOR 'OUTSYM', SYMBOL TO BE PRINTED
     = ,SYMH    ! HIGH BOUND FOR LOOP ON SYMBOLS
     = ,SYML    ! LOW  BOUND ...
        EXTERNAL OUTITE,OUTPRE
        EXTERNAL OUTPRO,OUTNUM
C
        IF (STAITE(STATE) .EQ. 0) GOTO 1 ! 'STATE' IS NOT IN FREE LIST
          SYM = STASYM(STATE)
          WRITE(UPRI,2) STATE,STAMAR(STATE),STARST(STATE)
2           FORMAT(' **** STATE ',I4,', MAR: ',I5
     =        ,', RST: ',I4)
          CALL ZZWC ('                    SYM : ',1,25,0)
          CALL PUTSYM (SYM)
          IF (PARASK('PACKED',1,6,1) .NE. 0) GOTO 3
          CALL ZZWC (', PRE: ',1,7,0)
          CALL LITRAC (PRE,STAPRE(STATE),PREHIB,OUTPRE,1)
3         CONTINUE
          CALL ZZWS (0)
          CALL ITEMA1 (STATE,  I,GOT)
          CALL LITRAC (ITE,I,ITEHIB,OUTITE,1)
          CALL ITEMA8 (STATE,GOT)
1       CONTINUE
        RETURN ! OUTSTA
      END
