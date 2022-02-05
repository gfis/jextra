        PROGRAM ZZCRTE
C       TEST OF BOFOR-RTS-ROUTINES 'ZZCC', 'ZZIC', 'ZZCI', 'ZZCR'
C       GF 18.10.2002 write to separate unit U6
C       GF 09.07.1980
C       the ouput is as follows:
C-----------------------
C testing ZZCC
C ABCDEFGHIJKLMNOP
C IJKLMNOPABCDEFGH
C BCKLMNOBCDE    H
C testing ZZCI
C A( 1):  65
C A( 2):  66
C A( 3):  67
C A( 4):  68
C A( 5):  69
C A( 6):  70
C A( 7):  71
C A( 8):  72
C testing ZZIC
C 65 A               
C 66 AB              
C 67 ABC             
C 68 ABCD            
C 69 ABCDE           
C 70 ABCDEF          
C 71 ABCDEFG         
C 72 ABCDEFGH        
C testing ZZCR
C = 0
C <-1
C <-1
C > 1
C = 0
C > 1
C <-1
C-----------------------
        INTEGER*2 U5,U6,LS,LE,RS,RE,I,A(40),T(40)
        CHARACTER*2 CODE
        INTEGER*2 ZZCR
        DATA U5/5/
        DATA U6/6/
C
11      FORMAT(1X,40A2)
C
        WRITE (U6,12)
12        FORMAT (' testing ZZCC')
C
        CALL ZZCC ('ABCDEFGHIJKLMNOP',1,16,  A,1,16)
        WRITE (U6,11) (A(I),I=1,8)
C
        CALL ZZCC (A,1,8,  T,9,16)                    
        CALL ZZCC (A,9,16, T,1,8 )                    
        WRITE (U6,11) (T(I),I=1,8)
C
        CALL ZZCC (A,2,5,  T,8,15)                    
        CALL ZZCC (A,2,5,  T,1,2 )                    
        WRITE (U6,11) (T(I),I=1,8)
C
        WRITE (U6,22)
22        FORMAT (' testing ZZCI')
C
        CALL ZZCC ('ABCDEFGHIJKLMNOP',1,16,  A,1,16)
        DO 24 LS=1,8
          CALL ZZCI (A,LS,  I)                            
          WRITE (U6,23) LS, I
23          FORMAT(1X, 'A(',I2, '): ', I3)
24      CONTINUE         
C
        WRITE (U6,32)
32        FORMAT (' testing ZZIC')
C
        CALL ZZCC ('                ',1,16,  A,1,16)
        DO 34 LS=1,8 
          I = 64 + LS
          CALL ZZIC (I, A,LS)                            
          WRITE (U6,33) I, (A(RS),RS=1,8)
33        FORMAT (1X, I2, 1X, 40A2)
34      CONTINUE         
C
        WRITE (U6,41)
41        FORMAT (' testing ZZCR')
        CALL ZZCC ('ABCDEFGHIJKLMNOP',1,16,  A,1,16)
44      FORMAT (1X, A1, 1X, I2)
        WRITE (U6, 44) '=', ZZCR(A,1,4, A,1,4)
        WRITE (U6, 44) '<', ZZCR(A,1,4, A,2,4)
        WRITE (U6, 44) '<', ZZCR(A,1,3, A,1,4)
        WRITE (U6, 44) '>', ZZCR(A,1,4, A,1,3)
        WRITE (U6, 44) '=', ZZCR(A,1,0, A,1,0)
        WRITE (U6, 44) '>', ZZCR(A,1,1, A,1,0)
        WRITE (U6, 44) '<', ZZCR(A,1,0, A,1,1)
99      STOP
        END
