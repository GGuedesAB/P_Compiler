LEX=/usr/bin/flex
YACC=/usr/bin/yacc
CC=/usr/bin/g++
CFLAGS=-DYYERROR_VERBOSE=1 -ll -ly
TESTS_DIR=tests

all: pyacc

pyacc: lex.yy.c y.tab.c
	$(CC) -o pyacc $^ $(CFLAGS)

y.tab.c: yacc.y
	$(YACC) -d --report=all --report-file=yacc.report yacc.y

lex.yy.c: Yylex.lex
	$(LEX) Yylex.lex

clean:
	rm -f y.tab.c y.tab.h lex.yy.c pyacc

tests: pyacc
	$(TESTS_DIR)/run_tests.sh
