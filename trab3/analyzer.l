%{
  /*
	* Analisador lexico da linguagem LF
	* Grupo: Antônio Alves, Gabriele Jandres e Victor Cardoso
*/

// Import de libs
#include <stdio.h>
#include <stdlib.h>

// Header gerado pelo bison
#include "analyzer.tab.h"

// Atualizacao de linhas e colunas
#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line; \
    yylloc.first_column = yylloc.last_column; \
    for(int i = 0; yytext[i] != '\0'; i++) { \
        if(yytext[i] == '\n') { \
            yylloc.last_line++; \
            yylloc.last_column = 0; \
        } \
        else { \
            yylloc.last_column++; \
        } \
    }

// Contador para comentarios aninhados
int nested_comments = 0; 

%}

/* Opcoes para configuracao do lexer */
%option yylineno
%option noyywrap

/* Expressoes regulares para identificar os tokens da linguagem LF */
LETTER [A-Za-z]
DIGIT [0-9]
INTEGER ([1-9]{DIGIT}*)|0
FLOAT ([1-9]{DIGIT}*|0)"."({DIGIT}+)
INLINE_CMT (\/\/[^\n]*)
ID ({LETTER}|_)({LETTER}|{DIGIT}|_)*

/* Estado auxiliar para os comentarios aninhados */
%x BLOCK_CMT

%%

"/*"             { BEGIN(BLOCK_CMT); }
<BLOCK_CMT>{
  "/*"           { ++nested_comments; }
  "*"+"/"        { if (nested_comments) --nested_comments;
                   else BEGIN(INITIAL);
                 } 
  [^\/\*\n]+     {} 
  "*"+           {}
  [\/]           {} 
  \n             {}
}

"if"            { yylval.String = strdup(yytext); return IF; }
"else"          { yylval.String = strdup(yytext); return ELSE; }
"while"         { yylval.String = strdup(yytext); return WHILE; }
"var"           { yylval.String = strdup(yytext); return VAR; }
"const"         { yylval.String = strdup(yytext); return CONST; }
"return"        { yylval.String = strdup(yytext); return RETURN; }
"fn"            { yylval.String = strdup(yytext); return FN; }
"bool"          { yylval.String = strdup(yytext); return KW_BOOL; }
"int"           { yylval.String = strdup(yytext); return KW_INT; }
"float"         { yylval.String = strdup(yytext); return KW_FLOAT; }
"true"          { yylval.String = strdup(yytext); return TRUE; }
"false"         { yylval.String = strdup(yytext); return FALSE; }

"+"             { yylval.String = strdup(yytext); return SUM; }
"*"             { yylval.String = strdup(yytext); return MULT; }
"=="            { yylval.String = strdup(yytext); return EQUALS; }
"="             { yylval.String = strdup(yytext); return ASSIGNMENT; }
"("             { yylval.String = strdup(yytext); return LPAR; }
")"             { yylval.String = strdup(yytext); return RPAR; }
"{"             { yylval.String = strdup(yytext); return LBRACE; }
"}"             { yylval.String = strdup(yytext); return RBRACE; }
";"             { yylval.String = strdup(yytext); return SEMICOLON; }
":"             { yylval.String = strdup(yytext); return COLON; }
","             { yylval.String = strdup(yytext); return COMMA; }
" "             {}
\t              {}
\n              {}

{INTEGER}       { yylval.Integer = atoi(yytext); return INT; }
{FLOAT}         { yylval.Float = atof(yytext); return FLOAT; }
{ID}            { yylval.String = strdup(yytext); return IDENTIFIER; }
{INLINE_CMT}    {}

.               { fprintf(yyout, "Erro lexico na linha %d e coluna %d: simbolo '%s' invalido. \n", yylloc.first_line, yylloc.first_column, yytext); exit(0); }

%%