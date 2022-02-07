C-------GF 28.08.1980--------------------------------- P R E S
      INTEGER*2 FPRE,PREHIB
      INTEGER*2 PRE   (XXPREH),PRESTA(XXPREH)
      COMMON /PRES/
     =  FPRE     ! 1ST FREE PREDECESSOR
     = ,PREHIB   ! HIGH BOUND OF 'PRES'
      COMMON /PRES/
     =  PRE     ! -> NEXT PREDECESSOR
     = ,PRESTA  ! NUMBER OF THE PREDECESSOR-STATE
