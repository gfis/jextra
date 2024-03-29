      SUBROUTINE SPEMAP (SYMBOL)
C     EXTRACT A COMBINATION OF SPECIAL CHARACTERS AND RETURN A SYMBOL
C
      INCLUDE 'PARS.f'
      INCLUDE 'CODS.f'
      INCLUDE 'LINS.f'
      INCLUDE 'SPES.f'
      INCLUDE 'STRS.f'
      INCLUDE 'SYMS.f'
      INTEGER*2 PARASK
      INTEGER*2 ZZCR
      INTEGER*2 I
     = ,LINK    ! -> CURRENT SYMBOL
     = ,LNG     ! LENGTH OF 'SYMBOL'
     = ,LINLNG  ! LENGTH OF SYMBOL 'LINK'
     = ,SYMBOL  ! RESULTING SCANNER-SYMBOL
     = ,SPECOM(4) ! COLLECT THE 'SYMBOL' HERE
C
      LNG = 1
      FLIN = FLIN - 1 ! 'SCAN' ALREADY READ THE FIRST CHARACTER
      CALL ZZCC (LINE,FLIN,FLIN,  SPECOM,LNG,LNG)
      SYMBOL = SPEH ! 'SPEH' IS RETURNED FOR AN ILLEGAL COMBINATION
      LINK = SYMLNK(SYMBOL)
4     IF(LINK .GE. SYMHIB) GOTO 5
        LINLNG = SYMEND(LINK) - SYMPOS(LINK) + 1
        IF(PARASK('SPEMAP',1,6,0) .NE. 2) GOTO 12
          CALL ZZWC (' SPEREL =',1,9,0)
          CALL ZZWC (SPECOM,1,LNG,0)
          CALL ZZWC ('=?=',1,3,0)
          CALL PUTSYM(LINK)
          CALL ZZWS (0)
12      CONTINUE
        IF (ZZCR (SPECOM,1,LNG
     =           ,STRNG,SYMPOS(LINK),SYMEND(LINK)))
     =  19,20,21
19      CONTINUE
C         SPECOM(1:LNG) < STRNG(LINK)
          IF (LNG .GE. LINLNG) GOTO 100 ! DONE
          IF (ZZCR(SPECOM,1,LNG
     =            ,STRNG,SYMPOS(LINK),SYMPOS(LINK)+LNG-1) .NE. 0)
     =    GOTO 100
C         NOW 'LNG < LINLNG' AND 'SPECOM' IS A PREFIX
          GOTO 30 ! ADD
20      CONTINUE
C         SPECOM(1:LNG) = STRNG(LINK)
          SYMBOL = LINK
C
30        CONTINUE ! ADD:
          LNG = LNG + 1 ! LOOK WHETHER NEXT CHARACTER MATCHES TOO
          FLIN = FLIN + 1 ! THE ONE ON 'FLIN' MATCHED, NOW READ IT OFF
          CALL ZZCC(LINE,FLIN,FLIN,  SPECOM,LNG,LNG)
        GOTO 10 ! =
21      CONTINUE    ! > : TRY NEXT ELEMENT IN THE LIST
          LINK = SYMLNK(LINK)
10      CONTINUE
      GOTO 4
5     CONTINUE ! WHILE .GE. SYMHIB
C
100   CONTINUE !      DONMAP:
      IF (SYMBOL .EQ. SPEH)
     =  FLIN = FLIN + 1
      IF(PARASK('SPEMAP',1,6,0) .EQ. 0) GOTO 11
        CALL ZZWC(' SPEMAP: ',1,9,0)
        CALL PUTSYM (SYMBOL)
11    CONTINUE
      RETURN ! SPEMAP
      END
