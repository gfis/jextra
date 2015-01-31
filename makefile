#!/usr/bin/make

JAVA=java -cp dist/jextra.jar
all:
	ant
doc:
	ant javadoc
xgrep:
	find src -name "*.java" | xargs -l grep -iH $(GREP)
	
bak:
	find . -name "*.bak" | xargs -l rm 
tgz:
	tar czvf jextra_$(DATE).tgz src

meta:
	$(JAVA) org.teherba.jextra.parse.ProtoParser test/meta.grm > meta.tmp
	wc meta*
	less meta.tmp
sasb:
	$(JAVA) org.teherba.jextra.parse.ProtoParser test/sasb.grm > sasb.tmp
	less sasb.tmp
EmptyParser:
	$(JAVA) org.teherba.jextra.parse.EmptyParser test/meta.grm > empty.tmp
	wc empty*
	less empty.tmp
SymbolQueue:
	$(JAVA) org.teherba.jextra.gener.SymbolQueue
StateQueue:	
	$(JAVA) org.teherba.jextra.gener.StateQueue
		