#!/bin/make

# for bofor
# 2022-02-05, new attempt with gfortran
# 2005-03-26: build all executables
# 2002-10-09, Georg Fischer <punctum@punctum.com>
#
# CC=g77 -g 
CC=gfortran -O2 -std=legacy -fdec
#-fno-automatic 
#-finit-local-zero
# CC=c:/bin/MinGW/bin/g77 -g

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
	ZZCC.o ZZCI.o ZZCR.o ZZIC.o ZZINDX.o ZZTC.o ZZTS.o ZZTT.o ZZTX.o \
	ZZUC.o ZZWC.o ZZWI.o ZZWS.o ZZWT.o ZZWX.o 
#	PUTCOQ.o \

.SUFFIXES: .f .o
.f.o:
	# perl pre_xmlifo.pl $*.f
	$(CC) -c $*.f -o $*.o 
#	$(CC) -Wno-globals -c $*.f -o $*.o 2> $*.err
dummy:
	echo Aufruf mit all, bofog ...
all: 	unpack repair compile clean  executables

compile:
	ls -1 *.f | sed "s/\.f/.o/" \
	| xargs -l make 
clean:
	rm -f *.o *.err *.bak *.map *.stackdump

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

repair:
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

executables: assloa bofog bofol bofor extra linete parate scante zzccte zzcrte zzwte 

assloa: ASSERT.f ASSLOA.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
	ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
	ZZTS.o ZZTC.o ZZTX.o
	$(CC) -o $@ ASSLOA.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
	ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
	ZZTS.o ZZTC.o ZZTX.o
	rm -f ASSTEX.DIR
	./$@ | tee assloa.tst
assete: ASSERT.f ASSETE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
	ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
	ZZTS.o ZZTC.o ZZTX.o
	$(CC) -o $@ ASSETE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
	ZZINDX.o PUTSYM.o SYMEND.o ZZWC.o ZZWI.o ZZWS.o BLODAT.o PARADD.o \
	ZZTS.o ZZTC.o ZZTX.o
	./$@ | tee assloa.tst
bofog: BOFOG.o $(OBJS)
	$(CC) -o $@ BOFOG.o $(OBJS) 
bofol: BOFOL.o $(OBJS)
	$(CC) -o $@ BOFOL.o $(OBJS)
bofor: BOFOR.o $(OBJS)
	$(CC) -o $@ BOFOR.o $(OBJS)
# map with -Wl,-M
direte: DIRETE.o  $(OBJS)
	$(CC) -o $@ DIRETE.o $(OBJS)
extra: EXTRA.o  $(OBJS)
	$(CC) -o $@ EXTRA.o $(OBJS)
linete: LINETE.o  $(OBJS)
	$(CC) -o $@ LINETE.o BLODAT.o CODASS.o LINIT.o LINEXT.o \
	ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o PUTSYM.o \
	ZZTC.o ZZTS.o \
	ZZWS.o ZZWI.o ZZWC.o ZZINDX.o 
	cp LINEXT.f FORT.4
	./$@
parate: PARATE.o  $(OBJS)
	$(CC) -o $@ PARATE.o BLODAT.o ASSERT.o PARASK.o PARADD.o \
	PUTSYM.o  ZZINDX.o ZZTC.o ZZTS.o ZZWC.o ZZWI.o ZZWS.o \
	ZZCC.o ZZCR.o ZZCI.o ZZIC.o
scante: SCANTE.o  $(OBJS)
	$(CC) -o $@ LINETE.o BLODAT.o CODASS.o LINIT.o LINEXT.o \
	ZZCC.o ZZCR.o ZZCI.o ZZIC.o ASSERT.o PARASK.o \
	CODGET.o SPEINS.o SPEINI.o HAINIT.o CODINI.o SCAINI.o \
	SYMEND.o SYMINS.o SYMNUM.o 
sepute: SEPUTE.o  $(OBJS)
	$(CC) -o $@ SEPUTE.o $(OBJS) 
	$@
zzccte: ZZCCTE.o  $(OBJS)
	$(CC) -o $@ ZZCCTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o 
zzcrte: ZZCRTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o
	$(CC) -o $@ ZZCRTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o
	./$@
zzwte: ZZWTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ZZWS.o ZZWI.o ZZWC.o ZZWX.o \
	ZZTS.o ZZTC.o ZZTX.o
	$(CC) -o $@ ZZWTE.o ZZCC.o ZZCR.o ZZCI.o ZZIC.o ZZWS.o ZZWI.o ZZWC.o ZZWX.o \
	ZZTS.o ZZTC.o ZZTX.o
	./$@
