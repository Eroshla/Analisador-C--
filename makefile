all: cmm

cmm: lex.yy.c analise.tab.c
	g++ lex.yy.c analise.tab.c -o cmm

lex.yy.c: analise.lex analise.tab.h
	flex analise.lex

analise.tab.c analise.tab.h: analise.y
	bison -d -o analise.tab.c analise.y

analise.tab.h: analise.tab.c

run-ok: cmm test.cmm
	./cmm < test.cmm
run-err: cmm test_err.cmm
	./cmm < test_err.cmm

clean:
	rm -f cmm lex.yy.c analise.tab.c analise.tab.h