      SUBROUTINE DIRWRI (ARRAY,LNG)
C     WRITE DIRECT-FILE
C     GF 24.08.1980
C
      INCLUDE 'PARS.F'
      INCLUDE 'DIRS.F'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,LNG     ! NUMBER OF ELEMENTS IN 'ARRAY'
     = ,ARRAY(1) ! TRANSMIT FROM/TO THIS ARRAY
C
      HIGH = 0
1     CONTINUE
        HIGH = HIGH + DIRHIB
        IF (HIGH .LE. LNG) GOTO 6
C         HERE IS 'HIGH .GT. LNG' - DUPLICATE SOME ELEMENTS
          HIGH = LNG
6       CONTINUE
        LOW = HIGH - DIRHIB + 1
        IF (PARASK('DAIO',1,4,1) .NE. 0) GOTO 4
C       WRITE  (UDIR'FDIR) (ARRAY(I),I=LOW,HIGH)
        GOTO 5
4       CONTINUE
          DECB(1) = UDIR
          DECB(2) = 1
          FDIR4 = FDIR
          FDIR = FDIR + 1
          CALL DAWRTE (DECB,ARRAY(LOW),FDIR4,1)
          CALL DAWAIT (DECB)
          IF (DECB(5) .NE. 0) CALL ASSERT (9,DECB(5),0)
5       CONTINUE
        IF (PARASK('DIRWRI',1,6,0) .EQ. 0) GOTO 2
          CALL ASSERT (153,LOW,HIGH)
          DO 3 I=LOW,HIGH
            ARRAY(I) = 07952
3         CONTINUE
2       CONTINUE
      IF (HIGH .LT. LNG) GOTO 1
      RETURN
      END
