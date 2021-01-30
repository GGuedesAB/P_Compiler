%{
#include <stdio.h>
#include <stdlib.h>
%}

RELOP "="|"<"|"<="|">"|">="|"!="|"NOT"
ADDOP "+"|"-"|or
MULOP "*"|"/"|div|mod|and
ASSIGNOP ":="
program program
true true
false false
integer integer
boolean boolean
real real
char char
begin begin
end end
do do
while while
read read
write write
until until
goto goto
if if
else else
then then
func_identifier sin|log|cos|ord|chr|abs|sqrt|exp|eof|eoln 

letter [a-zA-z]
digit [0-9]
identifier {letter}({letter}|{digit})*

unsigned_integer {digit}{digit}*
sign ("+"|"-")?
scale_factor E{sign}{unsigned_integer}
unsigned_real {unsigned_integer}(\.{digit}*)?({scale_factor})?
integer_constant {sign}{unsigned_integer}
real_constant {sign}{unsigned_real}
char_constant \".*\"
%%

{RELOP} {printf("RELOP ");}
{ADDOP} {printf("ADDOP ");}
{MULOP} {printf("MULOP ");}
{ASSIGNOP} {printf("ASSIGNOP");}
{program} {printf("program ");}
{true} {printf("true ");}
{false} {printf("false ");}
{integer} {printf("integer ");}
{boolean} {printf("boolean ");}
{real} {printf("real ");}
{char} {printf("char ");}
{begin} {printf("begin ");}
{end} {printf("end ");}
{do} {printf("do ");}
{while} {printf("while ");}
{read} {printf("read ");}
{write} {printf("write ");}
{until} {printf("until ");}
{goto} {printf("goto ");}
{if} {printf("if ");}
{else} {printf("else ");}
{then} {printf("then ");}
{func_identifier} {printf("func_identifier ");}

{identifier} {printf("identifier ");}
{integer_constant} {printf("integer_constant ");}
{real_constant} {printf("real_constant ");}
{char_constant} {printf("char_constant ");}

%%

int main(int argc, char* argv[]) {
  yylex() ;
  return EXIT_SUCCESS ;
}
