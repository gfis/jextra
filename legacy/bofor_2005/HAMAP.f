      SUBROUTINE HAMAP(SYMBOL)
C     MAP THE SYMBOL STORED BY PREVIOUS CALLS OF 'HAPSE'
C     GF 12.07.1980 : WITH PARASK('HAMAP')
C
      INCLUDE 'PARS.F'
      INCLUDE 'BUCS.F'
      INCLUDE 'STRS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,BUC      ! THE RESULT OF THE HASHING FUNCTION
     = ,POE     ! -> LAST CHARACTER
     = ,POS
     = ,LNG
     = ,BF15
     = ,BF31
     = ,SYMBOL
      INTEGER*2 ZZCR
C
      POS = SYMPOS(FSYM) ! THE TAIL OF 'STRNG'
      LNG = FSTR - POS
      POE = POS + LNG - 1
      ! MAP A STRING TO A NUMBER IN (1:BUCHIB)
      ! GLOBAL: 'POS,LNG,BUCHIB'
      BF31 = LNG
      CALL ZZCI (STRNG,POS,BF15)
      BF31 = BF31 + BF15
      CALL ZZCI (STRNG,POE,BF15)
      BF31 = BF31 + BF15
      BF15 = BUCHIB - 1
      BUC = MOD(BF31,BF15) + 1
      SYMBOL = BUCKET(BUC)
2     IF(SYMBOL .GE. SYMHIB) GOTO 3 ! LOOK FOR THE SAME STRING
        IF (ZZCR (STRNG,POS,POE
     =           ,STRNG,SYMPOS(SYMBOL),SYMEND(SYMBOL)) .NE. 0)
     =  GOTO 4
          FSTR = SYMPOS(FSYM) ! DELETE THE TAIL
          GOTO 101 ! DONMAP
4       CONTINUE ! FOUND
        SYMBOL = SYMLNK(SYMBOL) ! TRY NEXT IN THE LIST
      GOTO 2
3     CONTINUE ! WHILE .GE. SYMHIB
      ! THE NEW STRING WAS NOT FOUND, ALLOCATE A NEW SYMBOL
      IF (FSYM .GE. SYMHIB) GOTO 5
        SYMBOL = FSYM
        FSYM = FSYM + 1!
        SYMPOS(FSYM) = FSTR
CEND    SYMEND(SYMBOL) = POE ! 'SYMPOS' IS ALREADY O.K.
        ! PREFIX THE NEW SYMBOL TO THE LIST
        SYMLNK(SYMBOL) = BUCKET(BUC)
        BUCKET(BUC) = SYMBOL
      GOTO 6 ! NO 'SYM'-OVERFLOW
5     CONTINUE
        CALL ASSERT(7,SYMHIB,FSTR)
6     CONTINUE
C
101   CONTINUE!      DONMAP:
      IF(PARASK('HAMAP',1,5,0) .EQ. 0) GOTO 7
        CALL ZZWC (' HAMAP: ',1,7,0)
        CALL PUTSYM (SYMBOL)
        CALL ZZWS (0)
7     CONTINUE
      RETURN ! HAMAP
      END