      SUBROUTINE ZZWC(CHARN,CHARS,CHARE,WIDTH)
C     2022-02-07: comments
C     write characters CHARN(CHARS:CHARE) with WIDTH to stream output,
C     and advance the pointer FPRI
C     WIDTH=0 implies source field length
C
      INCLUDE 'PARS.F'
      INCLUDE 'PRIS.F'
      INTEGER*2 CHARS,CHARE,CHARN(1),WIDTH
      INTEGER*2 LNG
C
      LNG = WIDTH
      IF (LNG .EQ. 0)
     =    LNG = CHARE - CHARS + 1
      CALL ZZWS(LNG)
      CALL ZZCC(CHARN,CHARS,CHARE,PRIBUF,FPRI,FPRI + LNG)
      FPRI = FPRI + LNG
      RETURN
      END
