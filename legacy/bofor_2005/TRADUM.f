      SUBROUTINE TRADUM (ACT)
C     DUMP 'TRA' DATA STRUCTURE
C     GF 19.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'TRAS.f'
      INTEGER*2 PARASK
      INTEGER*2 I,J
     = ,ACT     ! PRINT THIS ELEMENT OR, IF 'ACT=0', ALL ELEMENTS
     = ,TLOW,THIGH ! FOR THE LOOP ON THE ELEMENTS
      INCLUDE 'ENDS.f'
C
      IF (PARASK('TRADUV',1,6,1) .EQ. 0) GOTO 3
        J = FTRA
        DO 2 I = 1,TRAHIB
          TRASYM(J) = 0
          J = TRA(J)
          IF (J .EQ. FTRA) GOTO 3
2       CONTINUE
      CALL ASSERT (138,J,FTRA)
3     CONTINUE
      IF (ACT .EQ. 0) GOTO 6
        TLOW = ACT
        THIGH = ACT
      GOTO 7
6     CONTINUE
        TLOW = 2
        THIGH = TRAHIB
7     CONTINUE
      DO 1 I = TLOW,THIGH
        IF (TRASYM(I) .EQ. 0) GOTO 1
        CALL ZZWI (I,4)
        CALL ZZWC ('->',1,2,0)
        CALL ZZWI (TRA(I),4)
        CALL ZZWC (': ',1,2,0)
        CALL TRAO1 (I)
        CALL ZZWS (0)
1     CONTINUE
      RETURN
      END
