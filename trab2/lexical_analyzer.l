%{
// Import de libs
#include <stdio.h>
#include <stdlib.h>

// Definicoes
#define LINE_BREAK 10

// Declaracoes
typedef enum _TOKEN {
    _eof = -1, 
    _id = 0, 
    _int = 1,
    _float = 2,
    _sum = 3,
    _mult = 4,
    _equals = 5,
    _inline_comment = 6,
    _block_comment = 7,
    _keyword_if = 8,
    _keyword_else = 9,
    _keyword_while = 10,
    _keyword_var = 11,
    _keyword_const = 12,
    _keyword_return = 13,
    _keyword_fn = 14,
    _keyword_assignment = 15,
    _keyword_bool = 16,
    _keyword_int = 17,
    _keyword_float = 18,
    _keyword_true = 19,
    _keyword_false = 20,
    _keyword_open_parentheses = 21,
    _keyword_close_parentheses = 22,
    _keyword_open_brace = 23,
    _keyword_close_brace = 24,
    _keyword_semicolon = 25,
    _keyword_colon = 26,
    _invalid = 27
} TOKEN;

int column = 0; // contador de colunas
int row = 0;    // contador de linhas
int token;      // variavel auxiliar para leitura do token
char* tokens[] = { "IDENTIFIER", "INTEGER", "FLOAT", "SUM OPERATOR", "TIMES OPERATOR", "EQUALS OPERATOR", "INLINE COMMENT", "BLOCK COMMENT", "KEYWORD IF", "KEYWORD ELSE", "KEYWORD WHILE", "KEYWORD VAR", "KEYWORD CONST", "KEYWORD RETURN", "KEYWORD FN", "ASSIGNMENT", "KEYWORD BOOL", "KEYWORD INT", "KEYWORD FLOAT", "KEYWORD TRUE", "KEYWORD FALSE", "KEYWORD OPEN PAR", "KEYWORD CLOSE PAR", "KEYWORD OPEN BRACE", "KEYWORD CLOSE BRACE", "KEYWORD SEMICOLON", "KEYWORD COLON", "LEXICAL ERROR"};

%}

LETTER [A-Za-z]
DIGIT [0-9]
INTEGER ([1-9]{DIGIT}*)|0
FLOAT ([1-9]{DIGIT}*|0)"."({DIGIT}+)
INLINE_CMT (\/\/[^\n]*)
BLOCK_CMT (\/\*[^\0]*\*\/)
ID ({LETTER}|_)({LETTER}|{DIGIT}|_)*

%%

<<EOF>>         { return _eof; }

"if"            { return _keyword_if; }
"else"          { return _keyword_else; }
"while"         { return _keyword_while; }
"var"           { return _keyword_var; }
"const"         { return _keyword_const; }
"return"        { return _keyword_return; }
"fn"            { return _keyword_fn; }
"bool"          { return _keyword_bool; }
"int"           { return _keyword_int; }
"float"         { return _keyword_float; }
"true"          { return _keyword_true; }
"false"         { return _keyword_false; }

"+"             { return _sum; }
"*"             { return _mult; }
"=="            { return _equals; }
"("             { return _keyword_open_parentheses; }
")"             { return _keyword_close_parentheses; }
"{"             { return _keyword_open_brace; }
"}"             { return _keyword_close_brace; }
";"             { return _keyword_semicolon; }
":"             { return _keyword_colon; }
" "             { column += strlen(yytext); }
\t              { column += strlen(yytext); }
\n              { row += 1; column = 0; }

{INTEGER}       { return _int; }
{FLOAT}         { return _float; }
{INLINE_CMT}    { return _inline_comment; }
{BLOCK_CMT}     { return _block_comment; }
{ID}            { return _id; }

.               { return _invalid; }

%%

// Codigo auxiliar do Flex
int yywrap(void) { return 1; }

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r"); // arquivo de entrada
    yyout = fopen("out.txt", "w"); // arquivo de saida

    // Le todos os tokens ate end of file
    while ((token = (TOKEN) yylex()) != _eof) {
        // Retorna para o arquivo uma quadrupla com (tipo de token, lexema, linha inicial, coluna inicial)
        fprintf(yyout, "(%s, %s, %d, %d) \n", tokens[token], yytext, row, column); 

        // Incrementa o numero da coluna com os caracteres lidos
        column += strlen(yytext);

        // Incrementa as quebras de linha do comentario de bloco
        if (token == _block_comment) for(int i = 0; i < strlen(yytext); i++) if (yytext[i] == LINE_BREAK) row += 1;
        
        // Caso de erro lexico
        if (token == _invalid) break;
    }

    // Fecha os arquivos de entrada e saida
    fclose(yyin);
    fclose(yyout);
    
    return 0;
}