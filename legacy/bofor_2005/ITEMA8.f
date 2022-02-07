      SUBROUTINE ITEMA8 (STATE,GOT)
C     UNLOCK AN ITEM-SET
C     GF 20.08.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'SLOS.f'
      INTEGER*2 DIR(XXDIRH)
      EQUIVALENCE (SLOT(1,1),DIR(1))
      INCLUDE 'DIRS.f'
      INCLUDE 'SPAS.f'
      INCLUDE 'STAS.f'
      INTEGER*2 PARASK
      INTEGER*2 I1,I2,WAS149
     = ,GOT     ! = 1 (0) IF THE STATE WAS (NOT) REALLY READ
     = ,LNG     ! 'LNG' ELEMENTS OF 'DIR' ARE FILLED
     = ,STATE   ! ACCESS TO THIS ITEM-SET
C
      RETURN
C------------
      WAS149 = 0
      IF (GOT .EQ. 0) GOTO 72
C       UNLOCK THE STATE
        IF (ITEPAG .LE. 0) GOTO 73
          LNG = 4
          I2 = STAITE(STATE)
81        IF(I2 .EQ. ITEHIB) GOTO 82
            IF (LNG .LE. DIRHIB) GOTO 83
              IF (WAS149 .NE. 0) GOTO 84
              CALL ASSERT (149,I2,STATE)
              WAS149 = 1
83          CONTINUE
            DIR(LNG-2) = ITESYM(I2)
            DIR(LNG-1) = ITEPOS(I2)
            DIR(LNG  ) = ITESUC(I2)
            LNG = LNG + 3
84          CONTINUE
            I1 = I2
            I2 = ITE(I2)
            IF (SPATES .GE. 0) GOTO 51
            ITE(I1) = FITE
            FITE = I1
51          CONTINUE
          GOTO 81
82        CONTINUE
          DIR(1) = LNG - 3
          IF (ITEPAG .GT. 1)
     =      CALL ASSERT (158,STATE,DIR(1))
          IF (SPATES .LT. 0) GOTO 52
          CALL SPAALL (STATE,STAITE(STATE),I1)
52        CONTINUE
          STAITE(STATE) = - ITEHIB - 1
        GOTO 74
73      CONTINUE
          IF (ITEPAG .LT. 0)
     =      CALL ASSERT (168,STATE,0)
          STAITE(STATE) = - ABS(STAITE(STATE))
74      CONTINUE
72    CONTINUE
      RETURN
      END
