%{
  #include <iostream>
  #include <unordered_map>
  #include <vector>
  #include <string>
  extern int yylex();
  extern int yyparse();
  inline void yyerror(const char *s) { std::cout << "Error: " << s << std::endl; }
%}

%union{
  char* string_t;
}

%start program

%token  PROGRAM
%token  INTEGER
%token  REAL
%token  BOOLEAN
%token  CHAR
%token  T_BEGIN
%token  END
%token  IF
%token  THEN
%token  ELSE
%token  DO
%token  WHILE
%token  UNTIL
%token  READ
%token  WRITE
%token T_GOTO
%token  T_TRUE
%token  T_FALSE
%token  MINUSOP
%token  NOT

%token  <string_t>  FUNC_ID
%token  <string_t>  INTEGER_CONSTANT
%token  <string_t>  REAL_CONSTANT
%token  <string_t>  CHAR_CONSTANT
%token  <string_t>  IDENTIFIER

%token  T_2P
%token  T_PVIRG
%token  T_VIRG
%token  ASSIGNOP
%token  T_POPEN
%token  T_PCLOSE

%token <string_t> RELOP
%token <string_t> ADDOP
%token <string_t> MULOP

%left   ASSIGNOP
%right  RELOP ADDOP MULOP MINUSOP

%%
program:      PROGRAM IDENTIFIER T_PVIRG decl_list compound_stmt
              ;

decl_list:    decl_list decl
              | decl
              ;

decl:         ident_list T_2P type T_PVIRG
              ;

ident_list:   ident_list T_VIRG IDENTIFIER 
              | IDENTIFIER                 
              ;

type:        INTEGER     
              | REAL      
              | BOOLEAN
              | CHAR
              ;

compound_stmt: T_BEGIN stmt_list END
               ;

stmt_list:    stmt_list T_PVIRG stmt
              | stmt
              ;

stmt:         assign_stmt
              | if_stmt
              | loop_stmt
              | read_stmt
              | write_stmt
              | compound_stmt
              | goto_stmt
              ;

assign_stmt:  IDENTIFIER ASSIGNOP expr
              ;

if_stmt:      IF cond THEN stmt                            
              | ELSE stmt
              ;

cond:         expr
              ;

loop_stmt:    stmt_prefix DO stmt_list stmt_suffix
              ;

stmt_prefix:  WHILE cond
              ;

stmt_suffix:  UNTIL cond
              | END
              ;

read_stmt:    READ T_POPEN ident_list T_PCLOSE
              ;

write_stmt:   WRITE T_POPEN expr_list T_PCLOSE
              ;

goto_stmt:     T_GOTO IDENTIFIER
              ;

expr_list:    expr
              | expr_list T_VIRG expr
              ;

expr:         simple_expr
              | simple_expr RELOP simple_expr
              | simple_expr NOT simple_expr
              ;

simple_expr:  term
              | simple_expr ADDOP term
              | simple_expr MINUSOP term
              ;

term:         factor_a
              | term MULOP factor_a
              ;

factor_a:     MINUSOP factor
              | factor
              ;

factor:       IDENTIFIER
              | constant
              | T_POPEN expr T_PCLOSE
              | NOT factor
              | function_ref
              ;

function_ref: FUNC_ID T_POPEN expr_list T_PCLOSE
              ;

constant:     INTEGER_CONSTANT
              | REAL_CONSTANT
              | CHAR_CONSTANT
              | boolean_constant
              ;

boolean_constant: T_TRUE
                  | T_FALSE
                  ;
%%

int main(){
  yyparse();
}