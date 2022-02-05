#!make

# bofor_2022/makefile
# @(#) $Id$
# 2022-02-04: Georg Fischer
#---------------------------------
GITS=../../..
DBAT=java -jar $(GITS)/dbat/dist/dbat.jar -e UTF-8 -c worddb

FC=gfortran
FFLAGS=-O2 -std=legacy -fallow-argument-mismatch -fdec
SRC= \
	ALONG.ftn	ASSERT.ftn	ASSLOA.ftn	ASSLOATB.ftn	BLODAT.ftn	BOFOG.ftn	BOFOGTB.ftn	BOFOL.ftn\
	BOFOLTB.ftn	BOFOR.ftn	BOFORTB.ftn	CLEARE.ftn	CODASS.ftn	CODGET.ftn	CODINI.ftn	COMPIL.ftn\
	COMPILTB.ftn	COUNT.ftn	DELTA.ftn	DIRECT.ftn	DIRREA.ftn	DIRWRI.ftn	EMITT.ftn	EXTRA.ftn\
	GRAMAR.ftn	HAINIT.ftn	HAMAP.ftn	HAPSE.ftn	HEADER.ftn	INDEX.ftn	INFOUT.ftn	ITEACT.ftn\
	ITEALL.ftn	ITEFRE.ftn	ITEINS.ftn	ITEMA1.ftn	ITEMA2.ftn	ITEMA8.ftn	ITEMA9.ftn	LACOPY.ftn\
	LADEL.ftn	LAGAR.ftn	LAGET.ftn	LAPUT.ftn	LIFRE.ftn	LILINK.ftn	LINETE.ftn	LINEXT.ftn\
	LINIT.ftn	LITRAC.ftn	LRDUMP.ftn	LRINIT.ftn	LROPEN.ftn	NUMSYM.ftn	OUTMAP.ftn	OUTPRO.ftn\
	OUTSEM.ftn	OUTSET.ftn	OUTSTA.ftn	OUTSYM.ftn	PARADD.ftn	PARASK.ftn	PARATE.ftn	PAROLD.ftn\
	PARSER.ftn	PREDEL.ftn	PREINS.ftn	PREPAR.ftn	PRIXRE.ftn	PROCHA.ftn	PROLNG.ftn	PUTACT.ftn\
	PUTCON.ftn	PUTCOQ.ftn	PUTSYM.ftn	RECEIV.ftn	REORG.ftn	SCAINI.ftn	SCAN.ftn	SCANS.ftn\
	SEMANT.ftn	SEMARI.ftn	SEMCLO.ftn	SEMGET.ftn	SEMLUP.ftn	SEMWRI.ftn	SEPANT.ftn	SEPUSH.ftn\
	SETINF.ftn	SETINI.ftn	SETSIN.ftn	SHOMAP.ftn	SHOMAPTB.ftn	SPAALL.ftn	SPAFRE.ftn	SPAINI.ftn\
	SPASEA.ftn	SPEINI.ftn	SPEINS.ftn	SPEMAP.ftn	STAALL.ftn	STACLO.ftn	STAGAR.ftn	STASEA.ftn\
	STASUC.ftn	STASYM.ftn	SYMEND.ftn	SYMINS.ftn	SYMNUM.ftn	TARGET.ftn	TRACCU.ftn	TRACOP.ftn\
	TRADO.ftn	TRADUM.ftn	TRAFOR.ftn	TRAO1.ftn	TRAOUT.ftn	TRAPEN.ftn	TRAPIM.ftn	TRATTR.ftn\
	TREFRE.ftn	TREGET.ftn	TREPUT.ftn	TREXPA.ftn	ZZCC.ftn	ZZCCTE.ftn	ZZCI.ftn	ZZCR.ftn\
	ZZIC.ftn	ZZTC.ftn	ZZTI.ftn	ZZTS.ftn	ZZTT.ftn	ZZTTE.ftn	ZZTX.ftn	ZZUC.ftn\
	ZZUTE.ftn	ZZUTETB.ftn	ZZWC.ftn	ZZWI.ftn	ZZWS.ftn	ZZWT.ftn	ZZWTE.ftn	ZZWX.ftn\
	# end
ZZW_OBJ=ZZWC.o ZZWI.o ZZWS.o ZZWT.o ZZWX.o
ZZWTE: $(ZZW_OBJ) ZZWTE.o
	$(FC) $(FFLAGS) -o $@ $(ZZW_OBJ) ZZWTE.o
ZZT_OBJ=ZZTC.o ZZTI.o ZZTS.o ZZTT.o ZZTX.o
ZZTTE: $(ZZT_OBJ) ZZTTE.o
	$(FC) $(FFLAGS) -o $@ $(ZZT_OBJ) ZZTTE.o

OBJ=${SRC:.ftn=.o} 

%.o: %.ftn # wildcard rule: *.o depends on *.ftn
	$(FC) $(FFLAGS) -o $@ -c $<
all: $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ) 
	
clean:
#-------------
info:
	# targets: new = prepare newseq archlist regen (in that order)
help:
	grep -E "^[a-z]" makefile
#======================
unpack:
	perl unpack.pl BOFOR.ALL
	ls -al
#----

