#!/usr/bin/make

# Test JExtra classes
# @(#) $Id: 2bbd9511422674a354fe5a19f2d55437adbebce0 $
# 2016-05-30, Georg Fischer

APPL=jextra
JAVA=java -cp dist/$(APPL).jar
DIFF=diff -y --suppress-common-lines --width=160
DIFF=diff -w -rs -C0
SRC=src/main/java/org/teherba/$(APPL)
TOMC=/var/lib/tomcat/webapps/jextra
TOMC=c:/var/lib/tomcat/webapps/jextra
METHOD=post
LANG=en
TAB=relatives
TESTDIR=test
# the following can be overriden outside for single or subset tests,
# for example make regression TEST=U%
TEST="%"
# for Windows, SUDO should be empty
SUDO=

all: regression
#-------------------------------------------------------------------
# Perform a regression test 
regression: 
	java -cp dist/jextra.jar \
			org.teherba.common.RegressionTester $(TESTDIR)/all.tests $(TEST) 2>&1 \
	| tee $(TESTDIR)/regression.log
	grep FAILED $(TESTDIR)/regression.log
#
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
#--------------------------------------------------
search: # S=
	find src -iname "*.java" | xargs -l grep -iH $(S)
#--------------------------------------------------
# create the documentation files
doc: javadoc wikidoc
javadoc:
	ant javadoc
wikidoc:
	cd target/docs ; wget -E -H -k -K -p -nd -nc http://localhost/wiki/index.php/Dbat	             || true
	cd target/docs ; wget -E -H -k -K -p -nd -nc http://localhost/wiki/index.php/Dbat-Spezifikation  || true
#---------------------------------------------------
# test whether all defined tests in mysql.tests have *.prev.tst results and vice versa
check_tests:
	grep -E "^TEST" $(TESTDIR)/jextra.tests | cut -b 6-8 | sort | uniq -c > $(TESTDIR)/tests_formal.tmp
	ls -1 $(TESTDIR)/*.prev.tst             | cut -b 6-8 | sort | uniq -c > $(TESTDIR)/tests_actual.tmp
	diff -y --suppress-common-lines --width=32 $(TESTDIR)/tests_formal.tmp $(TESTDIR)/tests_actual.tmp
#---------------------------------------------------
jfind:
	find src -iname "*.java" | xargs -l grep -H "$(JF)"
rmbak:
	find src -iname "*.bak"  | xargs -l rm -v
#----
D=0
jegen: # run the standalone generator
	ant dist
	java -cp dist/jextra.jar ParserGenerator -d $(D) -f data/ex421.grm 2>&1 | tee jegen.txt
	diff -y --suppress-common-lines --width=140 -w data/gen4.txt jegen.txt | head -n16

