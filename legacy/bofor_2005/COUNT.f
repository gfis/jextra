      SUBROUTINE COUNT (COUNTR)
C     RETURN VALUES 1,2,3,... FOR SUCCESSIVE CALLS IN 'COUNTR'
C
      INTEGER*2 COUNTR
     = ,FCOU ! INTERNAL NEXT VALUE
      COUNTR = FCOU
      FCOU = FCOU + 1
      RETURN ! COUNT
C---------------------------------------------------------
      ENTRY COUNTS
C
C     (RE-) SET THE INTERNAL COUNTER TO 1
      FCOU = 1
      RETURN ! COUNTS
      END
