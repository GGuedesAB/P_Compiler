%{
#include <string>
#include "y.tab.h"
%}

delim [ \t\n]
stoken {delim}+
RELOP "="|"<"|"<="|">"|">="|"!="
ADDOP "+"|or
MINUSOP "-"
MULOP "*"|"/"|div|mod|and
ASSIGNOP ":="
PROGRAM program
TRUE true
FALSE false
INTEGER integer
BOOLEAN boolean
REAL real
CHAR char
FUNCTIONAL function
T_BEGIN begin
END end
DO do
WHILE while
READ read
WRITE write
UNTIL until
T_GOTO goto
IF if
ELSE else
THEN then
FUNC_ID sin|log|cos|ord|chr|abs|sqrt|exp|eof|eoln 
NOT NOT

letter [a-zA-z]
digit [0-9]
IDENTIFIER {letter}({letter}|{digit})*

unsigned_integer {digit}{digit}*
sign ("+"|"-")?
scale_factor E{sign}{unsigned_integer}
unsigned_real {unsigned_integer}(\.{digit}*)?({scale_factor})?
INTEGER_CONSTANT {sign}{unsigned_integer}
REAL_CONSTANT {sign}{unsigned_real}
CHAR_CONSTANT \'.\'
%%

{RELOP} { yylval.string_t = strdup(yytext); return RELOP; }
{ADDOP} { yylval.string_t = strdup(yytext); return ADDOP; }
{MINUSOP} { yylval.string_t = strdup(yytext); return MINUSOP; }
{MULOP} { yylval.string_t = strdup(yytext); return MULOP; }
{ASSIGNOP} { yylval.string_t = strdup(yytext); return ASSIGNOP; }
{PROGRAM} {return PROGRAM; }
{TRUE} { yylval.string_t = strdup(yytext);return T_TRUE; }
{FALSE} { yylval.string_t = strdup(yytext); return T_FALSE; }
{INTEGER} { return INTEGER; }
{BOOLEAN} { return BOOLEAN; }
{REAL} { return REAL; }
{CHAR} { return CHAR; }
{FUNCTIONAL} {return FUNCTIONAL; }
{T_BEGIN} { return T_BEGIN; }
{END} { return END; }
{DO} { return DO; }
{WHILE} { return WHILE; }
{READ} { return READ; }
{WRITE} { return WRITE; }
{UNTIL} { return UNTIL; }
{T_GOTO} { return T_GOTO; }
{IF} { return IF; }
{ELSE} { return ELSE; }
{THEN} { return THEN; }
{FUNC_ID} { yylval.string_t	= strdup(yytext); return FUNC_ID; }
{NOT} { yylval.string_t = strdup(yytext); return NOT; }

":" { return T_2P; }
";" { return T_PVIRG; }
"," { return T_VIRG; }
"(" { return T_POPEN; }
")" { return T_PCLOSE; }

{IDENTIFIER} { yylval.string_t = strdup(yytext); return IDENTIFIER; }
{INTEGER_CONSTANT} { yylval.string_t = strdup(yytext); return INTEGER_CONSTANT; }
{REAL_CONSTANT} { yylval.string_t	= strdup(yytext); return REAL_CONSTANT; }
{CHAR_CONSTANT} { yylval.string_t	= strdup(yytext); return CHAR_CONSTANT; }

{stoken} { ; }

%%

int yywrap(void){
    return 1;    
}
