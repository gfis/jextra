        PROGRAM ZZCCTE
C       TEST OF BOFOR-RTS-ROUTINES 'ZZCC', 'ZZIC', 'ZZCI', 'ZZCR'
C       GF 11.10.2002 write to separate unit U6
C       GF 09.07.1980
C
        INTEGER*2 U5,U6,LS,LE,RS,RE,A(35)
        CHARACTER*2 CODE
        INTEGER*2 ZZCR
        DATA U5/5/
        DATA U6/6/
C
        WRITE (U6,11)
11      FORMAT(' TYPE CODE(A2),START,END,START,END(4I2),TEXT(..A1)')
1       READ (U5,2,END=99,ERR=1) CODE,LS,LE,RS,RE,A
2       FORMAT(A2,4I2,35A2)
C
        IF(CODE .NE. 'CC') GOTO 3
          CALL ZZCC (A,LS,LE,A,RS,RE)
          WRITE (U6,4) A
4         FORMAT(' CC:       ',35A2)
          GOTO 1
C
3       CONTINUE
        IF(CODE .NE. 'IC') GOTO 5
          CALL ZZIC(LS,A,LE)
          WRITE (U6,6) A
6         FORMAT(' IC: ',35A2)
          GOTO 1
C
5       CONTINUE
        IF(CODE .NE. 'CI') GOTO 7
          CALL ZZCI(A,LS,LE)
          WRITE(U6,8) LE
8         FORMAT(' CI: ',I5)
          GOTO 1
C
7       CONTINUE
          I = ZZCR(A,LS,LE,A,RS,RE)
          WRITE(U6,10) I
10        FORMAT(' CR: ',I5)
          GOTO 1
99      STOP
        END
