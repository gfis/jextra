      BLOCK DATA BLODAT
C     FOR THE EXTRA PARSER-GENERATOR
C     2005-03-29: demingle MEMSETS, PRESEMS, STASTRS
C     GF 19.07.1980: 'SYMPRO' INIT('PROHIB') FOR 'TRACCU', 'TRATTR'
C
      INCLUDE 'PARS.F'
      INCLUDE 'BUCS.F'
      INCLUDE 'CODS.F'
      INCLUDE 'DIRS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'LINS.F'
      INCLUDE 'MEMS.F'
      INCLUDE 'PRES.F'
      INCLUDE 'PRIS.F'
      INCLUDE 'PROS.F'
      INCLUDE 'SEMS.F'
      INCLUDE 'SETS.F'
      INCLUDE 'SLOS.F'
      INTEGER*2 DIR(XXDIRH)
CEQU  EQUIVALENCE (SLOT(1,1),DIR(1))
      INCLUDE 'SPAS.F'
C----------------------------------------------------------------
      INCLUDE 'SPES.F'
      INCLUDE 'STAS.F' 
      INCLUDE 'STAT1.F' ! STATICS FOR 'SEMANT'
C--------------------------------------------
      INTEGER*2 TRAFS(15)
      COMMON /STAT2/ TRAFS ! STATICS FOR 'TRAFOR'
      INCLUDE 'STKS.F'
      INCLUDE 'STRS.F'
      INCLUDE 'SYMS.F'
      INCLUDE 'TARS.F'
      INCLUDE 'TRAS.F'
      INCLUDE 'TRES.F'
C
C-------------------------------------------------------------
C     PARS
      DATA UPRI /XXUPRI/
      DATA ULIN /5/ ! /XXULIN/ 2005-04-07
      DATA UTAR /XXUTAR/
      DATA UPAR /XXUPAR/
      DATA UASS /XXUASS/
      DATA PARHIB /XXPARH/
      DATA PARLAS /1/
      DATA PARME(1) /1/
      DATA PARVAL(1) /0/
      DATA PARM(1,1) /'X'/
C----------------------------------------------------------------
C     BUCS
      DATA BUCHIB /XXBUCH/
      DATA BUCKET /XXBUCH * XXSYMH/
C------------------------------------------------------------
C     DIRS
      DATA UDIR/XXUDIR/
      DATA DIRHIB /XXDIRH/
C-----------------------------------------------------------
C     ITES
C     DATA ITEACT(XXITEH) /4/ ! ERROR
      DATA ITESYM(XXITEH) /XXSYMH/ ! FOR MERGING IN 'LACOPY'
      DATA ITEHIB/XXITEH/
      DATA SHIFT,REDUCE,ACCEPT,ERROR
     =     / 1  ,  2   ,  3   ,  4 /
C-------------------------------------------------------------
C     LINS
      DATA LINENO/0/
C-----------------------------------------------------------
C     MEMS
      DATA MEM /XXMEMH * 0/
      DATA FMEM /2/
      DATA MEMHIB/XXMEMH/
      DATA EOP/1/
C-----------------------------------------------------------
C     PRES
      DATA PREHIB/XXPREH/
C-------------------------------------------------------------
C     PRIS
      DATA FPRI /2/ ! POSITION 1 = CARRIAGE CONTROL
      INTEGER*2 XXPRIH2
      PARAMETER (XXPRIH2=XXPRIH*2-1)
      DATA PRIHIB /XXPRIH2/
      DATA PRIBUF /XXPRIH * '  '/
C-----------------------------------------------------------
C     PROS
      DATA PROHIB/XXPROH/
C-----------------------------------------------------------
C     SEMS
      DATA SEMHIB/XXSEMH/
      DATA
     =  ACCO,ACIN,ACMA,ACTA  ! ACCUMULATOR
     = ,ATCO,ATIN,ATMA,SYAT  ! ATTRIBUTE
     = ,SOCO,REIN,UNCH,SOTA  ! SON, MEMBER
     = ,SYCO,SYIN,SYMA,SEPR  ! NEW SYMBOL
     = ,ACCU,ATTR,EOSY,EOS   ! MISCELLANEOUS
     = /   1,   2,   3,   4
     = ,   5,   6,   7,   8
     = ,   9,  10,  11,  12
     = ,  13,  14,  15,  16
     = ,  17,  18,  19,  20
     = /
      INTEGER*2 XXSEMH5
      PARAMETER (XXSEMH5=XXSEMH-5)
C               DESL DESU PNOSEM      FSEM
C                 |    |          |     |
C                 V    V          V     V
      DATA SEM /  0 ,  0 ,  11  , 20 ,  20 , XXSEMH5 *20/
      DATA SEMSYM /XXSEMH * 0/
      DATA PNOSEM /4/ ! -> EOS
      DATA FSEM   /5/ ! -> THEREAFTER
C-----------------------------------------------------------
C     SETS
      DATA SETHIB/XXSETH/
C-----------------------------------------------------------
C     SLOS
      DATA SLOFUL /XXSLOH * 0/
      DATA FSLO /1/
      DATA SLOHIB /XXSLOH/
C----------------------------------------------------------
C     SPAS
      DATA SPAHIB/XXSPAH/
C-----------------------------------------------------------
C     STAS
      DATA STAITE /XXSTAH * 0/
      DATA FNUM /2/ ! = 'FSTA' AT BEGINNING
      DATA STAHIB/XXSTAH/
C----------------------------------------------------------
C     STAT1
      DATA DESL /1/
      DATA BUPROD /0/
      DATA INGRAM /1/ ! START WITH PARSING GRAMMAR
      DATA NEWNUM /7952/
C-----------------------------------------------------------
C     STKS
      DATA STKHIB/XXSTKH/
C-----------------------------------------------------------
C     STRS
      INTEGER*2 XXSTRH2
      PARAMETER (XXSTRH2=2*XXSTRH)
      DATA STRHIB/XXSTRH2/
      DATA FSTR /2/
C-----------------------------------------------------------
C     SYMS
      DATA FSYM /2/
      DATA SYMPOS(1) /1/
CEND  DATA SYMEND(1) /1/
      DATA SYMHIB/XXSYMH/
      DATA SYMPRO /XXSYMH * XXPROH/
      DATA SYMPOS(2) /2/ ! FOR 'HAMAP', 'HAPSE': SYMPOS(FSYM)=FSTR
CEND  DATA SYMEND(2) /2/ ! FOR 'HAMAP', 'HAPSE': SYMPOS(FSYM)=FSTR
C-------------------------------------------------------------
C     TARS
      DATA FTAR /1/ ! POSITION 1 = CARRIAGE CONTROL
      INTEGER*2 XXTARH2
      PARAMETER (XXTARH2=XXTARH*2-1)
      DATA TARHIB /XXTARH2/
      DATA TARBUF /XXTARH * '  '/
C-----------------------------------------------------------
C     TRAS
      DATA TRAHIB/XXTRAH/
      DATA TVOID,TKEYW,TSPEC,TCALL,TCOMT
     =    ,TGOTO,TIDEN,TNUMB,TSTRI
     =    /    1,    2,    3,    4,    5
     =    ,    6,    7,    8,    9
     =    /
      DATA TRASYM/XXTRAH * 0/  ! (NOT PRINTED BY 'TRADUM')
C-------------------------------------------------------------
C     TRES
      DATA UTRE /XXUTRE/
      DATA FTRE /1/
      DATA TREHIB /XXTREH/
      DATA TRECNO /1/
C-------------------------------------------------------------
      END
