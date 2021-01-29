%{
#include <stdio.h>
#include <stdlib.h>
%}

RELOP "="|"<"|"<="|">"|">="|"!="|"NOT"
ADDOP "+"|"-"|or
MULOP "*"|"/"|div|mod|and

letter [a-zA-z]
digit [0-9]
identifier {letter}({letter}|{digit})*

unsigned_integer {digit}{digit}*
sign ("+"|"-")?
scale_factor E{sign}{unsigned_integer}
unsigned_real {unsigned_integer}(\.{digit}*)?{scale_factor}
integer_constant {sign}{unsigned_integer}
real_constant {sign}{unsigned_real}
char_constant \".*\"
%%

{RELOP} {printf("rel op: %s", yytext);}
{ADDOP} {printf("add op: %s", yytext);}
{MULOP} {printf("mul op: %s", yytext);}

{identifier} {printf("id: %s", yytext);}
{integer_constant} {printf("int const: %s", yytext);}
{real_constant} {printf("real const: %s", yytext);}
{char_constant} {printf("char const: %s", yytext);}

%%

int main(int argc, char* argv[]) {
  yylex() ;
  return EXIT_SUCCESS ;
}