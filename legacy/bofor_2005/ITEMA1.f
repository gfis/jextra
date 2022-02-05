      SUBROUTINE ITEMA1 (STATE,  I1,GOT)
C     READ AND LOCK AN ITEM-SET
C     GF 20.08.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'ITES.F'
      INCLUDE 'SLOS.F'
      INTEGER*2 DIR(XXDIRH)
      EQUIVALENCE (SLOT(1,1),DIR(1))
      INCLUDE 'DIRS.F'
      INCLUDE 'SPAS.F'
      INCLUDE 'STAS.F'
      INTEGER*2 PARASK
      INTEGER*2 I1,I2,I
     = ,GOT     ! = 1 (0) IF THE STATE WAS (NOT) REALLY READ
     = ,LNG     ! 'DIR' HAS 'LNG' SIGNIFICANT ELEMENTS
     = ,STATE   ! ACCESS TO THIS ITEM-SET
C
      I1 = STAITE(STATE)
      RETURN
C------------
      IF(STAITE(STATE) .GT. 0) GOTO 71
C       < 0 : FETCH THE STATE
        GOT = 1
        IF (STAITE(STATE) .GE. - ITEHIB) GOTO 73
C         = - ITEHIB - 1 : WAS PAGED
          IF (SPATES .LT. 0) GOTO 51
          CALL SPASEA (STATE)
          IF (STAITE(STATE) .GT. 0) GOTO 74
51        CONTINUE
          FDIR = STATE
          CALL DIRREA (DIR,DIRHIB)
          LNG = DIR(1)
          I2 = ITEHIB
          IF (ITEPAG .GT. 1)
     =      CALL ASSERT (151,STATE,LNG)
          I = 4
80        IF(I .GT. LNG) GOTO 81
            IF (FITE .LT. ITEHIB-1) GOTO 82
              IF (SPATES .LT. 0) GOTO 52
              CALL SPAFRE
              IF (I2 .NE. ITEHIB) ITE(I2) = FITE ! 'SPAFRE' BROKE CHAIN
              IF (FITE .LT. ITEHIB) GOTO 82
52            CONTINUE
              CALL ASSERT (150,STATE,FITE)
            GOTO 81
82          CONTINUE
            I2 = FITE
            FITE = ITE(FITE)
            ITESYM(I2) = DIR(I-2)
            ITEPOS(I2) = DIR(I-1)
            ITESUC(I2) = DIR(I  )
            IF (I .EQ. 4) STAITE(STATE) = I2
            I = I + 3
          GOTO 80
81        CONTINUE
          IF (I .EQ. 4) GOTO 79
C           STATE WAS NOT EMPTY
            ITE(I2) = ITEHIB
          GOTO 78
79        CONTINUE
C           STATE WAS EMPTY
            STAITE(STATE) = ITEHIB
78        CONTINUE
        GOTO 74
73      CONTINUE
          IF (ITEPAG .LT. 0)
     =      CALL ASSERT (161,STATE,0)
          STAITE(STATE) = - STAITE(STATE)
74      CONTINUE
      GOTO 72
71    CONTINUE
C       > 0 : STATE WAS ALREADY FETCHED
        GOT = 0
72    CONTINUE
C
      I1 = STAITE(STATE)
      RETURN
      END
