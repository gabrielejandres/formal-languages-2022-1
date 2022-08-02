%{
/*
	* Analisador sintatico da linguagem LF
	* Grupo: Antônio Alves, Gabriele Jandres e Victor Cardoso
*/

// Import de libs
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyparse();
void yyerror(char *message);

// Variaveis do lex
extern FILE *yyin;
extern FILE *yyout;

%}

// Opcao para usar a localizacao do bison
%locations

// Definicao de tipos de tokens
%union{
  int Integer;
  float Float;
  char* String;
}

%token <String> IDENTIFIER
%token <Integer> INT
%token <Float> FLOAT

// Operadores
%token <String> SUM
%token <String> MULT
%token <String> EQUALS

// Palavras reservadas e outros tokens
%token <String> IF
%token <String> ELSE
%token <String> WHILE
%token <String> VAR
%token <String> CONST
%token <String> ASSIGNMENT
%token <String> KW_BOOL
%token <String> KW_INT
%token <String> KW_FLOAT
%token <String> TRUE
%token <String> FALSE
%token <String> LPAR
%token <String> RPAR
%token <String> LBRACE
%token <String> RBRACE
%token <String> SEMICOLON
%token <String> COLON
%token <String> COMMA
%token <String> FN
%token <String> RETURN

// Ordem de precedencia
%left MULT SUM
%right ASSIGNMENT

// Regra inicial
%start program

%%

program: /* empty */ 						   { fprintf(yyout, "Regra: program -> epsilon \n"); }
	| program program_body SEMICOLON 		   { fprintf(yyout, "Regra: program -> program program_body SEMICOLON ===> program -> program program_body%s | Informacoes: '%s' => (%d, %d) \n", $3, $3, @3.first_line, @3.first_column); } 
	; 

program_body: declaration					   { fprintf(yyout, "Regra: program_body -> declaration \n"); }
	| function								   { fprintf(yyout, "Regra: program_body -> function \n"); }
	;

declaration: VAR IDENTIFIER COLON type ASSIGNMENT expression 	{ fprintf(yyout, "Regra: declaration -> VAR IDENTIFIER COLON type ASSIGNMENT expression ===> declaration -> %s %s%stype %s expression | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $3, $5, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column, $3, @3.first_line, @3.first_column, $5, @5.first_line, @5.first_column); }
	| VAR IDENTIFIER COLON type 								{ fprintf(yyout, "Regra: declaration -> VAR IDENTIFIER COLON type ===> declaration -> %s %s:type | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column); }
	| CONST IDENTIFIER COLON type ASSIGNMENT expression 		{ fprintf(yyout, "Regra: declaration -> CONST IDENTIFIER COLON type ASSIGNMENT expression ===> declaration -> %s %s%stype %s expression | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $3, $5, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column, $3, @3.first_line, @3.first_column, $5, @5.first_line, @5.first_column); }
	;

expression: IDENTIFIER				{ fprintf(yyout, "Regra: expression -> IDENTIFIER ===> expression -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	| INT 							{ fprintf(yyout, "Regra: expression -> INT ===> expression -> %d | Informacoes: '%d' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	| FLOAT							{ fprintf(yyout, "Regra: expression -> FLOAT ===> expression -> %f | Informacoes: '%f' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	| TRUE 							{ fprintf(yyout, "Regra: expression -> TRUE ===> expression -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	| FALSE 						{ fprintf(yyout, "Regra: expression -> FALSE ===> expression -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	| LPAR expression RPAR			{ fprintf(yyout, "Regra: expression -> LPAR expression RPAR ===> expression -> %sexpression%s | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $3, $1, @1.first_line, @1.first_column, $3, @3.first_line, @3.first_column); }
	| expression SUM expression 	{ fprintf(yyout, "Regra: expression -> expression SUM expression ===> expression -> expression %s expression | Informacoes: '%s' => (%d, %d) \n", $2, $2, @2.first_line, @2.first_column); }
	| expression MULT expression 	{ fprintf(yyout, "Regra: expression -> expression MULT expression ===> expression -> expression %s expression | Informacoes: '%s' => (%d, %d) \n", $2, $2, @2.first_line, @2.first_column); }
	;

type: KW_INT						{ fprintf(yyout, "Regra: type -> KW_INT ===> type -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	| KW_FLOAT 						{ fprintf(yyout, "Regra: type -> KW_FLOAT ===> type -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }	
	| KW_BOOL						{ fprintf(yyout, "Regra: type -> KW_BOOL ===> type -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	;	

function: FN IDENTIFIER LPAR parameters RPAR COLON type LBRACE block RBRACE { fprintf(yyout, "Regra: function -> FN IDENTIFIER LPAR parameters RPAR COLON type LBRACE block RBRACE ==> function -> %s %s%sparameters%s%stype %s block %s | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $3, $5, $6, $8, $10, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column, $3, @3.first_line, @3.first_column, $5, @5.first_line, @5.first_column, $6, @6.first_line, @6.first_column, $8, @8.first_line, @8.first_column, $10, @10.first_line, @10.first_column); }
	;

parameters: /* empty */ 					{ fprintf(yyout, "Regra: parameters -> epsilon \n"); }
	| parameters parameter end_parameters	{ fprintf(yyout, "Regra: parameters -> parameters parameter end_parameters \n"); }
	;

end_parameters: /* empty */ 				{ fprintf(yyout, "Regra: end_parameters -> epsilon \n"); }
	| COMMA									{ fprintf(yyout, "Regra: end_parameters -> COMMA ===>  end_parameters -> %s | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	;

parameter: IDENTIFIER COLON type 			{ fprintf(yyout, "Regra: parameter -> IDENTIFIER COLON type ===> parameter -> %s%s type | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column); }
	;

condition: expression EQUALS expression		{ fprintf(yyout, "Regra: condition -> expression EQUALS expression ===> condition -> expression %s expression | Informacoes: '%s' => (%d, %d) \n", $2, $2, @2.first_line, @2.first_column); } 
	| expression							{ fprintf(yyout, "Regra: condition -> expression \n"); }
	; 

block: /* empty */ 							{ fprintf(yyout, "Regra: block -> epsilon \n"); }
	| block body SEMICOLON					{ fprintf(yyout, "Regra: block -> block body SEMICOLON ===> block -> block body%s | Informacoes: '%s' => (%d, %d) \n", $3, $3, @3.first_line, @3.first_column); }
	;

body: assignment 							{ fprintf(yyout, "Regra: body -> assignment \n"); }
	| conditional							{ fprintf(yyout, "Regra: body -> conditional \n"); }
	| loop									{ fprintf(yyout, "Regra: body -> loop \n"); }
	| RETURN expression						{ fprintf(yyout, "Regra: body -> RETURN expression ===> body -> %s expression | Informacoes: '%s' => (%d, %d) \n", $1, $1, @1.first_line, @1.first_column); }
	;

assignment: IDENTIFIER ASSIGNMENT expression{ fprintf(yyout, "Regra: assignment -> IDENTIFIER ASSIGNMENT expression ===> assignment -> %s %s expression | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column); }
	;

conditional: IF LPAR condition RPAR LBRACE block RBRACE ELSE LBRACE block RBRACE 	{ fprintf(yyout, "Regra: conditional -> IF LPAR condition RPAR LBRACE block RBRACE ELSE LBRACE block RBRACE ===> conditional -> %s %scondition%s %s block %s %s %s block %s | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $4, $5, $7, $8, $9, $11, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column, $4, @4.first_line, @4.first_column, $5, @5.first_line, @5.first_column, $7, @7.first_line, @7.first_column, $8, @8.first_line, @8.first_column, $9, @9.first_line, @9.first_column, $11, @11.first_line, @11.first_column); }
	| IF LPAR condition RPAR LBRACE block RBRACE 									{ fprintf(yyout, "Regra: conditional -> IF LPAR condition RPAR LBRACE block RBRACE ===> conditional -> %s %scondition%s %s block %s | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $4, $5, $7, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column, $4, @4.first_line, @4.first_column, $5, @5.first_line, @5.first_column, $7, @7.first_line, @7.first_column); }
	;

loop: WHILE LPAR condition RPAR LBRACE block RBRACE 								{ fprintf(yyout, "Regra: loop -> WHILE LPAR condition RPAR LBRACE block RBRACE ===> loop -> %s %scondition%s %s block %s | Informacoes: '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d), '%s' => (%d, %d) \n", $1, $2, $4, $5, $7, $1, @1.first_line, @1.first_column, $2, @2.first_line, @2.first_column, $4, @4.first_line, @4.first_column, $5, @5.first_line, @5.first_column, $7, @7.first_line, @7.first_column); }
	;

%%

// Funcao principal que abre o arquivo de entrada e usa o lex e bison para realizar as analises lexica e sintatica
int main(int argc, char *argv[]) {
	yyout = fopen("out/out.txt", "w");

	if(argc > 1) {
		yyin = fopen(argv[1], "r"); // arquivo de entrada fornecido como parametro
        if(yyin == NULL){
            fprintf(yyout, "Erro ao abrir o arquivo %s para leitura", argv[1]);
        }
    } else yyin = fopen("in/in.txt", "r"); // arquivo de entrada default

    yyparse();

	// Fecha os arquivos de entrada e saida
    fclose(yyin);
    fclose(yyout);

    return 0;
}

// Funcao para exibir o erro sintatico que ocorreu
void yyerror(char* message) {
   	fprintf(yyout, "Erro sintatico na linha %d e coluna %d: %s\n", yylloc.first_line - 1, yylloc.first_column, message);
}