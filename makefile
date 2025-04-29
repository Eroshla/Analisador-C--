all: cmm

cmm: analise.lex
	flex analise.lex
	g++ lex.yy.c -o cmm

run: cmm main.cmm
	./cmm < main.cmm

clean:
	rm -f cmm lex.yy.c