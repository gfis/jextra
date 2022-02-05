      SUBROUTINE SCANR (SYMBOL,ENTITY)
C     THE SCANNER BUILDS SYMBOLS FROM CHARACTERS
C     GF 12.07.1980 : WITH PARASK('SCAN')
C
      INCLUDE 'PARS.F'
      INCLUDE 'CODS.F'
      INCLUDE 'LINS.F'
      INCLUDE 'STRS.F'
      INCLUDE 'SYMS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,ENTITY        ! -> SYM -> STR
     = ,SCOLS        ! NUMBER OF COLUMS IN THE FA-TABLE
     = ,START   ! -> 1ST CHARACTER OF THE SYMBOL IN 'LINE'
     = ,STATE        ! CURRENT STATE OF THE FINITE AUTOMATON
     = ,SYMBOL  ! THE SYMBOL-CLASS, IDENT, NUMBER ...
      INTEGER*2 SINIT,SA1QU,SNUMB,SIDEN,SA2QU,SCOMT
      DATA    SINIT,SA1QU,SNUMB,SIDEN,SA2QU,SCOMT
     =       /  0  ,  8  ,  16 ,  24 ,  32 ,  40 / ! STATE * 8, EOST->8
        STATE = SINIT
        GOTO 1901
1800  CONTINUE
1801  CONTINUE
1802  CONTINUE
1803  CONTINUE
1804  CONTINUE
1805  CONTINUE
1400  CONTINUE
1401  CONTINUE
1405  CONTINUE
1501  CONTINUE
1502  CONTINUE
1503  CONTINUE
1505  CONTINUE
1601  CONTINUE
1603  CONTINUE
1605  CONTINUE
1705  CONTINUE
1101  CONTINUE
1902  CONTINUE
        CALL ZZCI (LINE,FLIN,SC)
        FLIN = FLIN + 1
        SC = CODTAB(SC+1)
1901  CONTINUE
        I = STATE + SC
C       SPEC EOFL EOLN BLAN DIGT LETR QUOT EOST
        GOTO
     = (1100,1200,1300,1400,1500,1600,1700,1800 ! WHEN CALLED
     = ,1101,1201,1301,1401,1501,1601,1701,1801 ! AFTER 1ST QUOTE
     = ,1102,1202,1302,1402,1502,1602,1702,1802 ! IN NUMBER
     = ,1103,1203,1303,1403,1503,1603,1703,1803 ! IN IDENTIFIER
     = ,1104,1204,1304,1404,1504,1604,1704,1804 ! AFTER 2ND QUOTE
     = ,1105,1205,1305,1405,1505,1605,1705,1805 ! IN COMMENT
     = ),I
1200  CONTINUE
        ! EOF
                IF (FLIN .GT. LIMARR) GOTO 12001
                  SYMBOL = EOFILE
                  ENTITY = SYMBOL
                GOTO 12002
12001           CONTINUE
                  FLIN = LIMARL
                  CALL CODGET ! (SC)
                  SYMBOL = EOSTMT
                  ENTITY = EOSTMT
12002           CONTINUE
                GOTO 1903
1201  CONTINUE
        ! ERS
                  CALL ASSERT(30,LINENO,FLIN)
                  SYMBOL = STRIN
                  GOTO 1904
1402  CONTINUE
1202  CONTINUE
1602  CONTINUE
1702  CONTINUE
1102  CONTINUE
        ! NUM
                  SYMBOL = NUMBER
                  GOTO 1904
1403  CONTINUE
1203  CONTINUE
1703  CONTINUE
1103  CONTINUE
        ! IDE
                  SYMBOL = IDENT
                  GOTO 1904
1404  CONTINUE
1504  CONTINUE
1204  CONTINUE
1604  CONTINUE
1104  CONTINUE
        ! STR
                  SYMBOL = STRIN
                  GOTO 1904
1205  CONTINUE
        ! ERC
                  CALL ASSERT(29,LINENO,FLIN)
                IF (FLIN .GT. LIMARR) GOTO 12051
                  SYMBOL = EOFILE
                  ENTITY = SYMBOL
                GOTO 12052
12051           CONTINUE
                  FLIN = LIMARL
                  CALL CODGET ! (SC)
                  SYMBOL = EOSTMT
                  ENTITY = EOSTMT
12052           CONTINUE
                  GOTO 1903
1300  CONTINUE
1304  CONTINUE
1305  CONTINUE
        ! LIN
                  CALL LINEXT
                  GOTO 1902
1301  CONTINUE
1302  CONTINUE
1303  CONTINUE
        ! SWA
                  CALL HAPSE(LINE,START,FLIN - 2)
                  CALL LINEXT
                  START = FLIN
                  GOTO 1902
1500  CONTINUE
        ! FM1
                  START = FLIN - 1
                  STATE = SNUMB
                  GOTO 1902!
1600  CONTINUE
        ! FM1
                  START = FLIN - 1
                  STATE = SIDEN
                  GOTO 1902!
1700  CONTINUE
        ! F0
                  START = FLIN
                  STATE = SA1QU
                  GOTO 1902!
1701  CONTINUE
        ! APS
                  CALL HAPSE(LINE,START,FLIN - 2)
                  START = FLIN ! IGNORE 2ND QUOTE
                  STATE = SA2QU
                  GOTO 1902!
1704  CONTINUE
                  STATE = SA1QU
                  GOTO 1902!
1100  CONTINUE
        ! SPE
                  CALL SPEMAP(ENTITY)
                  CALL CODGET ! (SC)
                  IF (ENTITY .NE. SCOBEG) GOTO 1
                    STATE = SCOMT
                    GOTO 1901!
1                 CONTINUE
                  SYMBOL = ENTITY
                  GOTO 1903
1105  CONTINUE
        ! SPE
                  CALL SPEMAP(ENTITY)
                  CALL CODGET ! (SC)
                  IF (ENTITY .NE. SCOEND) GOTO 2
                    STATE = SINIT
2                 CONTINUE
                  GOTO 1901
C
1904  CONTINUE
        CALL HAPSE(LINE,START,FLIN - 2)
        CALL HAMAP(ENTITY)
1903  CONTINUE
        IF(PARASK('SCAN',1,4,0) .EQ. 0) GOTO 2000
          CALL ZZWC('SCAN:',1,5,0)
          CALL ZZWI(SYMBOL,5)
          CALL PUTSYM(ENTITY)
2000    CONTINUE
        RETURN ! SCAN
      END
