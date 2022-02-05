      SUBROUTINE LROPEN
C     OPEN THE PARSING TABLE
C     2005-03-29: demingle MEMSETS
C     GF 24.08.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'MEMS.F'
      INCLUDE 'PRES.F'
      INCLUDE 'PROS.F'
      INCLUDE 'SETS.F'
      INCLUDE 'STAS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,GOT   ! = 1 (0) IF THE STATE WAS (NOT) READ IN
     = ,HYPER   ! THE HYPER_AXIOM (VIRTUAL SYMBOL)
     = ,I1,I2 ! RESULT OF 'ITEMA2'
     = ,LEFT    ! A NONTERMINAL SYMBOL
     = ,MON1     ! MEMBER NUMBER ONE OF THE HYPER-RULE
     = ,PROD     ! PRODUCTION RETURNED BY 'PROCHA'
     = ,STATE3   ! DELTA(2,HYPER-AXIOM) = (->,3)
     = , TEMP
     = , MONP
C
      CALL DIRECT (2) ! WRITE 'SYMLNK,-POS,SEMS,STRS'
C
      CALL LILINK(ITEHIB,ITE   ,FITE)
C
      CALL LILINK(STAHIB,STAPRE,FSTA)
      STARST(STAHIB) = STAHIB
      FNUM = FSTA ! INCREMENTED IN 'STAALL'
      DO 1 I = FSTA,STAHIB
        STAITE(I) = 0
1     CONTINUE
C
      DO 2 I = 1,SYMHIB
        SYMRST(I) = STAHIB
        SYMMAR(I) = 0
2     CONTINUE ! INITIALIZE 'SYM'
C
      CALL LILINK(PREHIB,PRE   ,FPRE)
      PRESTA(PREHIB) = STAHIB ! FOR 'PREINS'
C
C
      MON1 = FMEM
      MEM(FMEM) = EOFILE
      CALL STAALL(STATE2,MEM(FMEM))
      FMEM = FMEM + 1
      MEM(FMEM) = AXIOM
      CALL STAALL(STATE3,MEM(FMEM))
      FMEM = FMEM + 1
      MEM(FMEM) = EOFILE
      FMEM = FMEM + 1
      MEM(FMEM) = EOP
      FMEM = FMEM + 1
C
C     PROD1 = (HYPER_AXIOM = EOFILE AXIOM EOFILE)
      PROD = FPRO
      FPRO = FPRO + 1
      PROMON(PROD) = MON1
      HYPER = 1 ! VIRTUAL SYMBOL
      PROLEF(PROD) = HYPER
      PRO(PROD) = PROHIB
C
      CALL SETINI
C
      CALL PREINS (STATE2,STATE3)
      CALL ITEMA2 (STATE2,  I1,I2,GOT)
      MONP = MON1 + 1;
      CALL ITEALL (AXIOM,MONP,SHIFT,STATE3,  I1,I2)
      CALL ITEMA9 (STATE2,1) ! 'GOT' BY 'STAALL'
C
      CALL ITEMA2 (STATE3,  I1,I2,GOT)
      TEMP = 1
      MONP = MON1 + 2
      CALL ITEALL (EOFILE,MONP,ACCEPT,TEMP,   I1,I2)
      CALL ITEMA9 (STATE3,1) ! 'GOT' BY 'STAALL'
C     TABLE0 = (1 EOFILE ?? 2 AXIOM -> 3 EOFILE =.)
C
      CALL SEPUSH (STAMAR,STATE2,STASUT,STASUB)
      CALL SEPUSH (STAMAR,STATE3,LAPUTT,LAPUTB)
C
      CALL SEPUSH (SYMMAR,HYPER,SYMINT,SYMINB) ! FOR 'PUTCON'
      I = FSYM - 1
      DO 3 LEFT = AXIOM,I
        IF (SYMPRO(LEFT) .EQ. PROHIB) GOTO 4
C         THIS IS A NONTERMINAL
          CALL SEPUSH (SYMMAR,LEFT,SYMINT,SYMINB)
4       CONTINUE
3     CONTINUE
      CALL INFOUT
      RETURN
C----------------------------------------------------------------
      ENTRY LRCLOS
C     CLOSE THE PARSING TABLE
C     GF 24.08.1980
C
      RETURN
      END
