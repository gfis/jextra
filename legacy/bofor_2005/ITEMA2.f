      SUBROUTINE ITEMA2 (STATE,  I1,I2,GOT)
C     READ FOR UPDATE AND LOCK AN ITEM-SET
C     GF 20.08.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'STAS.f'
      INCLUDE 'PRIS.f'
      INTEGER*2 PARASK
      INTEGER*2 I1,I2
     = ,GOT     ! = 1 (0) IF THE STATE WAS (NOT) REALLY READ
     = ,STATE   ! ACCESS TO THIS ITEM-SET
C
      ITE(1) = STAITE(STATE)
      I1 = 1
      I2 = ITE(1)
      RETURN
C----
      IF (ITEPAG .GT. 1 .OR. ITEPAG .LT. 0)
     =  CALL ASSERT (152,STATE,STAITE(STATE))
      CALL ITEMA1 (STATE,  ITE(1),GOT)
      I1 = 1
      I2 = ITE(1)
      RETURN
      END
