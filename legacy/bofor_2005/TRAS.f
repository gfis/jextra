C-------GF 28.08.1980------------------------------ T R A S
C     2005-03-29: demingle SETTRAS
C      STRUCTURE TREE, INTERNAL LISTS
      INTEGER*2 FTRA,TRAHIB
      INTEGER*2 TRA(XXTRAH)
        INTEGER*2 TRASYM(XXTRAH)
        INTEGER*2 TRAENT(XXTRAH)
      INTEGER*2 TVOID,TKEYW,TSPEC,TCALL,TCOMT
      INTEGER*2 TGOTO,TIDEN,TNUMB,TSTRI
      COMMON /TRAS/
     =  FTRA      ! -> LAST ELEMENT OF FREE RING
     = ,TRAHIB      ! HIGH BOUND OF 'TRA'
      COMMON /TRAS/
     =  TVOID     ! 1 IGNORE ACCU
     = ,TKEYW     ! 2 KEYWORD
     = ,TSPEC   ! 3 PUNCTUATION CHARACTERS
     = ,TCALL   ! 4 COMBINED SYMBOL, PAGED CONTENTS
     = ,TCOMT     ! 5 COMMENT
     = ,TGOTO   ! 6 END OF COMBINED SYMBOL
     = ,TIDEN   ! 7 IDENTIFIER
     = ,TNUMB   ! 8 NUMBER
     = ,TSTRI   ! 9 STRIN
      COMMON /TRAS/     !-SYMBOL--COMB.SY--ACCU/ATTR--
     =  TRA             !  RBRO     RBRO     FIRST
     = ,TRASYM          !  CLASS   SYMBOL   DEEPER
     = ,TRAENT          !  ENTIT   FILE-P   0/ATTR1
C               !----------------------------
