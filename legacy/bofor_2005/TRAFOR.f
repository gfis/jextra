      SUBROUTINE TRAFOR (PROD,TRAIN,   REIPOS,LEFT,TRALEF)
C     TREE - TRANSFORMATOR
C     GF 14.07.1980
C
C     'TRAFOR' IS CALLED WHEN 'PARSER' REDUCES TO 'PROD'.
C     THE CODES FOR THE SEMANTIC ACTIONS OF THIS PRODUCTION
C     ARE INTERPRETED IN SEQUENCE, AND THE CORRESPONDING
C     ACTIONS ('ACCO' ... 'EOS') ARE PERFORMED.
C
      INCLUDE 'PARS.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SEMS.f'
      INCLUDE 'STKS.f'
      INCLUDE 'SYMS.f'
      INCLUDE 'TRAS.f'
      INCLUDE 'TRES.f'
      EXTERNAL TREPUT
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,A1,A2   ! FOR CALLS OF 'TRACCU' AND 'TRATTR'
     = ,ACT     ! RESULT OF TRALOC
     = ,ANCH    ! APPEND 'ELEMENT'S TO THIS ANCHOR
     = ,ASEM    ! -> CURRENT 'SEM'-ENTRY
     = ,BANCH   ! COPY OF 'ANCH' DURING 'COMBINED_LIST'
     = ,INC     ! INCARNATION OF AN ACCU
     = ,LEFT    ! RESULTING LEFT SIDE OF 'PROD'
     = ,PROD    ! DO THE TRANSFORMATION FOR THIS PRODUCTION
     = ,REIPOS  ! POSITION OF ANY BACKSPACE-OPERATOR
     = ,SYMB    ! A TEMPORARY SYMBOL
     = ,TEMP    ! A TEMPORARY FOR EXCHANGING IN TRADEL, -PEN
     = ,TRAIN   ! ANCHOR FOR THE INPUT-STRING
     = ,TRALEF  ! ANCHOR FOR THE RESULTING SUBTREE FOR 'LEFT'
     = ,TREREF  ! -> COMBINED SYMBOL STORED BY 'TREPUT'
      COMMON /STAT2/
     =  A1,A2   ! FOR CALLS OF 'TRACCU' AND 'TRATTR'
     = ,ACT     ! RESULT OF TRALOC
     = ,ANCH    ! APPEND 'ELEMENT'S TO THIS ANCHOR
     = ,ASEM    ! -> CURRENT 'SEM'-ENTRY
     = ,BANCH   ! COPY OF 'ANCH' DURING 'COMBINED_LIST'
     = ,INC     ! INCARNATION OF AN ACCU
     = ,SYMB    ! A TEMPORARY SYMBOL
     = ,TEMP    ! A TEMPORARY FOR EXCHANGING IN TRADEL, -PEN
     = ,TREREF  ! -> COMBINED SYMBOL STORED BY 'TREPUT'
      INCLUDE 'ENDS.f'
C
      ANCH = TRAHIB ! EMPTY AT THE BEGINNING
      REIPOS = 0 ! NO '@'
      ASEM = PROSEM(PROD) - 1
      IF (PARASK ('TRAFOR',1,6,0) .LT. 1) GOTO 26
        CALL OUTPRO(PROD)
26    CONTINUE
C
99    CONTINUE ! ESAC:
      ASEM = ASEM + 1
      IF (PARASK  ('TRAFOR',1,6,0) .LT. 3) GOTO 21
        I = ASEM
        CALL ZZWC ('TRAFOR:',1,7,0)
        CALL OUTSEM(I)
        CALL ZZWS(0)
        CALL TRADUM (0)
21    CONTINUE
      I = SEM(ASEM)
      GOTO
     = (101,102,103,104 ! ACCO,IN,MA,TA
     = ,105,106,107,108 ! ATCO,IN,MA,SYAT
     = ,109,110,111,112 ! SOCO,REIN,UNCH,SOTA
     = ,113,114,115,116 ! SYCO,SYIN,SYMA,SEPR
     = ,117,118,119,120 ! ACCU,ATTR,EOSY,EOS
     = ),I
C----------------------------------------------------------
101   CONTINUE !  ACCO
C
      CALL TRACCU (ASEM,  SYMB,INC,A1,A2)
1011  CONTINUE
      IF (A2 .EQ. TRAHIB) GOTO 1 ! EXISTS
        CALL TRACOP (ANCH,TRAENT(A2))
      GOTO 2
1     CONTINUE
        CALL TRAPIM (ANCH,TIDEN,SYMB)
2     CONTINUE
      GOTO 99
C----------------------------------------------------------
102   CONTINUE !  ACIN
C
      CALL ASSERT  (127,PROD,ASEM)
C       ACIN IN PRODUCTION @, ASEM = @
      GOTO 99
C----------------------------------------------------------
103   CONTINUE ! ACMA
C
      IF (SEMSYM(ASEM) .NE. 0) GOTO 1031
C       HERE THE DESTINATION IS THE DELETE-ACCU
        ASEM = ASEM + 1
        CALL TRAPEN (FTRA,ANCH)
        ANCH = TRAHIB
      GOTO 99
1031  CONTINUE
      CALL TRACCU (ASEM,  SYMB,INC,A1,A2)
      IF (INC .LE. 0) GOTO 3
        IF (A2 .NE. TRAHIB) GOTO 4
          CALL ASSERT  (125,-SYMB,INC)
C           ASSIGNMENT TO NONEXISTING ACCU-INCARNATION @:@
4       CONTINUE
      GOTO 5
3     CONTINUE
        A2 = TRAHIB
5     CONTINUE
      INC = TVOID
      GOTO 1071 ! ATMA1
C----------------------------------------------------------
104   CONTINUE !  ACTA
C
      CALL TRACCU (ASEM,  SYMB,INC,A1,A2)
      IF (A2 .EQ. TRAHIB) GOTO 6 ! EXISTS
        CALL TRAPEN (ANCH,TRAENT(A2))
        TRA(A1) = TRA(A2) ! DEQUEUE INC.
        SYMMAR(SYMB) = TRA(1)
        TRA(A2) = A2
        CALL TRAPEN (FTRA,A2) ! DELETE INC.
      GOTO 8
6     CONTINUE
        CALL TRAPIM (ANCH,TIDEN,SYMB)
8     CONTINUE
      GOTO 99
C----------------------------------------------------------
105   CONTINUE !  ATCO
C
      CALL TRATTR (ASEM,  SYMB,INC,A1,A2)
      SYMB = INC
      GOTO 1011 ! ACCO1
C----------------------------------------------------------
106   CONTINUE !  ATIN
C
      CALL TRATTR (ASEM,  SYMB,INC,A1,A2)
      IF (A2 .EQ. TRAHIB) GOTO 12
      ACT = TRAENT(A2) ! -> CONTENT
      IF (ACT .EQ. TRAHIB) GOTO 12 ! -> LAST
        ACT = TRA(ACT) ! -> 1ST
        LEFT = TRAENT(ACT)
      GOTO 13
12    CONTINUE
        CALL ASSERT  (126,-SYMB, -INC)
C         ATIN AND ATTRIBUTE @$@ IS EMPTY OR DOES NOT EXIST
        LEFT = PROLEF(PROD)
13    CONTINUE
      TRALEF = ANCH
      IF (PARASK ('TRAFOR',1,6,0) .GE. 2)
     =  CALL TRAOUT (ASEM,LEFT,TRALEF)
      ANCH = TRAHIB
      GOTO 99
C----------------------------------------------------------
107   CONTINUE !  ATMA
C
      CALL TRATTR (ASEM,  SYMB,INC,A1,A2)
1071  CONTINUE ! ATMA1:
      IF (A2 .NE. TRAHIB) GOTO 14
        CALL TRAPIM (A2,INC,ANCH)
        TRA(A2) = TRA(1)
        SYMMAR(SYMB) = A2
      GOTO 30
14    CONTINUE
        CALL TRAPEN (FTRA,TRAENT(A2))
        TRAENT(A2) = ANCH
30    CONTINUE
      IF (PARASK ('TRAFOR',1,6,0) .GE. 2)
     =  CALL TRAOUT(ASEM,SYMB,TRAENT(A2))
      ANCH = TRAHIB
      GOTO 99
C---------------------------------------------------------
108   CONTINUE !  SYAT
C
      CALL TRATTR (ASEM,  SYMB,INC,A1,A2)
      IF (A2 .EQ. TRAHIB) GOTO 15
      ACT = TRAENT(A2) ! -> CONTENT
      IF (ACT .EQ. TRAHIB) GOTO 15 ! -> LAST
        ACT = TRA(ACT) ! -> 1ST
        SYMB = TRAENT(ACT)
      GOTO 16
15    CONTINUE
        CALL ASSERT  (128,-SYMB, -INC)
C         ATIN AND ATTRIBUTE @$@ IS EMPTY OR DOES NOT EXIST
        SYMB = TCOMT
16    CONTINUE
      GOTO 1151 ! COMSYM
C----------------------------------------------------------
109   CONTINUE !  SOCO
      I = FSTK + SEMSYM(ASEM) - 1
      GOTO 1092
C-----------------------------------------------------------
112   CONTINUE !  SOTA
C
      I = FSTK + SEMSYM(ASEM) - 1
      IF (STKSTA(I) .LT. 0) GOTO 1092
        CALL TRAPEN (ANCH,STKTRA(I))
        STKSTA(I) = - STKSTA(I) ! MARK IT "TAKEN"
      GOTO 1093
1092  CONTINUE ! WAS ALREADY TAKEN
        CALL TRACOP (ANCH,STKTRA(I))
1093  CONTINUE
      GOTO 99
C-----------------------------------------------------------
110   CONTINUE !  REIN
C
      REIPOS = SEMSYM(ASEM) ! NO REDUCTION IN 'PARSER'
      CALL TRAPEN (ANCH,TRAIN)
      TRAIN = ANCH ! PREFIX INPUT WITH ELEMENTS AFTER '@'
      IF (PARASK ('TRAFOR',1,6,0) .GE. 2)
     =  CALL TRAOUT (ASEM,ERRSYM,TRAIN)
      ANCH = TRAHIB
      GOTO 99
C-----------------------------------------------------------
111   CONTINUE !  UNCH
C
      I = FSTK
17    IF(I .GT. FSTK + PROLNG(PROD) - 1) GOTO 18
        IF (STKSTA(I) .LT. 0) GOTO 1112
          CALL TRAPEN (ANCH,STKTRA(I))
          STKSTA(I) = - STKSTA(I) ! MARK IT "TAKEN"
        GOTO 1113
1112    CONTINUE ! WAS ALREADY TAKEN
          CALL TRACOP (ANCH,STKTRA(I))
1113    CONTINUE
        I = I + 1
      GOTO 17
18    CONTINUE ! DO I
      LEFT = PROLEF(PROD)
      TRALEF = ANCH
      IF (PARASK ('TRAFOR',1,6,0) .GE. 2)
     =  CALL TRAOUT (ASEM,LEFT,TRALEF)
      ANCH = TRAHIB
      GOTO 1201
C-----------------------------------------------------------
113   CONTINUE !  SYCO
C
      CALL TRAPIM (ANCH,TKEYW,SEMSYM(ASEM))
      GOTO 99
C-----------------------------------------------------------
114   CONTINUE !  SYIN
C
      LEFT = SEMSYM(ASEM)
      TRALEF = ANCH
      IF (PARASK ('TRAFOR',1,6,0) .GE. 2)
     =  CALL TRAOUT (ASEM,LEFT,TRALEF)
      ANCH = TRAHIB
      GOTO 99
C-----------------------------------------------------------
115   CONTINUE !  SYMA
C
      SYMB = SEMSYM(ASEM)
1151  CONTINUE ! COMSYM:
      CALL TRAPIM (ANCH,TVOID,SYMB)
      BANCH = ANCH
      ANCH = TRAHIB
      GOTO 99
C-----------------------------------------------------------
116   CONTINUE !  SEPR
C
      I = SEMSYM(ASEM)
      IF (I .GE. 40) GOTO 1161
        CALL SEMANT (I,FSTK,ANCH,TRAIN)
      GOTO 99
1161  CONTINUE
        CALL SEPANT (I,FSTK,ANCH,TRAIN)
      GOTO 99
C-----------------------------------------------------------
117   CONTINUE !  ACCU
C
      CALL ASSERT  (131,PROD,ASEM)
      GOTO 99
C-----------------------------------------------------------
118   CONTINUE !  ATTR
C
      CALL ASSERT  (132,PROD,ASEM)
      GOTO 99
C-----------------------------------------------------------
119   CONTINUE !  EOSY
C
      IF (PARASK ('TRAFOR',1,6,0) .GE. 2)
     =  CALL TRAOUT (ASEM,TRASYM(BANCH),ANCH)
      ACT = ANCH
      ANCH = BANCH ! -> LAST
      TREREF = FTRE ! -> NEXT RECORD TO BE WRITTEN
      CALL TRADO (ACT,TREPUT)
      CALL TRAPEN (FTRA,ACT) ! DELETE THE CONTENTS OF THE COMB.SY
      CALL TRAPIM (ANCH,TGOTO,TREREF) ! INDICATES END OF COMB.SY
      CALL TREPUT (ANCH)
      TRASYM(ANCH) = TCALL
      GOTO 99
C-----------------------------------------------------------
120   CONTINUE !  EOS
C
      IF (SEMSYM(ASEM) .EQ. 1) GOTO 111 ! EOS,1 = UNCH
1201  CONTINUE
C
C     NOW DELETE ALL UNUSED SONS
      I = FSTK
22    IF (I .GT. FSTK + PROLNG(PROD) - 1) GOTO 23
        IF (STKSTA(I) .LT. 0) GOTO 1202
          CALL TRAPEN (FTRA,STKTRA(I)) ! DELETE UNMARKED SON
        GOTO 1203
1202    CONTINUE
          STKSTA(I) = - STKSTA(I) ! UNDO THE MARKING
1203    CONTINUE
        I = I + 1
      GOTO 22
23    CONTINUE
      IF (PARASK  ('TRADUM',1,6,0) .EQ. 0) GOTO 25
        CALL TRADUM (0) ! DUMP ALL
25    CONTINUE
C
C     DO   N O T   'GOTO ESAC', BUT LEAVE 'TRAFOR'
C
      RETURN
      END
