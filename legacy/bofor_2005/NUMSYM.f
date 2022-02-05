      SUBROUTINE NUMSYM (INT2,  IBUF,LNG)
C     CONVERT A NUMBER TO A CHARACTER-STRING
C     GF 23.08.1980
C
      INTEGER*2 INT2  ! THE NUMBER TO BE CONVERTED (-32768...32767)
     = ,DIGIT       ! CURRENT DIGIT EXTRACTED
     = ,DIV         ! A POWER OF 10
     = ,IBUF(4)     ! STORE THE STRING HERE
     = ,LNG         ! RESULTING LENGTH OF THE STRING
     = ,NUM         ! A COPY OF 'INT2'
     = ,ZERO        ! ASCII-CODE OF '0'
C
      NUM = INT2
      CALL ZZCI ('0',1,ZERO)
      LNG = 1
C
      IF (NUM .GE. 0) GOTO 10
        NUM = - NUM
        CALL ZZCC ('-',1,1,  IBUF,LNG,LNG)
        LNG = LNG + 1
10    CONTINUE
      DIV = 10000
11    IF (DIV .LE. NUM) GOTO 12
        DIV = DIV / 10
        GOTO 11
12    CONTINUE
C
13    CONTINUE
        DIGIT = NUM / DIV
        CALL ZZIC (DIGIT+ZERO,  IBUF,LNG)
        LNG = LNG + 1
      IF (DIV .EQ. 1) GOTO 14
        NUM = NUM - DIGIT * DIV
        DIV = DIV / 10
        GOTO 13
14    CONTINUE
      LNG = LNG - 1
      RETURN
      END
