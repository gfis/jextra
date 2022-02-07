      SUBROUTINE SEMCLO (PROD)
C     CLOSE THE SEMANTIC ACTIONS FOR A PRODUCTION
C     GF 14.07.1980
C     GF 08.08.1980: ACCU-LOGIC WITH INCREMENT/DECREMENT
C
C     'SEMCLO' DOES THE FOLLOWING MAIN STEPS:
C
C     -- DELETE UNUSED MEMBERS (SONS) OF THE RIGHT SIDE
C          (A SON WAS USED IFF 'MEMNUC < 0')
C     -- CHANGE THE LAST 'SOCO' TO 'SOTA', AND SET ALL BUT
C          THE LAST NEGATIVE
C     -- INCREMENT ALL INCARNATIONS OF AN ACCU AFTER
C          AN 'ACMA' WITH 'INC = 0'
C     -- CHANGE THE LAST 'ACCO' TO 'ACTA', AND SET ALL BUT
C          THE LAST NEGATIVE (FOR A SPECIFIC ACCU)
C     -- MAKE ALL CODES POSITVE AGAIN
C
      INCLUDE 'PARS.f'
      INCLUDE 'MEMS.f'
      INCLUDE 'PROS.f'
      INCLUDE 'SEMS.f'
      INTEGER*2 PARASK
      INTEGER*2 I,J
     = ,INC    ! AN INCARNATION OF AN ACCU
     = ,PROD   ! CLOSE ACTIONS FOR THIS PRODUCTION
     = ,SYMB   ! A TEMPORARY SYMBOL
C-----------------------------------------------------------
C     -- CHANGE THE LAST 'SOCO' TO 'SOTA', AND SET ALL BUT
C          THE LAST NEGATIVE
C
      I = PROSEM(PROD)
      IF (SEM(I) .NE. UNCH) GOTO 26
C       IS 'UNCH'
        J = I + 1
        FSEM = FSEM - 1
        DO 28 I = J,FSEM
          SEM(I - 1) = SEM(I) ! MOVE 1 DOWNWARDS
          SEMSYM(I-1) = SEMSYM(I)
28      CONTINUE
        CALL SEMWRI (0,EOS,1) ! EOS,1 = UNCH
      GOTO 27
26    CONTINUE
        CALL SEMWRI (0,EOS,0) ! EOS,0 = DELETE REST OF THE TREE
      IF (PARASK('SEMCLO',1,6,1) .NE. 0) GOTO 27
      I = FSEM - 1
5     IF(I .LT. PROSEM(PROD)) GOTO 6
        IF (SEM(I) .NE. SOCO) GOTO 7
          SEM(I) = SOTA
          SYMB = SEMSYM(I)
          J = I - 1
8         IF(J .LT. PROSEM(PROD)) GOTO 9
            IF (SEM(J) .NE. SOCO .OR. SEMSYM(J) .NE. SYMB) GOTO 19
              SEM(J) = - SOCO
19          CONTINUE
            J = J - 1
          GOTO 8
9         CONTINUE ! DO J
7       CONTINUE ! = SOCO
        I = I - 1
      GOTO 5
6     CONTINUE ! DO I
27    CONTINUE
C-----------------------------------------------------------
C     -- CHANGE THE LAST 'ACCO' TO 'ACTA', AND SET ALL BUT
C          THE LAST NEGATIVE (FOR A SPECIFIC ACCU)
C
      I = FSEM - 1
20    IF(I .LT. PROSEM(PROD)) GOTO 21
        IF (SEM(I) .NE. ACCO) GOTO 22
          SEM(I) = ACTA
          SYMB = SEMSYM(I)
          INC =  SEMSYM(I+1)
          J = I - 1
23        IF(J .LT. PROSEM(PROD)) GOTO 24
            IF (SEM(J) .NE. ACCO .OR. SEMSYM(J) .NE. SYMB
     =        .OR. SEMSYM(J+1) .NE. INC)
     =      GOTO 25
              SEM(J) = - ACCO
25          CONTINUE
            J = J - 1
          GOTO 23
24        CONTINUE ! DO J
22      CONTINUE ! = ACCO
        I = I - 1
      GOTO 20
21    CONTINUE ! DO I
C-----------------------------------------------------------
C     -- INCREMENT ALL INCARNATIONS OF AN ACCU AFTER
C          AN 'ACMA' WITH 'INC = 0'
C
      I = PROSEM(PROD)
10    IF(I .GT. FSEM - 1) GOTO 11
        IF (SEM(I) .NE. ACMA) GOTO 12
          SYMB = SEMSYM(I)
          IF (SEMSYM(I+1) .NE. 0) GOTO 13
C           TO BE PUSHED
            J = I + 2
14          IF(J .GT. FSEM - 1) GOTO 15
              IF (SEM(J) .NE. ACCU .OR. SEMSYM(J-1) .NE. SYMB) GOTO 16
                IF (SEMSYM(J) .EQ. 0) SEMSYM(J) = 1
                SEMSYM(J) = SEMSYM(J) + 1 ! INCREMENT 'INC'
16            CONTINUE
              J = J + 1
            GOTO 14
15          CONTINUE ! DO J
13        CONTINUE ! INC = 0
12      CONTINUE ! = ACMA
        I = I + 1
      GOTO 10
11    CONTINUE ! DO I
C-----------------------------------------------------------
C     -- DECREMENT ALL INCARNATIONS OF AN ACCU AFTER
C          AN 'ACTA' WITH 'INC' >=
C
      I = PROSEM(PROD)
40    IF(I .GT. FSEM - 1) GOTO 41
        IF (SEM(I) .NE. ACTA) GOTO 42
          SYMB = SEMSYM(I)
          INC = SEMSYM(I+1)
          IF (INC .EQ. 0) INC = 1
          J = I + 2
44        IF(J .GT. FSEM - 1) GOTO 45
              IF (SEM(J) .NE. ACCU .OR. SEMSYM(J-1) .NE. SYMB) GOTO 46
                IF (SEMSYM(J) .GE. INC)
     =            SEMSYM(J) = SEMSYM(J) - 1 ! DECREMENT 'INC'
46            CONTINUE
              J = J + 1
          GOTO 44
45        CONTINUE ! DO J
42      CONTINUE ! = ACMA
        I = I + 1
      GOTO 40
41    CONTINUE ! DO I
C-----------------------------------------------------------
C     -- MAKE ALL CODES POSITVE AGAIN
C
      I = PROSEM(PROD)
30    IF(I .GT. FSEM - 1) GOTO 31
        IF (SEM(I) .LT. 0) SEM(I) = - SEM(I)
        I = I + 1
      GOTO 30
31    CONTINUE
C
      IF (PARASK('SEMCLO',1,6,0) .EQ. 0) GOTO 32
        CALL OUTPRO (PROD)
32    CONTINUE
      RETURN ! SEMCLO
      END
