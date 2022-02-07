      SUBROUTINE ZZTC(CHARN,CHARS,CHARE,WIDTH)
C     2022-02-07: copied from ZZWC
C     write characters CHARN(CHARS:CHARE) with WIDTH to stream output,
C     and advance the pointer FTAR
C     WIDTH=0 implies source field length
C     WRITE CHARACTERS TO STREAM-OUTPUT
C
      INCLUDE 'PARS.f'
      INCLUDE 'TARS.f'
      INTEGER*2 CHARS,CHARE,CHARN(1),WIDTH
      INTEGER*2 LNG
C
      LNG = WIDTH
      IF (LNG .EQ. 0)
     =    LNG = CHARE - CHARS + 1
      CALL ZZTS(LNG)
      CALL ZZCC(CHARN,CHARS,CHARE,TARBUF,FTAR,FTAR + LNG)
      FTAR = FTAR + LNG
      RETURN
      END
