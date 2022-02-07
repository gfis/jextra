        PROGRAM ZZCCTE
C       TEST OF BOFOR-RTS-ROUTINES 'ZZCC', 'ZZIC', 'ZZCI', 'ZZCR'
C       2022-02-07: from scratch for regression tests; *DR=112
C
        IMPLICIT NONE
        INTEGER*2 AHIB,AHIB2
        PARAMETER AHIB=32
        PARAMETER AHIB2=AHIB*2
        INTEGER*2 U5,U6,LS,LE,RS,RE,A(AHIB),I,SP2,IC,ASC0
        CHARACTER*2 CODE
        INTEGER*2 ZZCR
        DATA U5/5/
        DATA U6/6/
        DATA SP2/'  '/
        DATA ASC0/48/ ! '0', machine dependant
C
C       fill with spaces
        CODE = '  '
        DO 20 I=1,AHIB
          A(I) = SP2
20      CONTINUE
        WRITE (U6,70) A
70      FORMAT(' |', 32A2, '|')

C       insert ten's positions with ZZIC
        DO 21 I=10,AHIB2,10
          CALL ZZIC(ASC0 + I / 10, A,I)
21      CONTINUE
        WRITE (U6,70) A
C
C       insert one's positions 
        DO 22 I=1,AHIB2
          CALL ZZIC(ASC0 + MOD(I,10) , A,I)
22      CONTINUE
        WRITE (U6,70) A
C
C       write a word with padding
        CALL ZZCC('pad',1,3, A,1,AHIB)
        WRITE (U6,70) A
C
C       clear again
        DO 23 I=1,AHIB
          A(I) = SP2
23      CONTINUE
C
C       write a word
        CALL ZZCC('truncate',1,8, A,1,8)
C       write a word with truncation
        CALL ZZCC('truncate',1,8, A,21,24)
        WRITE (U6,70) A
C
C       comparisions
        WRITE (U6,71) ZZCR(A,1,4,     A,21,24)
71      FORMAT(' ',       'A(1:4) <?> A(21:24): ', I2);
        WRITE (U6,72) ZZCR(A,1,8,     A,21,24)
72      FORMAT(' ',       'A(1:8) <?> A(21:24): ', I2);
        WRITE (U6,73) ZZCR(A,1,3,     A,21,24)
73      FORMAT(' ',       'A(1:3) <?> A(21:24): ', I2);

        STOP
        END
