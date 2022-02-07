     1    0        SUBROUTINE LINEXT 
     2    0  C     GET NEXT LINE FROM SOURCE-PROGRAM 
     3    0  C 
     4    0        INCLUDE 'PARS.f'
     5    0        INCLUDE 'LINS.f'
     6    0        INCLUDE 'PROS.f'
     7    0        INTEGER*2 ZZCR
     8    0        INTEGER*2 I 
     9    0       = ,MARRD2  ! RIGHT MARGIN IN WORDS 
    10    0       = ,BL6(3)  ! 6 BLANKS
    11    0        DATA BL6 /2H  ,2H  ,2H  / 
    12    0  C 
    13    0  10    CONTINUE ! LIREAD:
    14    0        READ (ULIN,1,END=2) LINE
    15    0  1     FORMAT(41A2)
    16    0  C     DETERMINE THE LAST WORD NOT CONTAINING BLANKS 
    17    0        MARRD2 = XXLINH + 1 
