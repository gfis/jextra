      SUBROUTINE DELTA (STATE,SYMBOL,  ACTION,SUCPRO)
C     COMPUTES THE TRANSITION-FUNCTION OF THE PUSHDOWN-AUTOMATON
C     RETURNS THE 1ST 'ITEM' IN 'STATE' WITH 'ITESYM(ITEM) = SYMBOL'
C     'ITEACT(ITEM) = ERROR' IF NO SUCH 'ITEM' EXISTS
C     GF 14.03.1981: WITH 'ITEACT' INCORPORATED
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'MEMS.F'
      INCLUDE 'STAS.F'
      INCLUDE 'STKS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 PARASK
      INTEGER*2 I,J
     = ,ACTION  ! THE RESULTING PARSER ACTION
     = ,GOT     ! RESULT OF 'ITEMA1'
     = ,ITEM     ! -> 1ST ITEM IN 'STATE' THAT HAS 'ITESYM(ITEM)=SYMBOL
     = ,MEMB    ! THE MEMBER AT 'ITEPOS(ITEM)'
     = ,POS     ! = 'ITEPOS(ITEM)'
     = ,SUCPRO  ! THE RESULTING SUCCESSOR RESP. PRODUCTION
     = ,STATE
     = ,SYMBOL
C
      CALL ITEMA1 (STATE,  ITEM,GOT)
1     IF(ITEM .GE. ITEHIB) GOTO 2
        IF (ITESYM(ITEM) .EQ. SYMBOL)
     =    GOTO 100
        ITEM = ITE(ITEM) ! TRY NEXT
      GOTO 1
2     CONTINUE ! ALL ITEMS
C     HERE THE SYMBOL WAS NOT FOUND - ERROR
      ACTION = ERROR
C     PERHAPS WE MAY 'ASSUME' A REDUCTION ?
      I = STAITE(STATE)
      SUCPRO = ITEPOS(I)
      IF (MEM(SUCPRO) .NE. EOP) GOTO 4
        ACTION = REDUCE
        ITEM = I
4     CONTINUE
      GOTO 3
C     HERE IT WAS FOUND
100   CONTINUE
      POS = ITEPOS(ITEM)
      MEMB = MEM(POS)
      IF (MEMB .LE. EOFILE) GOTO 6 ! 'EOFILE' OR 'EOP'=REDUCE
        ACTION = SHIFT
        GOTO 3
6     CONTINUE
      IF (MEMB .NE. EOP) GOTO 7
        ACTION = REDUCE
        GOTO 3
7     CONTINUE
      IF (MEMB .NE. EOFILE)
     =  CALL ASSERT (10,MEMB,POS)
C         INVALID MEMBER @ AT POSITION @
        ACTION = ACCEPT
        IF (0.EQ.0) GOTO 3
      IF (PARASK('DELTA',1,5,0) .EQ. 0) GOTO 3
        CALL ZZWC('STACK: ',1,7,0)
        J = FSTK - 1
        DO 5 I = 2,J
          CALL ZZWC('|',1,1,0)
          CALL ZZWI (STKSTA(I),4)
          CALL ZZWC(',',1,1,0)
          CALL PUTSYM (STKSYM(I))
5       CONTINUE
        CALL ZZWC (', ',1,2,0)
        CALL PUTSYM (SYMBOL)
        CALL PUTACT (ITEM)
        CALL ZZWS(0)
3     CONTINUE ! PARASK('DELTA')
      SUCPRO = ITESUC(ITEM)
      CALL ITEMA8 (STATE,GOT)
CXML
C     XML4 (DELTA, STATE,SYMBOL,  ACTION,SUCPRO)
      CALL XML4 ('DELTA', 1, 5, STATE,SYMBOL,ACTION,SUCPRO)
      RETURN! DELTA
      END