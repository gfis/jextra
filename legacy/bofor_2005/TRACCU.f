      SUBROUTINE TRACCU (ASEM,  SYMB,INC,A1,A2)
C     ACCESS TO AN ACCUMULATOR
C     GF 16.07.1980
C     GF 24.07.1980: SIMPLER VERSION
C
C     1 <= A1 < A2 <= TRAHIB
C     A1 -> A2
C     A2 -> INC: FOUND, OR A2 = TRAHIB: NOT FOUND
C     INSERT BETWEEN 'A1,A2', RESULTING ANCHOR IS IN 'TRA(1)'
C     ASEM += 1
C
      INCLUDE 'PARS.F'
      INCLUDE 'SEMS.F'
      INCLUDE 'SYMS.F'
      INCLUDE 'TRAS.F'
      INCLUDE 'ENDS.F'
      INTEGER*2 I
     = ,A1,A2   ! 2 SUCCEEDING POINTERS TO THE LIST OF ACCUS
     = ,ASEM    ! -> ACCU-ACTION IN 'SEM'
     = ,INC     ! THE INCARNATION OF 'SYMB'
     = ,SYMB    ! THE NAME OF THE ACCU
C
      SYMB = SEMSYM(ASEM)
      ASEM = ASEM + 1
      INC  = SEMSYM(ASEM)
      A1 = 1
      I = 1
      A2 = SYMMAR(SYMB)
      IF (A2 .EQ. 0) A2 = TRAHIB
      TRA(A1) = A2
1     IF(I .GE. INC .OR. A2 .EQ. TRAHIB) GOTO 2
        A1 = A2 ! LOOK AT NEXT IN THE LIST
        A2 = TRA(A1)
        I = I + 1 ! 'INC = 0' IS ALSO O.K.
      GOTO 1
2     CONTINUE
      RETURN ! TRACCU
      END
