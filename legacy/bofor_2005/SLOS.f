C-----GF 26.07.1980---------------------------------------- S L O S
      INTEGER*2 FSLO,SLOHIB,SLOT(XXTREH,XXSLOH)
      INTEGER*2 SLOFUL(XXSLOH)
      COMMON /SLOS/
     =  FSLO    ! NEXT SLOT TO BE ALLOCATED
     = ,SLOHIB  ! NUMBER OF SLOTS
     = ,SLOT    ! FILL THE 'TRE'-RECORDS IN THIS MATRIX
     = ,SLOFUL  ! = 0 (TREREF) IF SLOT IS EMPTY (OCCUPIED)