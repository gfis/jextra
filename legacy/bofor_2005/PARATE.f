      PROGRAM PARATE
C     Wrapper for PARADD
C     2022-02-07, Georg Fischer: remove loop

      INCLUDE 'PARS.f'
      INTEGER*2 PARASK
      CALL PARADD
70    FORMAT (1X, A6, ': ', I4)
      WRITE (UPRI,70) 'ASSERT', PARASK('ASSERT',1,6,333)
      WRITE (UPRI,70) 'SPATES', PARASK('SPATES',1,6,333)
      WRITE (UPRI,70) 'STASUC', PARASK('STASUC',1,6,333)
      RETURN
      END
