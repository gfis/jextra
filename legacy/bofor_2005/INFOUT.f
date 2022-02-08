      SUBROUTINE INFOUT
C     INFORM ABOUT STORAGE AND CPU-TIME USED BY THE GENERATOR
C     2022-02-07: count + elapsed time statistics re-enabled, no H format, SECNDS -> CPU_TIME
C     GF 26.07.1980: WITH 'INFMAX'
C
      INCLUDE 'PARS.f'
      INCLUDE 'INFS.f'
      INTEGER*2 PARASK
      INTEGER*2 I
     = ,A(1)     ! POINTERS OF THE LINKED LIST
     = ,AHIB     ! HBOUND(A,1)
     = ,FA       ! -> 1ST FREE ELEMENT IN THE LIST
     = ,NAME(3)  ! FOR 'INSTAR'
     = ,NUM      ! ACCUMULATED NUMBER IN 'INFLIS'
     = ,ORD      ! STORE IN 'INFORM(ORD)'
     = ,VAL
     = ,VALMAX   ! PARAMETER OF 'INFSTO'
C
      WRITE(UPRI,2) (INFORM(I),INFMAX(I),I=1,9)
2       FORMAT(' -------------------------------------'
     = / ' STATISTICS FOR THE GRAMMAR'
     = /1X,I5,' (<',I5,')',' SYMBOLS'
     = /1X,I5,' (<',I5,')',' PRODUCTIONS'
     = /1X,I5,' (<',I5,')',' MEMBERS '
     = /1X,I5,' (<',I5,')',' CHARACTERS IN THE HASHTABLE'
     = /1X,I5,' (<',I5,')',' STATES'
     = /1X,I5,' (<',I5,')',' ITEMS'
     = /1X,I5,' (<',I5,')',' PREDECESSOR STATES'
     = /1X,I5,' (<',I5,')',' NUCLEUS ENTRIES'
     = /1X,I5,' (<',I5,')',' SEMANTIC ACTIONS'
     = /       ' -------------------------------------')
      WRITE(UPRI,1) (INFNUM(I),INFSUM(I),I=1,XXINFH)
1     FORMAT(' NUMBER OF CALLS AND ELAPSED SECONDS'
     = /1X,I5,' * STASUC: ',F7.3
     = /1X,I5,' * LAGAR : ',F7.3
     = /1X,I5,' * STAGAR: ',F7.3
     = /1X,I5,' * LAGET : ',F7.3
     = /1X,I5,' * LAPUT : ',F7.3
     = /1X,I5,' * XXXXX : ',F7.3
     = /1X,I5,' * REORG : ',F7.3
     = /1X,I5,' * XXXXX : ',F7.3
     = /1X,I5,' * XXXXX : ',F7.3
     = /1X,I5,' * XXXXX : ',F7.3
     = /1X,I5,' * XXXXX : ',F7.3
     = /1X,I5,' * XXXXX : ',F7.3
     =  )
      RETURN ! INFOUT
C-------------------------------------------------------------------
      ENTRY INFLIS (ORD,A,FA,AHIB)
C     STORE THE NUMBER OF OCCUPIED ELEMENTS
C
      NUM = AHIB - 1
      I = FA
3     IF(I .GE. AHIB) GOTO 4
        I = A(I)
        NUM = NUM - 1
        IF (NUM .GE. 0) GOTO 5 ! LIST HAS A CYCLE
          CALL ASSERT(18,AHIB,FA)
          RETURN
5       CONTINUE ! CYCLE
      GOTO 3
4     CONTINUE ! WHILE .GE. AHIB
      INFORM(ORD) = NUM
      INFMAX(ORD) = AHIB
      RETURN ! INFLIS
C-------------------------------------------------------------------
      ENTRY INFSTO (ORD,VAL,VALMAX)
C     STORE A VALUE
C
      INFORM(ORD) = VAL
      INFMAX(ORD) = VALMAX
      RETURN ! INFSTO
C-------------------------------------------------------------------
      ENTRY INSTAR (NAME,ORD)
C     START THE TIME-MEASUREMENT
      INFNUM(ORD) = INFNUM(ORD) + 1
      CALL CPU_TIME (INFBEG(ORD))
      IF (PARASK('INSTAR',1,6,1) .EQ. 0) RETURN
      CALL ZZWC(NAME,1,6,0)
      CALL ZZWS (0)
      RETURN ! INSTAR
C-------------------------------------------------------------------
      ENTRY INSTOP (ORD)
C     STOP THE TIME-MEASUREMENT
C
      CALL CPU_TIME (INFSUM(ORD))
      INFSUM(ORD) = INFSUM(ORD) - INFBEG(ORD)
      RETURN ! INSTOP
      END
