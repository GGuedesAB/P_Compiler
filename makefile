LEX=/usr/bin/flex
CC=/usr/bin/gcc

plex: lex.yy.c

lex.yy.c: Yylex.lex

all:
	$(LEX) Yylex.lex
	$(CC) -o plex lex.yy.c -ll

clean:
	rm -f lex.yy.c plex
