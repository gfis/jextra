      SUBROUTINE REORG
C     REORGANIZE ALL TABLES OF THE PARSER TO REFLECT THE CHANGED GRAMMAR
C     2005-03-29: demingle PRESEMS, STASTRS
C     GF 19.07.1980 'LREORG' INCORPORATED
C
      INCLUDE 'PARS.f'
      INCLUDE 'INFS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'MEMS.f'
      INCLUDE 'PRES.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SEMS.f'
      INCLUDE 'SPAS.f'
      INCLUDE 'STAS.f'
      INCLUDE 'STRS.f' 
      INCLUDE 'SYMS.f'
      INTEGER*2 PARASK
      INTEGER*2 ORD       ! FOR CALLS OF 'INSTAR', 'INSTOP'
     = ,CHANGE  ! = 1(0) WHILE SOMETHING CHANGED DURING 'SYMINS'
C
      CALL INSTAR('REORG ',6)
      ORD = 1
      CALL INFSTO(1,FSYM-1,SYMHIB)
      CALL INFSTO(2,FPRO-1,PROHIB)
      CALL INFSTO(3,FMEM-1,MEMHIB)
      CALL INFSTO(4,FSTR-1,STRHIB)
      CALL INFSTO (9,FSEM-1,SEMHIB)
      IF (PARASK('INFOUT',1,6,0) .NE. 0)
     =  CALL INFOUT
      CALL INSTAR('STASUC',ORD)
CAXI
      CALL LROPEN
      CHANGE = 1
1     IF(CHANGE .NE. 1) GOTO 2
        CHANGE = 0
        CALL SYMINS(CHANGE)
        CALL STASUC
        GOTO 1
2     CONTINUE ! WHILE CHANGE = 1
      CALL INSTOP(ORD)
      IF (PARASK('SETSIN',1,6,0) .NE. 0)
     =  CALL SETSIN
      IF (PARASK('IMDUMP',1,6,0) .NE. 0)
     =  CALL LRDUMP
C     IF (PARASK('ENBLOC',1,6,0) .NE. 0) GOTO 3
      ORD = ORD + 1
      CALL INSTAR('LAGAR ',ORD)
      CALL LAGAR
      CALL INSTOP(ORD)
      ORD = ORD + 1
      CALL INSTAR('STAGAR',ORD)
      CALL STAGAR
      CALL INSTOP(ORD)
      ORD = ORD + 1
      CALL INSTAR('LAGET ',ORD)
      CALL LAGET
      CALL INSTOP(ORD)
3     CONTINUE
      ORD = ORD + 1
      CALL INSTAR('LAPUT ',ORD)
      CALL LAPUT
      CALL INSTOP(ORD)
      ORD = ORD + 1
      CALL INFLIS(5,STAPRE,FSTA,STAHIB)
      CALL INFSTO(6,SPAHIB,ITEHIB)
      CALL INFLIS(7,PRE   ,FPRE,PREHIB)
C     NOW READ 'SYMPOS,SYMLNK,SEM,SEMSYM,STRNG' WHICH OVERLAY
C              'SYMRST, ---  ,PRE,PRESTA,(STAPRE,-RST,-SYM,-MAR)'
      CALL DIRECT (1) ! READ OVL
      IF (PARASK('CLEARE',1,6,0) .NE. 0)
     =  CALL CLEARE
      IF (PARASK('PUTCON',1,6,1) .NE. 0)
     =  CALL PUTCON
      IF (PARASK('DUMP',1,4,0) .NE. 0)
     =  CALL LRDUMP
      CALL INSTOP(6)
      CALL INFOUT
      RETURN ! REORG
      END
