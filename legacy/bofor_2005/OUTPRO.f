      SUBROUTINE OUTPRO (PROD)
C     PRINT A PRODUCTION OF THE GRAMMAR
C     GF 11.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'ITES.f'
      INCLUDE 'PROS.f'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,PROD      ! THE PRODUCTION TO BE PRINTED
     = ,ITEM      ! THE ITEM TO BE PRINTED
C
C     HEADER
      CALL ZZWC ('      PROD ',1,11,0)
      CALL ZZWI (PROD,4)
      CALL ZZWC (', SEM: ',1,7,0)
      CALL ZZWI (PROSEM(PROD),5)
      CALL OUTMAP (PROD,0) ! PRINT THE MARKED PRODUCTION
      CALL ZZWS (0)
      CALL ZZWC (' => ',1,4,0)
C
C     SEMANTIC ACTIONS
      I = PROSEM(PROD)
40    CONTINUE
        CALL OUTSEM(I)
      IF (I .NE. 0) GOTO 40
      CALL ZZWS (0)
C
C     MEMBERS AND 'MEMNUC'-LISTS
      IF (PARASK ('OUTMEM',1,6,0) .EQ. 0) RETURN
      I = PROMON(PROD)
44    IF(I .GT. PROMON(PROD) + PROLNG(PROD) - 1) GOTO 45
        CALL OUTMEM(I)
        I = I + 1
      GOTO 44
45    CONTINUE
      RETURN ! OUTPRO
C------------------------------------------------------------------
      ENTRY OUTITE (ITEM)
C     PRINT AN ITEM OF THE PARSING TABLE
C     GF 11.07.1980
C
      CALL ZZWI (ITEM,5)
      CALL ZZWC (': ',1,2,0)
      CALL PUTSYM (ITESYM(ITEM))
      CALL ZZWT (30)
      CALL ZZWC ('.',1,1,0)
      CALL ZZWI (ITEPOS(ITEM),5)
      CALL PUTACT (ITEM)
      CALL ZZWS (0)
      RETURN ! OUTITE
      END
