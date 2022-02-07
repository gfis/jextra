      SUBROUTINE SEMANT (SEMNUM,ROOT,ANCH,TRAIN)
C     PERFORM A SPECIAL SEMANTIC ACTION
C     GF 14.07.1980
C     GF 20.07.1980: WITH #7, WITHOUT NEGATE IN #12
C     GF 07.08.1980: USER'S ACTIONS NOW BY 'SEPANT'
C     GF 09.11.1980: WITH #34
C
C-----------------------------------------------------------------
C     THIS VERSION OF 'SEMANT' HANDLES ACTIONS #1 - #33
C     I.E. THE ACTIONS FOR THE META-GRAMMAR
C
C     THE POSSIBLE SEQUENCES OF ACTIONS FOR A PRODUCTION
C     ARE DESCRIBED BY THE FOLLOWING REGULAR EXPRESSIONS:
C
C     .SEMCLO = ( UNCH
C               | ( ELEM* SYIN SYMB
C                 | ELEM* ATIN SON   ATTR SYMB
C                 | ELEM* REIN POS
C                 )
C               )
C               ( ELEM* ( ACMA SYMB ACCU INC
C                       | ATMA SON  ATTR SYMB )
C               )*
C               ELEM* EOS
C     .ELEM   = ( SOCO | SOTA ) SON
C             | ( ACCO | ACTA ) SYMB ACCU INC
C             |   ATCO          SON  ATTR SYMB
C             |   SYCO          SYMB
C             |   SEPR          NUM
C             | ( SYMA | SYAT SON ATTR SYMB ) ELEM*  EOSY
C
C$  /*------------------------------------------------------*/
C$  /* META-GRAMMAR FOR PARSING OF TRANSFORMATION GRAMMARS  */
C$  /* GEORG FISCHER JULY 20, 1980                          */
C$  /*------------------------------------------------------*/
C$ EOF IDENTIFIER NUMBER STRING
C$ [AXIOM = EXTRA_INPUT
C$ .EXTRA_INPUT    = '[' GRAMMAR ']' SOURCE_TEXT   => #1
C$                 | EXTRA_INPUT
C$                   '[' GRAMMAR ']' SOURCE_TEXT   => #1
C$ .GRAMMAR        = RULES                         => #2
C$ .RULES          = RULE
C$                 | RULES '..' RULE
C$ .RULE           = LEFT_SIDE '=' RIGHT_SIDES
C$ .LEFT_SIDE      = IDENTIFIER                    => #3
C$ .RIGHT_SIDES    = RIGHT_SIDE
C$                 | RIGHT_SIDES '|' RIGHT_SIDE
C$ .RIGHT_SIDE     = SYNTAX_PART SEMANTIC_PART
C$ .SYNTAX_PART    = MEMBERETIES                   => #6
C$ .SOURCE_TEXT    =
C$ .MEMBERETIES    =                               => #7
C$                 | MEMBERETIES MEMBER
C$ .MEMBER         = PRIMARY
C$ .PRIMARY        = IDENTIFIER                    => #8
C$                 | STRING                        => #9
C$                 | NUMBER                        => #8
C$ .SEMANTIC_PART  = TRANSFORMATIONS               => #11
C$ .TRANSFORMATIONS=                               => #12
C$                 | '=>' TRANSFORMATION           => #13
C$                 | TRANSFORMATIONS '->' TRANSFORMATION
C$                                                 => #14
C$ .TRANSFORMATION = DESTINATION
C$                 | TRANSFORMATION ELEMENT        => #16
C$ .DESTINATION    = '='                           => #17
C$                 | ELEMENT                       => #18
C$                 | SYMBOL '='                    => #19
C$ .ELEMENT        = SYMBOL                        => #20
C$                 | '#' NUMBER                    => #21
C$                 | NUMBER                        => #22
C$                 | STRING                        => #23
C$                 | '@'                           => #24
C$                 | SYMBOL '(' COMBINED_LIST ')'  => #25
C$ .SYMBOL         = INCARNATION
C$                 | INCARNATION '$' IDENTIFIER    => #27
C$ .INCARNATION    = IDENTIFIER                    => #28
C$                 | IDENTIFIER ':' NUMBER         => #29
C$ .COMBINED_LIST  =                               => #30
C$                 | COMBINED_LIST SYMBOL
C$                 | COMBINED_LIST NUMBER          => #32
C$                 | COMBINED_LIST STRING          => #33
C$                 | COMBINED_LIST '#' NUMBER      => #34
C$ .
C$ ]
C-----------------------------------------------------------
      INCLUDE 'PARS.f'
      INCLUDE 'MEMS.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SEMS.f'
      INCLUDE 'STRS.f'
      INCLUDE 'SYMS.f'
      INCLUDE 'STAT1.f'
      INCLUDE 'TRAS.f'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,ANCH    ! -> 'TRA'-RING COLLECTED SO FAR
     = ,INC     ! INCARNATION OF A SON OR ACCU
     = ,FIRST   ! FOR MOVING DOWNWARDS IN #19
     = ,ROOT    ! -> 1ST MEMBER OF THE META-PRODUCTION IN 'TRA'
     = ,SEMNUM  ! NUMBER OF THE SPECIAL SEMANTIC ACTION TO BE PERFORMED
     = ,SON     ! RESULT OF 'SEMLUP' IN #29
     = ,SYMB    ! A TEMPORARY SYMBOL
     = ,TRAIN   ! -> RING FOR THE INPUT NOT YET CONSUMED
     = ,NULL
     = ,TEMP
      INCLUDE 'ENDS.f'
C
      NULL = 0
      GOTO  (1001,1002,1003,1004,1005,1006,1007,1008,1009
     = ,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019
     = ,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029
     = ,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039
     = ), SEMNUM
      GOTO 99 !--------------------------------------------------
1001  CONTINUE!  .EXTRA_INPUT = '[' GRAMMAR ']' SOURCE_TEXT
C                | EXTRA_INPUT  '[' GRAMMAR ']' SOURCE_TEXT
C
                 INGRAM = 1
      GOTO 99 !--------------------------------------------------
1002  CONTINUE!  .GRAMMAR = RULES
C
                 IF (PARASK('SEPAR',1,5,1) .EQ. 0) GOTO 10021
C                  GENERATE TWO TABLES, FORCE 'EOF'
                   I = TRAIN
                   CALL TRAPIM (TRAIN,EOFILE,0)
                   TRAIN = I ! PREFIX INPUT WITH 'EOFILE'
                 GOTO 10022
10021            CONTINUE
C                  CALL REORG
10022            CONTINUE
C                IF (PARASK('PARADD',1,6,1) .NE. 0) CALL PARADD
                 INGRAM = 0
      GOTO 99 !--------------------------------------------------
1003  CONTINUE!  .LEFT_SIDE = IDENTIFIER
C
                 BUPROD = 0 ! FOR TRACE AFTER '99'
                 CALL SEMGET (ROOT,1,BULEFT)
      GOTO 99 !--------------------------------------------------
1006  CONTINUE!  SYNTAX_PART = MEMBERETIES
C
                 CALL PROCHA (1,BULEFT,BUMON,FMEM-BUMON,  BUPROD)
C                        ADDSUB,        ,LNG     ,  =:
                 PROSEM(BUPROD) = FSEM
                 IF (PARASK('SINGLE',1,6,0) .EQ. 0) GOTO 51
                   CALL REORG
51               CONTINUE
                 REIPOS = 0
                 MEMPOS = 0
      GOTO 99 !--------------------------------------------------
1007  CONTINUE!  .MEMBERETIES =
C
                 BUMON = FMEM
      GOTO 99 !--------------------------------------------------
1008  CONTINUE!  .PRIMARY = IDENTIFIER
              !           | NUMBER
C
                 CALL SEMGET (ROOT,1,SYMB)
110   CONTINUE!MEMSTO:
                 IF (FMEM .GE. MEMHIB) GOTO 52
                   MEM(FMEM) = SYMB
                   FMEM = FMEM + 1
                 GOTO 53
52               CONTINUE
                   CALL ASSERT (175,FMEM,-SYMB) ! INCREASE MEMHIB (=@)
53               CONTINUE
      GOTO 99 !--------------------------------------------------
1009  CONTINUE!  .PRIMARY = STRING
C
                 CALL SEMGET (ROOT,1,I)
                 CALL SPEINS(STRNG,SYMPOS(I),SYMEND(I),  SYMB)
                 GOTO 110 ! MEMSTO
C     GOTO 99 !--------------------------------------------------
1011  CONTINUE!  .SEMANTIC_PART = TRANSFORMATIONS
C
                 CALL SEMCLO(BUPROD)
      GOTO 99 !--------------------------------------------------
1012  CONTINUE!  .TRANSFORMATIONS =
C
                 CALL SEMWRI (NULL,UNCH,NULL)
      GOTO 99 !---------------------------------------------------
1013  CONTINUE!  | '=>' TRANSFORMATION
C
                 SEM(DESL) = SEM(DESL) + SYIN - SYCO
                 IF (SEM(DESL) .NE. SYIN .OR. SEMSYM(DESL)
     =             .NE. PROLEF(BUPROD) .OR. REIPOS .LE. 0)
     =           GOTO 3
                   CALL SEMWRI (NULL,REIN,REIPOS)
                   GOTO 4
3                CONTINUE
                   IF (REIPOS .LE. 0) GOTO 5
                     CALL ASSERT(95,REIPOS,NULL)
C                      RE-INPUT NOT ALLOWED HERE, POSITION @
5                  CONTINUE
                   DO 6 I = DESL,DESU
                     CALL SEMWRI (NULL,SEM(I),SEMSYM(I))
6                  CONTINUE
4                CONTINUE
      GOTO 99 !----------------------------------------------------
1014  CONTINUE!  | TRANSFORMATIONS '->' TRANSFORMATION
C
                 SEM(DESL) = SEM(DESL) + SYMA - SYCO
                   IF (REIPOS .LE. 0) GOTO 7
                     CALL ASSERT(96,REIPOS,NULL)
C                      RE-INPUT NOT ALLOWED HERE, POSITION @
7                  CONTINUE
                   DO 8 I = DESL,DESU
                     CALL SEMWRI (NULL,SEM(I),SEMSYM(I))
8                  CONTINUE
      GOTO 99 !----------------------------------------------------
1015  CONTINUE!  .TRANSFORMATION = DESTINATION
C
      GOTO 99 !---------------------------------------------------
1016  CONTINUE!  | TRANSFORMATION ELEMENT
C
                 MEMPOS = MEMPOS + 1
      GOTO 99 !---------------------------------------------------
1017  CONTINUE!  .DESTINATION = '='
C
                 DESU = DESL + 1
                 CALL SEMWRI (DESL,ACCO,NULL) ! DELETE-ANCHOR
                 CALL SEMWRI (DESU,ACCU,NULL)
                 REIPOS = -1 ! DISALLOW '@'
                 MEMPOS = 0
      GOTO 99 !---------------------------------------------------
1018  CONTINUE!  | ELEMENT
C
                 DESU = DESL
                 CALL SEMWRI (DESL,SYCO,PROLEF(BUPROD))
                 MEMPOS = 1 ! 1ST MEMBER IS ALREADY PROCESSED
      GOTO 99 !-----------------------------------------------------
1019  CONTINUE!  | SYMBOL '='
C
                 DESU = DESL - 1
                 FIRST = FSEM - 1
                 IF (SEM(FIRST) .NE. ACCU .AND.
     =             SEM(FIRST) .NE. ATTR)
     =           GOTO 9
                   FIRST = FIRST - 1
9                CONTINUE
                 I = FIRST
10               IF (I .GT. FSEM - 1) GOTO 11 ! MOVE TO SEMS(DESL:DESU)
                   DESU = DESU + 1
                   CALL SEMWRI (DESU,SEM(I),SEMSYM(I))
                   I = I + 1
                 GOTO 10
11               CONTINUE
                 FSEM = FIRST
                 REIPOS = -1 ! DISALLOW '@'
                 MEMPOS = 0
      GOTO 99 !--------------------------------------------------
1020  CONTINUE!  .ELEMENT = SYMBOL
      GOTO 99 !--------------------------------------------------
1021  CONTINUE!  | '#' NUMBER
C
                 CALL SEMGET (ROOT,-2,SYMB)
                 CALL SEMWRI (NULL,SEPR,SYMB)
      GOTO 99 !---------------------------------------------------
1022  CONTINUE!  | NUMBER
C
                 INC = - 1
                 CALL SEMGET (ROOT,1,SYMB)
                 GOTO 100 ! LOOKUP
C     GOTO 99 !---------------------------------------------------
1023  CONTINUE!  | STRING
C
                 INC = - 1
                 CALL SEMGET (ROOT,1,SYMB)
101   CONTINUE!STRISE:
                 FSYM = SYMHIB + FSYM ! DISABLE INSERTION IN 'SPEINS'
                 CALL SPEINS (STRNG,SYMPOS(SYMB),SYMEND(SYMB),I)
                 IF (I .EQ. 0) GOTO 12 ! ALREADY IN THE GRAMMAR
                   SYMB = I
12               CONTINUE
                 GOTO 100
C     GOTO 99 !-------------------------------------------------
1024  CONTINUE!  | '@'
C
                 IF (REIPOS .EQ. 0) GOTO 13
                   CALL ASSERT (93,MEMPOS,NULL)
C                    BACKSPACING NOT ALLOWED HERE, POSITION @
                 GOTO 14
13               CONTINUE
                   REIPOS = MEMPOS + 1
                   FSEM = PROSEM(BUPROD) ! ALL BEFORE '@' REMAIN UNCHANG
14               CONTINUE
      GOTO 99 !-------------------------------------------------
1025  CONTINUE!  | SYMBOL '(' COMBINED_LIST ')'
C
                 CALL SEMWRI (NULL,EOSY,NULL)
      GOTO 99 !-------------------------------------------------
1026  CONTINUE!  .SYMBOL = INCARNATION
      GOTO 99 !-------------------------------------------------
1027  CONTINUE!  | INCARNATION '$' IDENTIFIER
C
                 CALL SEMGET (ROOT,3,SYMB)
                 IF (SEM(FSEM-1) .NE. ACCU) GOTO 15
                   CALL ASSERT (94, - SYMB,NULL)
C                    ATTRIBUTE @ NOT ALLOWED HERE
                 GOTO 16
15               CONTINUE
                   SEM(FSEM-1) = ATCO
                   CALL SEMWRI (NULL,ATTR,SYMB)
16               CONTINUE
      GOTO 99 !--------------------------------------------------
1028  CONTINUE!  .INCARNATION = IDENTIFIER
C
                 INC = 0
                 CALL SEMGET (ROOT,1,SYMB)
                 GOTO 100 ! LOOKUP
C     GOTO 99 !-------------------------------------------------
1029  CONTINUE!  | IDENTIFIER ':' NUMBER
C
                 CALL SEMGET (ROOT,1,SYMB)
                 CALL SEMGET (ROOT,-3,INC)
C
100   CONTINUE ! LOOKUP:
                 CALL SEMLUP (BUPROD,SYMB,INC,  SON)
      GOTO 99 !--------------------------------------------------
1030  CONTINUE!  .COMBINED_LIST =
C
C                THE LAST ACTION WAS FOR (THE COMBINDE) 'SYMBOL'
                 IF (SEM(FSEM-1) .NE. SOCO) GOTO 17
C                  REVERT THE EFFECT OF 'SEMLUP', STORE
C                  THE SYMBOL INSTEAD OF THE SON-NUMBER
                   I = PROMON(BUPROD) + SEMSYM(FSEM-1) - 1
                   TEMP = FSEM-1
                   CALL SEMWRI(TEMP,SYMA,MEM(I))
                 GOTO 18
17               CONTINUE
                 IF (SEM(FSEM-1) .NE. ATTR) GOTO 19
                   SEM(FSEM-2) = SYAT
                 GOTO 18
19               IF (SEM(FSEM-1) .NE. SYCO) GOTO 20
                   SEM(FSEM-1) = SYMA
                 GOTO 18
20               CONTINUE ! ELSE = ACCU
                   FSEM = FSEM - 1
                   IF (SEMSYM(FSEM) .EQ. 0) GOTO 21 ! INC > 0
                     CALL ASSERT (92, - SEMSYM(FSEM-1),SEMSYM(FSEM))
C                      COMBINED SYMBOL @ MUST NOT BE AN ACCU WITH INCARN
21                 CONTINUE
                   SEM(FSEM-1) = SYMA
18               CONTINUE
      GOTO 99 !-------------------------------------------------
1031  CONTINUE!  | COMBINED_LIST SYMBOL
C
      GOTO 99 !-------------------------------------------------
1032  CONTINUE!  ! COMBINED_LIST NUMBER
C
                 INC = -1
                 CALL SEMGET (ROOT,2,SYMB)
                 GOTO 100 ! LOOKUP
C     GOTO 99 !-------------------------------------------------
1033  CONTINUE!  | STRING
C
                 INC = -1
                 CALL SEMGET (ROOT,2,SYMB)
                 GOTO 101 ! STRISE
C     GOTO 99 !-------------------------------------------------
1004  CONTINUE!
1005  CONTINUE!
1010  CONTINUE!
C
      GOTO 99 !------------------------------------------------------
1034  CONTINUE!  | COMBINED_LIST '#' NUMBER   (CF. #21)
C
                 CALL SEMGET (ROOT,-3,SYMB)
                 CALL SEMWRI (NULL,SEPR,SYMB)
      GOTO 99 !------------------------------------------------------
1035  CONTINUE!
1036  CONTINUE!
1037  CONTINUE!
1038  CONTINUE!
1039  CONTINUE!
      GOTO 99
C     ABOVE ACTIONS ARE ALL UNDEFINED SO FAR
C
99    CONTINUE ! ESAC
      IF(PARASK('SEMANT',1,6,0) .EQ. 0 .OR. BUPROD .EQ. 0) GOTO 22
        CALL OUTPRO(BUPROD)
22    CONTINUE
      RETURN
      END
