      SUBROUTINE PARADD
C     READ THE SYSTEM PARAMETERS FROM FILE parms.dat
C     SEE ALSO: 'PAROLD'
C     2022-02-05: OPEN statement for gfortran
C     GF 14.03.1981: NEW VERSION FOR '0 0' (EOD) IN THE 1ST LINE
C     GF 12.07.1980
C
      INCLUDE 'PARS.f'
      INTEGER*2 PARASK
      INTEGER*2 I,J
15    CONTINUE
      I = 1 ! ASSUME 'PARLAS=0'
      OPEN (UNIT=UPAR,file='parms.dat',status='OLD'
     = ,ERR=2)
1     CONTINUE
      IF (I .LE. PARHIB) GOTO 4
        CALL ASSERT (9,PARHIB,0)
C         MORE THAN @ PARAMETERS
        GOTO 2
4     CONTINUE
        READ(UPAR,3,ERR=2,END=2)
     =    PARVAL(I),PARME(I),(PARM(J,I),J=1,3)
3         FORMAT(I5,I2,1X,10A2)
      IF (PARME(I) .EQ. 0) GOTO 2
        I = I + 1
        GOTO 1
2     CONTINUE
      PARLAS = I - 1
      CLOSE (UNIT=UPAR)
      RETURN
      END
