C-------GF 08.11.1980------------------------------ P A R S
      IMPLICIT NONE
      INTEGER*2 XXBUCH,XXCODH,XXITEH,XXLINH,XXMEMH,XXPARH
      PARAMETER (XXBUCH=127)
      PARAMETER (XXCODH=128)
      PARAMETER (XXITEH=600)
      PARAMETER (XXLINH=41)
      PARAMETER (XXMEMH=1200)
      PARAMETER (XXPARH=30)
      INTEGER*2 XXPREH,XXPRIH,XXPROH,XXSEMH,XXSETH,XXSLOH
      PARAMETER (XXPREH=1400)
      PARAMETER (XXPRIH=61)
      PARAMETER (XXPROH=350)
      PARAMETER (XXSEMH=XXPREH)
      PARAMETER (XXSETH=XXMEMH)
      PARAMETER (XXSLOH=6)
      INTEGER*2 XXSPAH,XXSTAH,XXSTKH,XXSTRH,XXSYMH,XXTARH
      PARAMETER (XXSPAH=40)
      PARAMETER (XXSTAH=500)
      PARAMETER (XXSTKH=80)
      PARAMETER (XXSTRH=4*XXSTAH)
      PARAMETER (XXSYMH=500)
      PARAMETER (XXTARH=35)
      INTEGER*2 XXTRAH,XXTREH,XXDIRH,XXUDIR,XXUTRE,XXUPRI
      PARAMETER (XXTRAH=XXSETH/3)
      PARAMETER (XXTREH=40)
      PARAMETER (XXDIRH=(XXTREH+1)*(XXSLOH+1))
      PARAMETER (XXUDIR=7)
      PARAMETER (XXUTRE=6)
      PARAMETER (XXUPRI=6)
      INTEGER*2 XXULIN,XXUTAR,XXUPAR,XXUASS                  
      PARAMETER (XXULIN=4)
      PARAMETER (XXUTAR=3)
      PARAMETER (XXUPAR=2)
      PARAMETER (XXUASS=1)
      INTEGER*2 UPRI,ULIN,UTAR
      INTEGER*2 UPAR,UASS,UTRE
      INTEGER*2 UDIR
      INTEGER*2 PARVAL(XXPARH),PARME(XXPARH)
      INTEGER*2 PARM(3,XXPARH)
      INTEGER*2 PARLAS,PARHIB
      COMMON /AAAAAA/
     =  UPRI      ! XXUPRI: TEST-PRINTOUT TO THIS UNIT
     = ,ULIN      ! XXULIN: SOURCE-PROGRAM FROM HERE
     = ,UTAR      ! XXUTAR: TARGET-PROGRAM GOES HERE
     = ,UPAR      ! XXUPAR: READ PARAMETERS FROM THIS FILE
     = ,UASS      ! XXUASS: WRITE ASSERT-TEXTS TO THIS DIRECT-FILE
     = ,UTRE    ! XXUTRE: EXTERNAL TREE ON THIS UNIT
     = ,UDIR    ! XXUDIR: DIRECT-FILE FOR PARSING TABLE
     = ,PARLAS  ! ACTUAL NUMBER OF PARAMETERS
     = ,PARHIB  ! MAXIMAL ...
     = ,PARVAL  ! VALUES OF THE PARAMETERS
     = ,PARME   ! ENDING POSITION OF THE TEXTS
     = ,PARM      ! NAMES OF THE PARAMETERS
