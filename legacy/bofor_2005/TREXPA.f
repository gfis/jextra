      SUBROUTINE TREXPA (TREREF)
C     EXPAND THE EXTERNAL TREE AND WRITE THE TARGET-PROGRAM
C     GF 26.07.1980
C     GF 08.11.1980: 'COMT', AND 'STRI' SPLIT RESP. DOUBLE QUOTES
C
      INCLUDE 'PARS.f'
      INCLUDE 'SLOS.f'
      INCLUDE 'STRS.f'
      INCLUDE 'SYMS.f'
      INCLUDE 'TRES.f'
      INTEGER*2 ZZINDX
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,COL     ! A COLUMN IN 'SLOT' WHICH CONTAINING THE ACTUAL RECORD
     = ,ENTITY  ! THE CURRENT SYMBOL TO BE WRITTEN
     = ,FATHER  ! -> PREVIOUS 'TCALL'-ELEMENT
     = ,LOOPCH  ! TO PROTECT AGAINST INFINITE LOOPS
     = ,POS     ! -> START IN 'STRNG'
     = ,POE     ! -> END   IN 'STRNG'
     = ,REF     ! NUMBER OF CURRENT 'TRE'-RECORD
     = ,ROW     ! CURRENT POSITION IN RECORD 'REF'
     = ,SYMBOL  ! THE SYMBOL-CLASS OF 'ENTITY'
     = ,TARLNG  ! FOR HANDLING OF FORTRAN COLUMN 1 - COLUMN 7
     = ,TREREF  ! -> THE OUTERMOST COMBINED SYMBOL
      INCLUDE 'ENDS.f'
C
      LOOPCH = 0
      TARLNG = 5 ! START WITH A NEW STATEMENT
      FATHER = 0 ! CRITERION FOR POP
      REF = TREREF ! START HERE
3       CONTINUE ! LOOP FOREVER
          CALL TREGET (REF,  COL,ROW)
4         IF(ROW .GE. TREHIB) GOTO 5
            SYMBOL = SLOT(ROW  ,COL)
            ENTITY = SLOT(ROW+1,COL)
            IF (PARASK('TREXPA',1,6,0) .EQ. 0) GOTO 11
              CALL ZZWC ('TREXPA: ',1,8,0)
              DO 12 I = 1,SLOHIB
                CALL ZZWI (SLOFUL(I),4)
12            CONTINUE
              CALL ZZWI (FATHER,8)
              CALL ZZWI (REF,8)
              CALL ZZWC ('-> SLOT(',1,8,0)
              CALL ZZWI (ROW,4)
              CALL ZZWC (',',1,1,0)
              CALL ZZWI (COL,4)
              CALL ZZWC (') =',1,3,0)
              CALL ZZWI (SYMBOL,4)
              CALL ZZWX (2)
              CALL PUTSYM (ENTITY)
              CALL ZZWS (0)
              LOOPCH = LOOPCH + 1
              IF (LOOPCH .GT. 256) RETURN
11          CONTINUE
C                VOID KEYW SPEC CALL COMT GOTO IDEN NUMB STRI
            GOTO(1001,1002,1003,1004,1005,1006,1007,1008,1009
     =      ),SYMBOL
C--------------------------------------------------------------
1001  CONTINUE ! VOID
C
      GOTO 99
C--------------------------------------------------------------
1002  CONTINUE ! KEYW
C
      IF (ENTITY .NE. EOSTMT) GOTO 1007 ! IDEN
        TARLNG = 5
        CALL ZZTS (-1) ! BEGIN A NEW FORTRAN-STATEMENT
      GOTO 99
C--------------------------------------------------------------
1003  CONTINUE ! SPEC
C
      CALL ZZTC (STRNG,SYMPOS(ENTITY),SYMEND(ENTITY),0)
      GOTO 99
C--------------------------------------------------------------
1004  CONTINUE ! CALL
C
      SLOT(ROW,COL) = FATHER ! REPLACE 'TCALL' BY BACK-CHAIN
      FATHER = REF
      REF = ENTITY
      GOTO 100 ! GET
C--------------------------------------------------------------
1005  CONTINUE ! COMT
C
      CALL ZZTS (-2) ! PLACE 'C ' AT START OF LINE
      IF (ENTITY .GE. 0) GOTO 10051
        CALL ZZTI (-ENTITY,6) ! IT IS A LINE-NUMBER IN CODED FORM
10051 CONTINUE
      GOTO 99
C--------------------------------------------------------------
1007  CONTINUE ! IDEN
C
      CALL ZZTX (TARLNG+1)
      TARLNG = 0
      CALL ZZTC (STRNG,SYMPOS(ENTITY),SYMEND(ENTITY),0)
      GOTO 99
C--------------------------------------------------------------
1008  CONTINUE ! NUMB
C
      IF (ENTITY .LE. 0) GOTO 8
        CALL ZZTC(STRNG,SYMPOS(ENTITY),SYMEND(ENTITY),TARLNG)
      GOTO 9
8     CONTINUE ! CODED NUMBER
        CALL ZZTI (-ENTITY,TARLNG)
9     CONTINUE
      TARLNG = 0
      GOTO 99
C--------------------------------------------------------------
1009  CONTINUE ! STRI
C
      IF (ENTITY .LT. 0) GOTO 10092
C       DO NOT SPLIT, BUT DOUBLE QUOTES
        POS = SYMPOS(ENTITY)
        POE = SYMEND(ENTITY)
        CALL ZZTS(POE-POS+5) ! F4P DISALLOWS STRING ON TWO CARDS
        CALL ZZTC ('''',1,1,0)
        I = POS  ! START AT THE BEGINNING
10093   CONTINUE
          POS = ZZINDX (STRNG,I,POE,'''') ! POSITION OF ANY QUOTE, OR 0
          IF (POS .NE. 0) GOTO 10094
C           NO INNER QUOTE FOUND
            CALL ZZTC (STRNG,I,POE,0) ! OUTPUT THE REST
            GOTO 10095
10094     CONTINUE
          CALL ZZTC (STRNG,I,POS-1,0) ! PUT THE PORTION BEFORE QUOTE
          CALL ZZTC ('''''',1,2,0)    ! PUT DOUBLED INNER QUOTE
          I = POS + 1 ! GO ON BEHIND THE QUOTE
        IF (I .LE. POE) GOTO 10093
10095   CONTINUE
        CALL ZZTC ('''',1,1,0)        ! PUT QUOTE AT THE END
        GOTO 99
10092 CONTINUE ! SPLIT IN '2HXX,2HYY,...'
        ENTITY = - ENTITY
        POS = SYMPOS(ENTITY)
        POE = SYMEND(ENTITY)
        CALL ZZTC ('2H',1,2,0)
10091 CONTINUE
        CALL ZZTC (STRNG,POS,POS+1,0)
        POS = POS + 2
        IF (POS .GT. POE) GOTO 10
          CALL ZZTC (',2H',1,3,0)
          GOTO 10091
10      CONTINUE
      GOTO 99
C--------------------------------------------------------------
99          CONTINUE ! ESAC
            ROW = ROW + 2
            REF = REF + 2
          GOTO 4
5         CONTINUE ! ROW < TREHIB
          SLOFUL(COL) = 0 ! FREE THIS SLOT - IT IS PROCESSED
C
100       CONTINUE ! GET:
        GOTO 3 ! INFINITE LOOP
C
1006    CONTINUE ! GOTO:
        REF = FATHER
        CALL TREGET (REF,  COL,ROW)
        FATHER = SLOT(ROW,COL)
        ROW = ROW + 2 ! BEHIND 'TCALL'
        REF = REF + 2
      IF (FATHER .NE. 0) GOTO 4
C
      RETURN ! TREXPA
      END
