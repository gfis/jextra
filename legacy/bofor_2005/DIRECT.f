      SUBROUTINE DIRECT (CODE)
C     ACCESS TO THE DIRECT-FILE 'UDIR'
C     2022-02-05: OPEN statement for gfortran
C     2005-03-29: demingle MEMSETS, STASTRS
C     GF 24.08.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'BUCS.f'
      INCLUDE 'DIRS.f'
      INCLUDE 'SEMS.f'
      INCLUDE 'STAS.f'
      INCLUDE 'STRS.f'
      INCLUDE 'SYMS.f'
      INCLUDE 'TRES.f'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,CODE    ! 1: READ OVL, 2: WRITE OVL, 3: READ ALL, 4: WRITE ALL
     =          ! 5: OPEN, 6: CLOSE
     = ,LENGTH  ! FOR TRANSMIT "ALL", SEE BELOW
      COMMON /STAT3/ LENGTH
C
      SYMLNK(1) = 1 ! SYMBOLS ARE PRINTABLE
      IF (PARASK('DIRECT',1,6,0) .NE. 0)
     =  CALL ASSERT (155,FDIR,LENGTH)
      RETURN
C=============================================================
      FDIR = STAHIB
      IF (CODE .GE. 5) GOTO 4
      IF (CODE .LE. 2) GOTO 4
C       READ/WRITE ALL: DETERMINE 'LENGTH' BY A TRICK
C       DEC-TKB ALLOCATES COMMONS IN ALPHABETICAL ORDER
C       'BUCHIB' IS FIRST, 'TRE(TREHIB)' IS LAST
        TRE(TREHIB-1) = -29647
        TRE(TREHIB)   = -29647
        DO 1 I = 1,32766 ! IF THERE WERE MORE SPACE FOR COMMONS - ?
C                THE EXTRA-IMPLEMENTOR WOULD HAVE BEEN LUCKY !!
          IF (BUCKET(I) .NE. -29647 .OR. BUCKET(I-1) .NE. -29647) GOTO 2
            LENGTH = I
            GOTO 3
2         CONTINUE
1       CONTINUE
3       CONTINUE
4     CONTINUE
      GOTO (101,102,103,104,105,106,107),CODE
C----------------------------------------------------------------
101   CONTINUE
      CALL DIRREA (SYMPOS,SYMHIB)
      CALL DIRREA (SYMLNK,SYMHIB)
      CALL DIRREA (SEM   ,2*SEMHIB) ! 'SEMSYM' IS ADJACENT
      CALL DIRREA (STRNG ,STRHIB/2   )
      SYMLNK(1) = 1 ! SYMBOLS ARE PRINTABLE
      GOTO 99
C----------------------------------------------------------------
102   CONTINUE
      CALL DIRWRI (SYMPOS,SYMHIB)
      CALL DIRWRI (SYMLNK,SYMHIB)
      CALL DIRWRI (SEM   ,2*SEMHIB) ! 'SEMSYM' IS ADJACENT
      CALL DIRWRI (STRNG ,STRHIB/2   )
      SYMLNK(1) = 0 ! SYMBOLS ARE NOT PRINTABLE
      GOTO 99
C----------------------------------------------------------------
103   CONTINUE
      CALL DIRREA (BUCKET,LENGTH)
      IF (PARASK('DIRECT',1,6,0) .NE. 0)
     =  CALL ASSERT (157,LENGTH,0)
      GOTO 99
C----------------------------------------------------------------
104   CONTINUE
      CALL DIRWRI (BUCKET,LENGTH)
      GOTO 99
C----------------------------------------------------------------
105   CONTINUE
      DIRHIB = PARASK ('DIRHIB',1,6,256)
      IF (PARASK('DAIO',1,4,1) .NE. 0) GOTO 1051
      OPEN (UNIT=UDIR,file='DIRECT.DAT',status='UNKNOWN'
     = ,ACCESS='DIRECT',recl=DIRHIB/2)
      GOTO 99
1051  CONTINUE ! WITH 'DAIO'
      OPEN (UNIT=UDIR,file='DIRECT.DAT',status='UNKNOWN'
     = ,ACCESS='DIRECT',recl=DIRHIB/2)
      GOTO 99
C----------------------------------------------------------------
106   CONTINUE
      CLOSE (UNIT=UDIR)
      GOTO 99
C----------------------------------------------------------------
107   CONTINUE
C----------------------------------------------------------------
99    CONTINUE
      RETURN
      END
