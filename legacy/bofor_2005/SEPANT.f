      SUBROUTINE SEPANT (SEMNUM,ROOT,ANCH,TRAIN)
C     PERFORM A SPECIAL SEMANTIC ACTION
C     GF 07.08.1980: COPY OF 'SEMANT', FOR USER-ACTIONS
C     GF 08.11.1980: #47, #51 TO #53
C
      INCLUDE 'PARS.F'
      INCLUDE 'LINS.F'
      INCLUDE 'STAT1.F'
      INCLUDE 'SYMS.F'
      INCLUDE 'TRAS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,A1      ! -> ELEMENT BEFORE 'ANCH'
     = ,ANCH    ! -> 'TRA'-RING COLLECTED SO FAR
     = ,INC     ! INCARNATION OF A SON OR ACCU
     = ,FIRST   ! FOR MOVING DOWNWARDS IN #19
     = ,ROOT    ! -> 1ST MEMBER OF THE META-PRODUCTION IN 'TRA'
     = ,SEMNUM  ! NUMBER OF THE SPECIAL SEMANTIC ACTION TO BE PERFORMED
     = ,SON     ! RESULT OF 'SEMLUP' IN #29
     = ,SYMB    ! A TEMPORARY SYMBOL
     = ,TRAIN   ! -> RING FOR THE INPUT NOT YET CONSUMED
      INCLUDE 'ENDS.F'
C
      I = SEMNUM - 39
      IF (I .LT. 1) GOTO 1001
      GOTO
     = (1040,1041,1042,1043,1044,1045,1046,1047,1048,1049
     = ,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059
     = ,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069
     = ), I
      GOTO 99 !--------------------------------------------------
1001  CONTINUE
C
      CALL ASSERT (139,SEMNUM,0)
C       INVALID ACTION @
      GOTO 99
C-----------------------------------------------------------
C     GET SYSTEM-PARAMETERS
C
1040  CONTINUE!
C     CALL PARADD
      GOTO 99
C-----------------------------------------------------------
C      DO POSTFIX-POLISH ARITHMETIC ON THE RING 'ANCH'
C
C      #41 = '+', #42 = '-', #43 = '*', #44 = '/'
C
1041  CONTINUE!
1042  CONTINUE!
1043  CONTINUE!
1044  CONTINUE!
      CALL SEMARI (ANCH,SEMNUM-40)
      GOTO 99
C-----------------------------------------------------------
C     GENERATE A NEW NUMBER
C
1045  CONTINUE!
      TRASYM(ANCH) = TNUMB
      TRAENT(ANCH) = - NEWNUM ! CODED NUMBER
      NEWNUM = NEWNUM + 1
      GOTO 99
C-------------------------------------------------------------
C     REPLACE THE PREVIOUS SYMBOL BY ITS LENGTH
C
1046  CONTINUE!
      TRASYM(ANCH) = TNUMB
      SYMB = TRAENT(ANCH)
      TRAENT(ANCH) = - (SYMEND(SYMB) - SYMPOS(SYMB) + 1)
      GOTO 99
C------------------------------------------------------------------
C     N M #47 -> M (AND A MESSAGE IF N # M)
C
1047  CONTINUE
      CALL SEMARI (ANCH,SEMNUM-40)
      GOTO 99
C--------------------------------------------------------------------
1048  CONTINUE!
1049  CONTINUE!
1050  CONTINUE
      GOTO 99
C--------------------------------------------------------------------
C     X Y #51 -> IF X IS NOT Y THEN ASSERT(62)
C
1051  CONTINUE
      A1 = TRA(ANCH)
10511 IF(TRA(A1) .EQ. ANCH) GOTO 10512
        A1 = TRA(A1)
      GOTO 10511
10512 CONTINUE
      IF (TRAENT(A1) .EQ. TRAENT(ANCH)) GOTO 10513
        CALL ASSERT (62,-TRAENT(A1),-TRAENT(ANCH))
10513 CONTINUE
      GOTO 99
C--------------------------------------------------------------------
C     SPLIT THE STRING IN 'TREXPA' IN '2HXX,2HYY,...'
C
1052  CONTINUE
      TRAENT(ANCH) = - ABS(TRAENT(ANCH))
      GOTO 99
C--------------------------------------------------------------------
C     GENERATE A COMMENT WITH THE SOURCE-LINE-NUMBER
C
1053  CONTINUE
      CALL TRAPIM (ANCH,TCOMT,- LINENO+1)
      GOTO 99
C-------------------------------------------------------------------
1054  CONTINUE
1055  CONTINUE
1056  CONTINUE
1057  CONTINUE
1058  CONTINUE
1059  CONTINUE
1060  CONTINUE
1061  CONTINUE
1062  CONTINUE
1063  CONTINUE
1064  CONTINUE
1065  CONTINUE
1066  CONTINUE
1067  CONTINUE
1068  CONTINUE
1069  CONTINUE
C     ABOVE ACTIONS ARE ALL UNDEFINED SO FAR
C
99    CONTINUE ! ESAC
      RETURN
      END
