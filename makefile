LEX=/usr/bin/flex
YACC=/usr/bin/yacc
CC=/usr/bin/g++

plex: lex.yy.c

lex.yy.c: Yylex.lex

y.tab.c: yacc.y

all:
	$(YACC) -d yacc.y
	$(LEX) Yylex.lex
	$(CC) -o pyacc -DYYERROR_VERBOSE=1 lex.yy.c y.tab.c -ll -ly

clean:
	rm -f y.tab.c y.tab.h lex.yy.c plex pyacc

