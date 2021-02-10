LEX=/usr/bin/flex
YACC=/usr/bin/yacc
CC=/usr/bin/g++
CFLAGS=-DYYERROR_VERBOSE=1 -ll -ly

all: lex.yy.c y.tab.c
	$(CC) -o pyacc $^ $(CFLAGS)

y.tab.c: yacc.y
	$(YACC) -d yacc.y

lex.yy.c: Yylex.lex
	$(LEX) Yylex.lex

clean:
	rm -f y.tab.c y.tab.h lex.yy.c pyacc

