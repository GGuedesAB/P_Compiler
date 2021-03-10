LEX=/usr/bin/flex
YACC=/usr/bin/yacc
CC=/usr/bin/g++
CFLAGS=-DYYERROR_VERBOSE=1 -ll -ly
YACCFLAGS=-d --report=all --report-file=yacc.report
TESTS_DIR=tests
CPP_SRCS=symbolInfo.cpp tree.cpp

all: pyacc

debug: pyacc
	gdb --args ./pyacc tests/simple_if_test.P

simple_test: pyacc_no_debug
	./pyacc tests/simple_if_test.P

pyacc: lex.yy.c y.tab.c $(CPP_SRCS)
	$(CC) -g -o pyacc $^ $(CFLAGS)

pyacc_no_debug: lex.yy.c y.tab.c $(CPP_SRCS)
	$(CC) -o pyacc $^ $(CFLAGS)

y.tab.c: yacc.y
	$(YACC) $(YACCFLAGS) yacc.y

lex.yy.c: Yylex.lex
	$(LEX) Yylex.lex

clean:
	rm -f y.tab.c y.tab.h lex.yy.c pyacc

tests: pyacc
	$(TESTS_DIR)/run_tests.sh
