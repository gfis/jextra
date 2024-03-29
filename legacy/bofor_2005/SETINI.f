      SUBROUTINE SETINI
C     INITIALIZE ALL SETS
C     2005-03-29: demingle MEMSETS
C     GF 24.08.1980: 'SET' MINGLED UP WITH 'MEMNUC'
C
      INCLUDE 'PARS.f'
      INCLUDE 'MEMS.f'
      INCLUDE 'SETS.f'
      INTEGER*2 I
     = ,J  ! 'MEMNUC(J)' MAY BE USED AS 'SET(J)' (.NE. PROD-NO.)
C
      CALL LILINK(SETHIB,SET,  FSET)
      GOTO 6
C----
      J = 1
      DO 1 I = 2,SETHIB
        IF (MEM(I) .EQ. EOP) GOTO 2
          J = I
          SET(J) = I + 1
        GOTO 3
2       CONTINUE
          SET(J) = I + 1
3       CONTINUE
1     CONTINUE
      I = 1
4     I = I + 1
      IF (MEM(I) .EQ. EOP) GOTO 4
      FSET = I
      SET(J) = SETHIB
      SET(SETHIB) = SETHIB
C----
6     CONTINUE
      CALL SETBIN
      CALL SETALL(EMITSH,EMITST,EMITSB)
      CALL SETALL(EMITTH,EMITTT,EMITTB)
      CALL SETALL(LAGARH,LAGART,LAGARB)
      CALL SETALL(LAGETH,LAGETT,LAGETB)
      CALL SETALL(LAPUTH,LAPUTT,LAPUTB)
      CALL SETALL(SPLITH,SPLITT,SPLITB)
      CALL SETALL(STAGAH,STAGAT,STAGAB)
      CALL SETALL(STAGBH,STAGBT,STAGBB)
      CALL SETALL(STASUH,STASUT,STASUB)
      CALL SETALL(TREOUH,TREOUT,TREOUB)
      CALL SETBIN
      CALL SETALL(PRODEH,PRODET,PRODEB) ! PROMAR
      CALL SETBIN
      CALL SETALL(STACLH,STACLT,STACLB) ! SYMMAR
      CALL SETALL(STAOPH,STAOPT,STAOPB) ! SYMMAR
      CALL SETALL(SYMINH,SYMINT,SYMINB) ! SYMMAR
      CALL SETALL(GRASYH,GRASYT,GRASYB) ! SYMMAR
      RETURN ! SETINI
      END
