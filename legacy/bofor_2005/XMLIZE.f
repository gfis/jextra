      SUBROUTINE XML0 (SUBRN, SUBRS, SUBRE)
C     TRACE OUTPUT VIA XML ELEMENTS
C     2005-05-06 GEORG FISCHER
C
      INCLUDE 'PARS.f'
      CHARACTER*16 SUBRN ! NAME OF THE SUBROUTINE
      INTEGER*2 PARASK
     = ,SUBRS     ! FIRST POSITION IN 'SUBR'
     = ,SUBRE     ! LAST  POSITION IN 'SUBR'
     = ,A1        ! ATTRIBUTE NO 1
     = ,A2        ! ATTRIBUTE NO 2
     = ,A3        ! ATTRIBUTE NO 3
     = ,A4        ! ATTRIBUTE NO 4
     = ,A5        ! ATTRIBUTE NO 5
     = ,A6        ! ATTRIBUTE NO 6
C
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' />', 1, 3, 0)
      CALL ZZWS (0)
      RETURN
C---------------------------------------------------------------
      ENTRY XML1 (SUBRN, SUBRS, SUBRE, A1)
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' val="', 1, 6, 0)
      CALL ZZWI (A1, 4)
      CALL ZZWC ('" />', 1, 4, 0)
      CALL ZZWS (0)
      RETURN
C----------------------------------------------------------------
      ENTRY XML2 (SUBRN, SUBRS, SUBRE, A1, A2)
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' val="', 1, 6, 0)
      CALL ZZWI (A1, 4)
      CALL ZZWI (A2, 4)
      CALL ZZWC ('" />', 1, 4, 0)
      CALL ZZWS (0)
      RETURN
C----------------------------------------------------------------
      ENTRY XML3 (SUBRN, SUBRS, SUBRE, A1, A2, A3)
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' val="', 1, 6, 0)
      CALL ZZWI (A1, 4)
      CALL ZZWI (A2, 4)
      CALL ZZWI (A3, 4)
      CALL ZZWC ('" />', 1, 4, 0)
      CALL ZZWS (0)
      RETURN        
C----------------------------------------------------------------
      ENTRY XML4 (SUBRN, SUBRS, SUBRE, A1, A2, A3, A4)
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' val="', 1, 6, 0)
      CALL ZZWI (A1, 4)
      CALL ZZWI (A2, 4)
      CALL ZZWI (A3, 4)
      CALL ZZWI (A4, 4)
      CALL ZZWC ('" />', 1, 4, 0)
      CALL ZZWS (0)
      RETURN
C----------------------------------------------------------------
      ENTRY XML5 (SUBRN, SUBRS, SUBRE, A1, A2, A3, A4, A5)
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' val="', 1, 6, 0)
      CALL ZZWI (A1, 4)
      CALL ZZWI (A2, 4)
      CALL ZZWI (A3, 4)
      CALL ZZWI (A4, 4)
      CALL ZZWI (A5, 4)
      CALL ZZWC ('" />', 1, 4, 0)
      CALL ZZWS (0)
      RETURN        
C----------------------------------------------------------------
      ENTRY XML6 (SUBRN, SUBRS, SUBRE, A1, A2, A3, A4, A5, A6)
      IF (PARASK(SUBRN, SUBRS, SUBRE, 0) .EQ. 0) RETURN
      CALL ZZWC ('<',1,1,0)
      CALL ZZWC (SUBRN, SUBRS, SUBRE, 0)
      CALL ZZWC (' val="', 1, 6, 0)
      CALL ZZWI (A1, 4)
      CALL ZZWI (A2, 4)
      CALL ZZWI (A3, 4)
      CALL ZZWI (A4, 4)
      CALL ZZWI (A5, 4)
      CALL ZZWI (A6, 4)
      CALL ZZWC ('" />', 1, 4, 0)
      CALL ZZWS (0)
      RETURN        
C----------------------------------------------------------------------
      END
