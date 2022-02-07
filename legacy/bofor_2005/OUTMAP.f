      SUBROUTINE OUTMAP (PROD,POS)
C     PRINT A MARKED PRODUCTION
C     GF 11.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'MEMS.f'
      INCLUDE 'PRES.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SYMS.f'
      INTEGER*2 I,J
     = ,LOOPCH      ! TO CHECK AGAINST INFINITE LOOPS
     = ,POS      ! THE MARKER IS BEFORE IS POSITION
     =            ! OR NOT PRESENT IF 'POS = 0'
     = ,PROD      ! PRINT THIS PRODUCTION
     = ,SYMBOL
C
      CALL PUTSYM(PROLEF(PROD))
      CALL ZZWC (' = ',1,3,0)
      J = PROMON(PROD)
20      IF(J .GT. PROMON(PROD) + PROLNG(PROD) - 1) GOTO 21
        IF (J .NE. POS) GOTO 22
          CALL ZZWC (' @ ',1,3,0)
22        CONTINUE
        CALL PUTSYM (MEM(J))
        J = J + 1
      GOTO 20
21      CONTINUE
      RETURN ! OUTMAP
C---------------------------------------------------------------
      ENTRY OUTBUC (I)
C     PRINT A BUCKET OF THE HASH-TABLE OR THE LIST OF SPECIALS
C     GF 11.07.1980
C
      SYMBOL = I
11      IF(SYMBOL .GE. SYMHIB - 1) GOTO 10
        CALL PUTSYM (SYMBOL)
        CALL ZZWX (2)
        SYMBOL = SYMLNK(SYMBOL)
      GOTO 11
10      CONTINUE
      RETURN ! OUTBUC
C----------------------------------------------------------------
      ENTRY OUTMEM (I)
C     PRINT A MEMBER OF A PRODUCTION
C     GF 11.07.1980
C
      LOOPCH = 20
      CALL ZZWC ('                    MEMB: ',1,26,0)
      CALL ZZWI (I,4)
      CALL PUTSYM (MEM(I))
100      CONTINUE
      CALL ZZWS (0)
      RETURN ! OUTMEM
C---------------------------------------------------------
      ENTRY OUTNUM (I)
C     PRINT THE PARAMETER
C     GF 11.07.1980
C
      CALL ZZWI(I,0)
      CALL ZZWX(1)
      RETURN ! OUTNUM
C----------------------------------------------------------
      ENTRY OUTPRE (I)
C     PRINT AN ELEMENT OF A LIST OF PREDECESSORS
C     GF 11.07.1980
C
      CALL ZZWI (PRESTA(I),0)
      CALL ZZWX(1)
      RETURN ! OUTPRE
      END
