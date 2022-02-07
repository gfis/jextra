#!/bin/make

# makefile for bofor_2005
# @(#) $Id$ 
# 2022-02-05, new attempt with gfortran
# 2005-03-26: build all executables
# 2002-10-09, Georg Fischer <punctum@punctum.com>
#
CC=gfortran -std=legacy -w -fallow-argument-mismatch -fdec

.SUFFIXES: .f .o
.f.o:
	$(CC) -c $*.f -o $*.o 
OBJS=	ALONG.o ASSERT.o BLODAT.o \
	CLEARE.o CODASS.o CODGET.o CODINI.o COUNT.o DELTA.o DIRECT.o \
	EMITT.o GRAMAR.o HAINIT.o HAMAP.o HAPSE.o HEADER.o INFOUT.o \
	ITEACT.o ITEALL.o ITEFRE.o ITEINS.o ITEMA1.o ITEMA2.o ITEMA8.o ITEMA9.o \
	LACOPY.o LADEL.o LAGAR.o LAGET.o LAPUT.o LIFRE.o LILINK.o LINEXT.o LINIT.o LITRAC.o \
	LRDUMP.o LRINIT.o LROPEN.o NUMSYM.o \
	OUTMAP.o OUTPRO.o OUTSEM.o OUTSET.o OUTSTA.o OUTSYM.o PARADD.o PARASK.o \
	PARSER.o PREDEL.o PREINS.o PREPAR.o PROCHA.o PROLNG.o PUTACT.o PUTCON.o \
	PUTSYM.o RECEIV.o REORG.o SCAINI.o SCANR.o SCANS.o \
	SEMANT.o SEMARI.o SEMCLO.o SEMGET.o SEMLUP.o SEMWRI.o SEPANT.o SEPUSH.o SETINF.o \
	SETINI.o SETSIN.o SPAALL.o SPAFRE.o SPAINI.o SPASEA.o SPEINI.o SPEINS.o SPEMAP.o \
	STAALL.o STACLO.o STAGAR.o STASEA.o STASUC.o SYMEND.o SYMINS.o SYMNUM.o \
	TARGET.o TRACCU.o TRACOP.o TRADO.o TRADUM.o TRAFOR.o TRAO1.o TRAOUT.o \
	TRAPEN.o TRAPIM.o TRATTR.o TREFRE.o TREGET.o TREPUT.o TREXPA.o XMLIZE.o \
	ZZCC.o ZZCI.o ZZCR.o ZZIC.o ZZCTE.o ZZINDX.o ZZTC.o ZZTS.o ZZTT.o ZZTX.o \
	ZZUC.o ZZWC.o ZZWI.o ZZWS.o ZZWT.o ZZWX.o 

all: regression # TEST=

build: clean compile regression

clean:
	rm -f *.o *.err *.bak *.map *.stackdump

compile: assloa assete \
	bofog bofol bofor extra \
	linete parate sepute \
	zzcte zzccte zzcrte zztte zzute zzwte 
	# direte scante ?
ls1_f:
	ls -1 *.f
gita:
	git add -v *.f test/*.prev.tst *.dat *.grm
#----
assloa: ASSERT.f ASSLOA.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
		ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
		ZZTS.o ZZTC.o ZZTX.o
	$(CC) -o $@ ASSLOA.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
		ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
		ZZTS.o ZZTC.o ZZTX.o
assete: ASSERT.f ASSETE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
		ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
		ZZTS.o ZZTC.o ZZTX.o
	$(CC) -o $@ ASSETE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
		ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
		ZZTS.o ZZTC.o ZZTX.o
bofog: BOFOG.o $(OBJS)
	$(CC) -o $@ BOFOG.o $(OBJS) 
bofol: BOFOL.o $(OBJS)
	$(CC) -o $@ BOFOL.o $(OBJS)
bofor: BOFOR.o $(OBJS)
	$(CC) -o $@ BOFOR.o $(OBJS)
# direte: DIRETE.o  $(OBJS)
#	$(CC) -o $@ DIRETE.o $(OBJS)
extra: EXTRA.o  $(OBJS)
	$(CC) -o $@ EXTRA.o $(OBJS)
linete: LINETE.o  $(OBJS)
	$(CC) -o $@ LINETE.o BLODAT.o CODASS.o LINIT.o LINEXT.o \
		ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o PUTSYM.o SYMEND.o \
		ZZTC.o ZZTS.o \
		ZZWS.o ZZWI.o ZZWC.o ZZINDX.o 
parate: PARATE.o  $(OBJS)
	$(CC) -o $@ PARATE.o BLODAT.o ASSERT.o PARASK.o PARADD.o \
		PUTSYM.o SYMEND.o ZZINDX.o ZZTC.o ZZTS.o ZZWC.o ZZWI.o ZZWS.o \
		ZZCC.o ZZCR.o ZZCI.o ZZIC.o
# scante: SCANTE.o  $(OBJS)
# 	$(CC) -o $@ LINETE.o BLODAT.o CODASS.o LINIT.o LINEXT.o \
# 		ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
# 		CODGET.o SPEINS.o SPEINI.o HAINIT.o CODINI.o SCAINI.o \
# 		SYMEND.o SYMINS.o SYMNUM.o 
sepute: SEPUTE.o  $(OBJS)
	$(CC) -o $@ SEPUTE.o $(OBJS) 
zzccte: ZZCCTE.o  $(OBJS)
	$(CC) -o $@ ZZCCTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o 
zzcte: ZZCTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o 
	$(CC) -o $@ ZZCTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o
	./$@
zzcrte: ZZCRTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o
	$(CC) -o $@ ZZCRTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o
zztte: ZZTTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ZZTS.o ZZTI.o ZZTC.o ZZTX.o
	$(CC) -o $@ ZZTTE.o ZZTC.o ZZTS.o ZZTI.o ZZTX.o ZZCC.o ZZCI.o ZZIC.o
zzute: ZZUTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ZZUC.o
	$(CC) -o $@ ZZUTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ZZUC.o 
zzwte: ZZWTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ZZWS.o ZZWI.o ZZWC.o ZZWX.o \
		ZZTS.o ZZTC.o ZZTX.o
	$(CC) -o $@ ZZWTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o \
		ZZTC.o ZZTS.o ZZTX.o \
		ZZWS.o ZZWI.o ZZWC.o ZZWX.o
#----
ALONG.o:	ALONG.f PARS.f ITES.f MEMS.f STAS.f
ASSERT.o:	ASSERT.f PARS.f ENDS.f
ASSLOA.o:	ASSLOA.f
BLODAT.o:	BLODAT.f PARS.f BUCS.f CODS.f DIRS.f ITES.f LINS.f MEMS.f \
		 PRES.f PRIS.f PROS.f PRESEMS.f MEMSETS.f SLOS.f
BOFOG.o:	BOFOG.f
BOFOL.o:	BOFOL.f
BOFOR.o:	BOFOR.f
CLEARE.o:	CLEARE.f PARS.f ITES.f MEMS.f PROS.f STAS.f STASTRS.f SYMS.f \
		
CODASS.o:	CODASS.f PARS.f CODS.f
CODGET.o:	CODGET.f PARS.f CODS.f LINS.f
CODINI.o:	CODINI.f PARS.f CODS.f
COMPIL.o:	COMPIL.f PARS.f STRS.f SYMS.f
COUNT.o:	COUNT.f
DELTA.o:	DELTA.f PARS.f ITES.f MEMS.f STAS.f STKS.f SYMS.f
DIRECT.o:	DIRECT.f PARS.f BUCS.f DIRS.f SEMS.f STAS.f STASTRS.f SYMS.f \
		 TRES.f
DIRH.o:	 SPAS.f STAS.f \
		 STAT1.f STKS.f STASTRS.f SYMS.f TARS.f SETTRAS.f TRES.f DIRS.f SPAS.f STAS.f DIRS.f SPAS.f STAS.f DIRS.f STAS.f
DIRREA.o:	DIRREA.f PARS.f DIRS.f
DIRWRI.o:	DIRWRI.f PARS.f DIRS.f
EMITT.o:	EMITT.f PARS.f ITES.f PRES.f PROS.f SETS.f STAS.f
EXTRA.o:	EXTRA.f
GRAMAR.o:	GRAMAR.f PARS.f MEMS.f PROS.f SEMS.f STRS.f SYMS.f
HAINIT.o:	HAINIT.f PARS.f BUCS.f STRS.f SYMS.f
HAMAP.o:	HAMAP.f PARS.f BUCS.f STRS.f SYMS.f
HAPSE.o:	HAPSE.f PARS.f STRS.f SYMS.f
HEADER.o:	HEADER.f PARS.f
INDEX.o:	INDEX.f
INFOUT.o:	INFOUT.f PARS.f INFS.f
ITEACT.o:	ITEACT.f PARS.f
ITEALL.o:	ITEALL.f PARS.f ITES.f SPAS.f
ITEFRE.o:	ITEFRE.f PARS.f ITES.f
ITEH.o:	 MEMS.f SYMS.f
ITEINS.o:	ITEINS.f PARS.f ITES.f MEMS.f MEMSETS.f STAS.f
ITEMA1.o:	ITEMA1.f PARS.f ITES.f SLOS.f
ITEMA2.o:	ITEMA2.f PARS.f ITES.f STAS.f PRIS.f
ITEMA8.o:	ITEMA8.f PARS.f ITES.f SLOS.f
ITEMA9.o:	ITEMA9.f PARS.f ITES.f SLOS.f
LACOPY.o:	LACOPY.f PARS.f ITES.f PROS.f SETS.f STAS.f SYMS.f
LADEL.o:	LADEL.f PARS.f ITES.f PROS.f SETS.f STAS.f
LAGAR.o:	LAGAR.f PARS.f SETS.f STAS.f
LAGET.o:	LAGET.f PARS.f ITES.f MEMS.f MEMSETS.f STAS.f
LAPUT.o:	LAPUT.f PARS.f SETS.f STAS.f
LIFRE.o:	LIFRE.f
LILINK.o:	LILINK.f
LINETE.o:	LINETE.f PARS.f
LINEXT.o:	LINEXT.f PARS.f LINS.f PROS.f
LINIT.o:	LINIT.f PARS.f LINS.f
LITRAC.o:	LITRAC.f
LRDUMP.o:	LRDUMP.f PARS.f BUCS.f CODS.f STAS.f SYMS.f
LRINIT.o:	LRINIT.f PARS.f ITES.f MEMS.f PRES.f PROS.f STAS.f SYMS.f \
		
LROPEN.o:	LROPEN.f PARS.f ITES.f MEMS.f PRES.f PROS.f MEMSETS.f STAS.f \
		 SYMS.f
NUMSYM.o:	NUMSYM.f
OUTMAP.o:	OUTMAP.f PARS.f MEMS.f PRES.f PROS.f SYMS.f
OUTPRO.o:	OUTPRO.f PARS.f ITES.f PROS.f
OUTSEM.o:	OUTSEM.f PARS.f SEMS.f
OUTSET.o:	OUTSET.f PARS.f SETS.f
OUTSTA.o:	OUTSTA.f PARS.f ITES.f PRES.f PROS.f STAS.f SYMS.f
OUTSYM.o:	OUTSYM.f PARS.f PROS.f STAS.f SYMS.f
PARADD.o:	PARADD.f PARS.f
PARASK.o:	PARASK.f PARS.f
PARATE.o:	PARATE.f
PARSER.o:	PARSER.f PARS.f ITES.f PROS.f STAS.f STKS.f SYMS.f TRAS.f \
		 ENDS.f
PREDEL.o:	PREDEL.f PARS.f PRES.f SETS.f STAS.f
PREINS.o:	PREINS.f PARS.f PRES.f STAS.f
PREPAR.o:	PREPAR.f PARS.f ITES.f LINS.f MEMS.f PROS.f SPAS.f STAS.f \
		 STAT1.f SYMS.f TRES.f
PROCHA.o:	PROCHA.f PARS.f MEMS.f PROS.f SYMS.f
PROLNG.o:	PROLNG.f PARS.f MEMS.f
PUTACT.o:	PUTACT.f PARS.f ITES.f PROS.f
PUTCON.o:	PUTCON.f PARS.f ITES.f MEMS.f PROS.f MEMSETS.f STAS.f STASTRS.f \
		 SYMS.f
PUTCOQ.o:	 PARS.f ITES.f MEMS.f PROS.f MEMSETS.f STAS.f STASTRS.f SYMS.f \
		
PUTSYM.o:	PUTSYM.f PARS.f STRS.f SYMS.f
RECEIV.o:	RECEIV.f PARS.f PRES.f PROS.f STAS.f SYMS.f
REORG.o:	REORG.f PARS.f INFS.f ITES.f MEMS.f PRES.f PROS.f PRESEMS.f \
		 SPAS.f STAS.f STASTRS.f SYMS.f
SCAINI.o:	SCAINI.f PARS.f CODS.f SYMS.f
SCAN.o:	SCAN.f PARS.f CODS.f LINS.f STRS.f SYMS.f
SCANS.o:	SCANS.f PARS.f PROS.f STAS.f STAT1.f SYMS.f TRAS.f ENDS.f \
		
SEMANT.o:	SEMANT.f PARS.f MEMS.f PROS.f SEMS.f STRS.f SYMS.f STAT1.f \
		 TRAS.f ENDS.f
SEMARI.o:	SEMARI.f PARS.f SYMS.f TRAS.f
SEMCLO.o:	SEMCLO.f PARS.f MEMS.f PROS.f SEMS.f
SEMGET.o:	SEMGET.f PARS.f STKS.f SYMS.f TRAS.f
SEMLUP.o:	SEMLUP.f PARS.f MEMS.f PROS.f SEMS.f
SEMWRI.o:	SEMWRI.f PARS.f SEMS.f
SEPANT.o:	SEPANT.f PARS.f LINS.f STAT1.f SYMS.f TRAS.f ENDS.f
SEPUSH.o:	SEPUSH.f PARS.f SETS.f
SETINF.o:	SETINF.f PARS.f SETS.f
SETINI.o:	SETINI.f PARS.f MEMS.f MEMSETS.f
SETSIN.o:	SETSIN.f PARS.f SETS.f
SHOMAP.o:	SHOMAP.f PARS.f
SPAALL.o:	SPAALL.f PARS.f SPAS.f
SPAFRE.o:	SPAFRE.f PARS.f ITES.f SPAS.f
SPAINI.o:	SPAINI.f PARS.f SPAS.f
SPASEA.o:	SPASEA.f PARS.f SPAS.f STAS.f
SPEINI.o:	SPEINI.f PARS.f STRS.f SYMS.f
SPEINS.o:	SPEINS.f PARS.f STRS.f SYMS.f
SPEMAP.o:	SPEMAP.f PARS.f CODS.f LINS.f STRS.f SYMS.f
STAALL.o:	STAALL.f PARS.f ITES.f MEMS.f PRES.f PROS.f MEMSETS.f STAS.f \
		 SYMS.f
STACLO.o:	STACLO.f PARS.f PROS.f SETS.f SYMS.f
STAGAR.o:	STAGAR.f PARS.f ITES.f PRES.f SETS.f STAS.f
STASEA.o:	STASEA.f PARS.f ITES.f PRES.f STAS.f SYMS.f ENDS.f
STASUC.o:	STASUC.f PARS.f ITES.f PROS.f SETS.f STAS.f SYMS.f
STASYM.o:	STASYM.f PARS.f ITES.f MEMS.f STAS.f
SYMEND.o:	SYMEND.f PARS.f
SYMINS.o:	SYMINS.f PARS.f PRES.f PROS.f SETS.f STAS.f SYMS.f
SYMNUM.o:	SYMNUM.f PARS.f STRS.f SYMS.f ENDS.f
TARGET.o:	TARGET.f PARS.f STKS.f TRAS.f TRES.f
TRACCU.o:	TRACCU.f PARS.f SEMS.f SYMS.f TRAS.f ENDS.f
TRACOP.o:	TRACOP.f PARS.f TRAS.f ENDS.f
TRADO.o:	TRADO.f PARS.f TRAS.f ENDS.f
TRADUM.o:	TRADUM.f PARS.f TRAS.f ENDS.f
TRAFOR.o:	TRAFOR.f PARS.f PROS.f SEMS.f STKS.f SYMS.f TRAS.f TRES.f \
		 ENDS.f
TRAO1.o:	TRAO1.f PARS.f TRAS.f ENDS.f
TRAOUT.o:	TRAOUT.f
TRAPEN.o:	TRAPEN.f PARS.f TRAS.f ENDS.f
TRAPIM.o:	TRAPIM.f PARS.f TRAS.f ENDS.f
TRATTR.o:	TRATTR.f PARS.f SEMS.f STKS.f SYMS.f TRAS.f ENDS.f
TREFRE.o:	TREFRE.f PARS.f SLOS.f ENDS.f
TREGET.o:	TREGET.f PARS.f SLOS.f TRES.f ENDS.f
TREPUT.o:	TREPUT.f PARS.f TRAS.f TRES.f ENDS.f
TREXPA.o:	TREXPA.f PARS.f SLOS.f STRS.f SYMS.f TRES.f ENDS.f
ZZCTE.o:	ZZCTE.f
ZZCCTE.o:	ZZCCTE.f
ZZCC.o:	ZZCC.f
ZZIC.o:	ZZIC.f
ZZCI.o:	ZZCI.f
ZZCR.o:	ZZCR.f
ZZTC.o:	ZZTC.f PARS.f TARS.f
ZZTI.o:	ZZTI.f PARS.f TARS.f
ZZTS.o:	ZZTS.f PARS.f TARS.f
ZZTT.o:	ZZTT.f PARS.f TARS.f
ZZTTE.o:	ZZTTE.f PARS.f
ZZTX.o:	ZZTX.f PARS.f TARS.f
ZZUC.o:	ZZUC.f PARS.f PRIS.f PARS.f PRIS.f
ZZUTE.o:	ZZUTE.f
ZZWC.o:	ZZWC.f PARS.f PRIS.f
ZZWI.o:	ZZWI.f PARS.f PRIS.f
ZZWS.o:	ZZWS.f PARS.f PRIS.f
ZZWT.o:	ZZWT.f PARS.f PRIS.f
ZZWTE.o:	ZZWTE.f PARS.f
ZZWX.o:	ZZWX.f PARS.f PRIS.f


#----
# run all programs stand-alone
test1: BLODAT.o 
	cp -v BLODAT.o ASSTEX.DIR # some big file
	./assloa | tee assloa.tst
	./assete | tee assloa.tst
	./bofog
	./bofol
	./bofor
	./direte
	./extra
	./linete < LINEXT.f
	./parate
	./scante
	./sepute
	./zzccte
	./zzcrte
	./zztte
	./zzute
	./zzwte
#--------
# the following can be overriden outside for single or subset tests, for example make regression TEST=U%
TEST="%"
TESTDIR=test

regression: # TEST= perform a regression test 
	java -cp ../../../common/dist/common.jar org.teherba.common.RegressionTester $(TESTDIR)/all.tests $(TEST) 2>&1 \
	| tee $(TESTDIR)/regression.log
	grep FAILED $(TESTDIR)/regression.log
#----
# Recreate all testcases which failed (i.e. remove xxx.prev.tst)
# Handle with care!
# Failing testcases are turned into "passed" and are manifested by this target!
recreate: recr1 regr2
recr0:
	grep -E '> FAILED' $(TESTDIR)/regression*.log | cut -f 3 -d ' ' | xargs -l -ißß echo rm -v test/ßß.prev.tst
recr1:
	grep -E '> FAILED' $(TESTDIR)/regression*.log | cut -f 3 -d ' ' | xargs -l -ißß rm -v test/ßß.prev.tst
regr2:
	make regression TEST=$(TEST) > x.tmp
# test whether all defined tests in common.tests have *.prev.tst results and vice versa
check_tests:
	grep -E "^TEST" $(TESTDIR)/all.tests   | cut -b 6-8 | sort | uniq -c > $(TESTDIR)/tests_formal.tmp
	ls -1 $(TESTDIR)/*.prev.tst            | cut -b 6-8 | sort | uniq -c > $(TESTDIR)/tests_actual.tmp
	diff -y --suppress-common-lines --width=32 $(TESTDIR)/tests_formal.tmp $(TESTDIR)/tests_actual.tmp
#================
# CC=g77 -g 
#-fno-automatic 
#-finit-local-zero
# CC=c:/bin/MinGW/bin/g77 -g

# old targets

	# perl pre_xmlifo.pl $*.f
#	$(CC) -Wno-globals -c $*.f -o $*.o 2> $*.err

compile_old: 
	ls -1 *.f | sed "s/\.f/.o/" | xargs -l make 2>&1 | tee compile.log

unpack_old:
	rm -f *.F *.f *.bak
	perl bibunp.pl bofor.all bofor.all
	cp patch/*.[fF] .
	rm -f *TB.f
	ls ???S.f ??????S.f | sed "s/\.f//" | xargs -iq mv q.f q.F
	mv INDEX.f ZZINDX.f
	mv ZZWS.F  ZZWS.f
	mv ZZTS.F  ZZTS.f
	mv STAT1.f STAT1.F
	mv SCAN.f  SCANR.f
	rm -f COMPIL.* PAROLD.* SHOMAP.* PRIXRE.* ZZTI.*

repair_old:
	perl -i.bak -pe "s/5    CONTINUE/5     CONTINUE/;" SEPUSH.f 
	perl -i.bak -pe "s/^     INCLUDE \'ENDS.F\'/      INCLUDE \'ENDS.F\'/;" TRAFOR.f 
	perl -i.bak -pe "s/^ /C/ if m/\,STASYM/; s/\(XXSTAH\)// if m/ STASYM/;" STAS.F
	perl -i.bak -pe "s/^ /C/ if m/STAS\.F/;"           STASYM.f
	perl -i.bak -pe "s/^ /C/ if m/   STASYM/;"         STAALL.f
	perl -i.bak -pe "s/XXLINH A2/41A2/;"               LINEXT.f
	perl -i.bak -pe "s/XXPRIH A2/61A2/;"               ZZWS.f  
	perl -i.bak -pe "s/XXPRIH A2/61A2/;"               ZZTS.f  
	perl -i.bak -pe "s/XXUPRI=5/XXUPRI=6/;"            PARS.F  
	perl -i.bak -pe "s/CALL +SCAN/CALL SCANR/;"        GRAMAR.f  
	perl -i.bak -pe "s/CALL +SCAN/CALL SCANR/;"        SCANS.f  
	perl -i.bak -pe "s/SUBROUTINE +SCAN/SUBROUTINE SCANR/;" SCANR.f
	perl -i.bak -pe "s/32767/32766/;"                  DIRECT.f
	perl -i.bak -pe "s/(INSTAR\(\'\w{5})\' ?,/\1 \',/"    REORG.f
	perl -i.bak -pe "s[ASSERT\.FTN][ASSERT.f];"        ASSLOA.f
	perl -i.bak -p \
	  -e "s/TIME \(TEXT\)/ZZCC (\'19:54:00\',1,8,TEXT,1,8)/;" \
	  -e "s/DATE \(TEXD\)/ZZCC (\'15.20.2002\',1,10,TEXD,1,10)/;" \
	  HEADER.f
	sed -n -e "1,9p" -e "29,$$$$p" PARADD.f > x.tmp 
	perl -pe "s/FILNAM/\'PARMS.DAT\'/;"       x.tmp  > PARADD.f
rep1:
	perl -i.bak -pe "s/^ /C/ if m/\,STASYM/; s/\(XXSTAH\)// if m/ STASYM/;" STAS.F
olist:
	ls -1 *.o | grep -vE "TE\.o" | tr -d "\r" | tr "\n" " " > olist.tmp
parlist:
	grep -E "PARASK *\(" *.f | grep ".f: " \
	|  sed "s/^[:alpha:]+\.f://"
#----
