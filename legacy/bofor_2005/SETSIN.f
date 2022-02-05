      SUBROUTINE SETSIN
C     INFORM ABOUT ALL SETS
C
      INCLUDE 'PARS.F'
      INCLUDE 'SETS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,ELEM
     = ,STATE     ! A STATE THAT CONTAINS A CONFLICT
     = ,SYMBOL    ! A SYMBOL THAT IS NOT ACCESSIBLE
C
      IF (PARASK('SETSIN',1,6,0) .EQ. 0) GOTO 1
        CALL ZZWC ('<sets>', 1, 6, 0)
        CALL ZZWS (0)
        CALL SETINF('EMITS ',1,6,EMITSH,EMITST)
        CALL SETINF('EMITT ',1,6,EMITTH,EMITTT)
        CALL SETINF('LAGAR ',1,6,LAGARH,LAGART)
        CALL SETINF('LAGET ',1,6,LAGETH,LAGETT)
        CALL SETINF('LAPUT ',1,6,LAPUTH,LAPUTT)
        CALL SETINF('PRODEL',1,6,PRODEH,PRODET)
        CALL SETINF('SPLIT ',1,6,SPLITH,SPLITT)
        CALL SETINF('STACLO',1,6,STACLH,STACLT)
        CALL SETINF('STAGAR',1,6,STAGAH,STAGAT)
        CALL SETINF('STAGB ',1,6,STAGBH,STAGBT)
        CALL SETINF('STAOPC',1,6,STAOPH,STAOPT)
        CALL SETINF('STASUC',1,6,STASUH,STASUT)
        CALL SETINF('SYMINS',1,6,SYMINH,SYMINT)
        CALL SETINF('TREOUS',1,6,TREOUH,TREOUT)
        CALL ZZWC ('</sets>', 1, 7, 0)
        CALL ZZWS (0)
1     CONTINUE ! SETSIN
      RETURN ! SETSIN
      END