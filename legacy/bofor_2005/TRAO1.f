      SUBROUTINE TRAO1 (I)
C     OUTPUT OF ONE SINGLE 'TRA'-ELEMENT
C     GF 24.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'TRAS.f'
      INTEGER*2 I,J
     = ,TMNEMO(18) ! MNEMO-CODES FOR THE CLASSES IN 'TRASYM'
      DATA TMNEMO
     = /'VO','ID',  'KE','YW',  'SP','EC',  'CA','LL'
     = ,'CO','MT',  'GO','TO',  'ID','EN',  'NU','MB'
     = ,'ST','RI'/
      INCLUDE 'ENDS.f'
C
      IF (TRASYM(I) .EQ. 0) GOTO 1
        J = TRASYM(I)
        CALL ZZWX(2)
        IF (J .GT. TSTRI .OR. J .LT. TVOID) GOTO 4
          CALL ZZWC(TMNEMO,4*J-3,4*J,5)
          CALL PUTSYM(TRAENT(I))
        GOTO 5
4       CONTINUE
          CALL PUTSYM (J)
          CALL ZZWI (TRAENT(I),4)
5       CONTINUE
1     CONTINUE
      RETURN
      END
