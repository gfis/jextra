      SUBROUTINE OUTSEM (I)
C     PRINT A SINGLE SEMANTIC ACTION FOR A PRODUCTION
C     GF 11.07.1980
C
      INCLUDE 'PARS.f'
      INCLUDE 'SEMS.f'
      INTEGER*2 I
     = ,CODE
     = ,SEMNO(40) ! MNEMONICS FOR THE SEMANTIC ACTIONS
      DATA SEMNO
     = /'AC','CO',  'AC','IN',  'AC','MA',  'AC','TA'
     = ,'AT','CO',  'AT','IN',  'AT','MA',  'SY','AT'
     = ,'SO','CO',  'RE','IN',  'UN','CH',  'SO','TA'
     = ,'SY','CO',  'SY','IN',  'SY','MA',  'SE','PR'
     = ,'AC','CU',  'AT','TR',  'EO','SY',  'EO','S '
     = /
      CODE = SEM(I)
      CALL ZZWC (SEMNO,CODE*4-3,CODE*4,0)
      CALL ZZWC('(',1,1,0)
      CALL PUTSYM (SEMSYM(I))
      CALL ZZWC (')',1,1,3)
      IF (CODE .EQ. EOS) I = - 1 ! RETURN 'I=0'
      I = I + 1
      RETURN ! OUTSEM
      END
