%{
  #include <iostream>
  #include <unordered_map>
  #include <vector>
  #include <deque>
  #include <string>
  #include <stdlib.h>
  #include "symbolInfo.hpp"
  #include "tree.hpp"
  extern int yylex();
  extern int yyparse();
  inline void yyerror(const char *s) { std::cout << "Error: " << s << std::endl; }
  inline void error_msg(const char *msg) { std::cerr << msg << std::endl; exit(1); }
  int universal_expr_id = 0;
  std::vector<std::string> id_list;
  std::deque<std::string> assignment_order;
  std::unordered_map<std::string, symbolInfo> symbol_table;
  tree* root = new tree (UNINITIALIZED, "root");
  tree* current;
  std::vector<tree*> right;
  std::unordered_map<int, tree*> expr_list;
  std::unordered_map<std::string, std::deque<std::tuple<std::string, symbolInfo, symbolInfo, symbolInfo>>> expr_quad;
%}

%union{
  char* string_t;
  int expr_id;
}

%start program

%token  PROGRAM
%token  INTEGER
%token  REAL
%token  BOOLEAN
%token  CHAR
%token  FUNCTIONAL
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
%token  T_GOTO
%token <string_t>  T_TRUE
%token <string_t> T_FALSE
%token <string_t> MINUSOP
%token <string_t> NOT

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

%type <string_t> type
%type <string_t> functional_type
%type <string_t> ident_list
%type <expr_id> expr

%left   ASSIGNOP
%right  RELOP ADDOP MULOP MINUSOP

%%
program:      PROGRAM IDENTIFIER T_PVIRG decl_list compound_stmt {
                for (auto ids = assignment_order.begin(); ids != assignment_order.end(); ++ids) {
                  auto& i = expr_quad[*ids];
                  for (auto it = i.rbegin(); it != i.rend(); it++) {
                    std::cout << "(" << std::get<0>(*it) << ", " << std::get<1>(*it) << ", " << std::get<2>(*it) << ", " << std::get<3>(*it) << ")" << std::endl;
                  }
                  std::cout << std::endl;
                }
              }
              ;

decl_list:    decl_list decl
              | decl
              ;

decl:         ident_list T_2P type T_PVIRG {
                auto it = id_list.begin();
                while (it != id_list.end()){
                  symbol_table.insert({*it, symbolInfo ($3, "0")});
                  it = id_list.erase(it);
                }
              }
              | functional_type IDENTIFIER T_POPEN arg_list T_PCLOSE T_2P type decl_list compound_stmt T_PVIRG
              | functional_type IDENTIFIER T_POPEN T_PCLOSE T_2P type decl_list compound_stmt T_PVIRG
              ;

ident_list:   ident_list T_VIRG IDENTIFIER {
                id_list.push_back(std::string($3));
              }
              | IDENTIFIER {
                id_list.push_back(std::string($1));
              }
              ;

arg_list:     arg_list T_VIRG arg
              | arg
              ;

arg:          IDENTIFIER T_2P type
              | IDENTIFIER
              ;

type:        INTEGER {$$ = "INTEGER";}
              | REAL {$$ = "REAL";}
              | BOOLEAN {$$ = "BOOLEAN";}
              | CHAR {$$ = "CHAR";}
              ;

functional_type:  FUNCTIONAL {$$ = "FUNCTIONAL";}
                  ;

compound_stmt: T_BEGIN stmt_list END
               ;

stmt_list:    stmt_list T_PVIRG stmt
              | stmt
              ;

stmt: IDENTIFIER T_2P unlabeled_stmt
      | unlabeled_stmt
      ;

unlabeled_stmt: open_unlabeled_stmt
                | closed_unlabeled_stmt
                ;

non_if_stmt:    assign_stmt
                | loop_stmt
                | read_stmt
                | write_stmt
                | compound_stmt
                | goto_stmt
                ;

assign_stmt:  IDENTIFIER ASSIGNOP expr {
                std::string id ($1);
                int expr_id = $3;
                expr_quad.insert({id, gen_quad($1, expr_list[expr_id])});
                assignment_order.push_back(id);
                check_type(id, symbol_table, expr_list[expr_id], expr_quad[id]);
                eval_tree(id, expr_list[expr_id], symbol_table);
              }
              ;

open_unlabeled_stmt: IF cond THEN unlabeled_stmt
                     | IF cond THEN closed_unlabeled_stmt ELSE open_unlabeled_stmt
                     ;

closed_unlabeled_stmt: non_if_stmt
                 | IF cond THEN closed_unlabeled_stmt ELSE closed_unlabeled_stmt
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

function_ref: FUNC_ID T_POPEN expr_list T_PCLOSE
              | IDENTIFIER T_POPEN expr_list T_PCLOSE
              | IDENTIFIER T_POPEN T_PCLOSE
              ;

expr_list:    expr
              | expr_list T_VIRG expr {
                expr_list.insert({universal_expr_id, current});
                universal_expr_id++;
              }
              ;

expr:         simple_expr {expr_list.insert({universal_expr_id, current}); $$ = universal_expr_id; universal_expr_id++;}
              | simple_expr RELOP simple_expr {
                current = new tree (EXPR, std::string($2)); 
                current->right = right.back(); 
                right.pop_back(); 
                current->left = right.back(); 
                right.pop_back();
                right.push_back(current);
                //expr_list.push_back(current);
              }
              | simple_expr NOT simple_expr {
                current = new tree (EXPR, std::string($2)); 
                current->right = right.back(); 
                right.pop_back(); 
                current->left = right.back(); 
                right.pop_back();
                right.push_back(current);
                //expr_list.push_back(current);
              }
              ;

simple_expr:  term
              | simple_expr ADDOP term {
                current = new tree (EXPR, std::string($2)); 
                current->right = right.back(); 
                right.pop_back(); 
                current->left = right.back(); 
                right.pop_back();
                right.push_back(current);
              }
              | simple_expr MINUSOP term {
                current = new tree (EXPR, std::string($2)); 
                current->right = right.back(); 
                right.pop_back(); 
                current->left = right.back(); 
                right.pop_back();
                right.push_back(current);
              }
              ;

term:         factor_a
              | term MULOP factor_a {
                current = new tree(EXPR, std::string($2));
                current->right = right.back();
                right.pop_back();
                current->left = right.back();
                right.pop_back();
                right.push_back(current);
              }
              ;

factor_a:     MINUSOP factor
              | factor
              ;

factor:       IDENTIFIER {current = new tree (ID, std::string($1)); right.push_back(current);}
              | constant {}
              | T_POPEN expr T_PCLOSE {}
              | NOT factor {current = new tree (OPERATOR, std::string($1)); current->right = right.back(); right.pop_back(); right.push_back(current);}
              | function_ref {current = new tree (ID, std::string("func")); right.push_back(current); }
              ;

constant:     INTEGER_CONSTANT {current = new tree (INTEGER_T, std::string($1)); right.push_back(current);}
              | REAL_CONSTANT {current = new tree (REAL_T, std::string($1)); right.push_back(current);}
              | CHAR_CONSTANT {current = new tree (CHAR_T, std::string($1)); right.push_back(current);}
              | boolean_constant {}
              ;

boolean_constant: T_TRUE {current = new tree (BOOL_T, std::string($1)); right.push_back(current);}
                  | T_FALSE {current = new tree (BOOL_T, std::string($1)); right.push_back(current);}
                  ;
%%

int main(int argc, char* argv[]){
  if (argc < 2) {
    error_msg("Please enter the source file.");
  } else if (argc > 2) {
    error_msg("Please enter only one source file.");
  }
  FILE* source = fopen(argv[1], "r");
  if (!source) {
    error_msg("Could not open source file.");
  }
  stdin = source;
  yyparse();
}
