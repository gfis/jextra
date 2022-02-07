      SUBROUTINE OUTSYM (SYMB)
C       PRINT A SYMBOL OF THE GRAMMAR OR OF 'SOURCE_TEXT'
C       2021-02-05: trailing ','
C       GF 11.07.1980
C
        INCLUDE 'PARS.f'
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
        EXTERNAL OUTPRO,OUTNUM
        IF (SYMB .NE. 0) GOTO 30
          SYML = PARASK('OUTSYM',1,6,2)
          SYMH = FSYM -1
        GOTO 31
30      CONTINUE
          SYML = SYMB
          SYMH = SYMB
31      CONTINUE
C
        DO 32 I = SYML,SYMH
          CALL ZZWC(' ---- SYMBOL ',1,13,0)
          CALL ZZWI(I, 4)
          CALL ZZWX(1)
          CALL PUTSYM (I)
          IF (PARASK('PACKED',1,6,1) .NE. 0) GOTO 35
          CALL ZZWC (', MAR: ',1,7,0)
          CALL ZZWI (SYMMAR(I),5)
          CALL ZZWC (', RST: ',1,7,0)
          CALL LITRAC (STARST,SYMRST(I),STAHIB,OUTNUM,1)
35        CONTINUE
          CALL ZZWS (0)
          CALL LITRAC (PRO   ,SYMPRO(I),PROHIB,OUTPRO,1)
32      CONTINUE
        RETURN ! OUTSYM
        END
