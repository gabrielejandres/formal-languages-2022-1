# Linguagens Formais | Analisador sintático | 2022.1
*Analisador sintático da linguagem LF*

## Tabela de Conteúdo

1. [Tecnologias utilizadas](#tecnologias-utilizadas)
2. [Estrutura do projeto](#estrutura-do-projeto)
3. [Premissas](#premissas)
4. [Gramática utilizada](#gramática-utilizada)
5. [Como usar o programa?](#como-usar-o-programa)
6. [Exemplo padrão](#exemplo-padrão)
7. [Estrutura da saída](#estrutura-da-saída)
8. [Autores](#autores)

## 🖥️ Tecnologias utilizadas
O projeto foi desenvolvido utilizando a linguagem C e para a compilação recomenda-se o uso do GCC (GNU Compiler Collection). Foi utilizado também o Flex, para a análise léxica e o Bison para a análise sintática.

[![Flex](https://img.shields.io/badge/Flex-2ea44f)](https://westes.github.io/flex/manual/)
[![Bison](https://img.shields.io/badge/Bison-2ea44f)](https://www.gnu.org/software/bison/)
![Badge](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)

## 📂 Estrutura do projeto
O repositório é composto pelos subdiretórios:
* **in**: conjunto de arquivos de entrada.
* **out**: conjunto de arquivos de saída. O arquivo de saída principal é o *out.txt*.

Além disso, o repositório conta com os dois arquivos principais:
* **analyzer.l**: código fonte responsável pela análise léxica usando *Flex*.
* **analyzer.y**: código fonte responsável pela análise sintática usando *Bison*.

## 💬 Premissas

### Comentários
Os comentários não estão sendo retornados pelo analisador léxico e portanto não são tratados no analisador sintático.

### Adição de token
Para separar a lista de parâmetros de uma função, foi utilizada a vírgula. Como inicialmente ela não era um token pertencente à linguagem, foi adicionado o caractere "," à lista de tokens reconhecidos.

### Erro léxico
Caso algum símbolo não reconhecido pela linguagem LF seja lido, o analisador léxico imprimirá no arquivo de saída a informação de que ocorreu um erro léxico, qual foi o símbolo lido e a localização dele no arquivo de entrada. Para obter a informação da linha e coluna dos tokens foi utilizado o recurso *yylloc*.

### Erro sintático
Caso aconteça algum erro sintático no arquivo de entrada, o analisador sintático imprimirá no arquivo de saída a informação de que ocorreu um erro sintático e em qual linha e coluna ele ocorreu. Da mesma forma que no erro léxico, para obter a informação da linha e coluna dos símbolos foi utilizado o recurso *yylloc*. Porém, no caso do erro sintático, observamos que a linha do erro era sempre indicada como sendo uma a mais do que era na realidade, por isso foi necessário realizar a correção da informação da linha em que o erro sintático, subtraindo um dessa informação.

### Bloco de comandos
O bloco de comandos dentro da função, if, else e while pode aparecer em qualquer ordem. 

## 📜 Gramática utilizada
Com base no documento enviado junto à atividade do analisador léxico e utilizando de algumas referências encontradas na internet, criamos a gramática *G = (V, T, S, R)* para reconhecer a linguagem LF, com:
 * *V = {program, program_body, declaration, expression, type, function, parameters, end_parameters, parameter, condition, block, body, assigment, condition, loop}*
 * *T = {VAR, IDENTIFIER, COLON, SEMICOLON, ASSIGMENT, INT, FLOAT, TRUE, FALSE, SUM, MULT, KW_INT, KW_FLOAT, KW_BOOL, FN, LPAR, RPAR, LBRACE, RBRACE, COMMA, EQUALS, IF, ELSE, WHILE}*
 * *S = program* 

 E cujo conjunto de regras *R* é dado por:

```
    program -> ε | program program_body SEMICOLON
    program_body -> declaration | function
    declaration -> VAR IDENTIFIER COLON type ASSIGNMENT expression | VAR IDENTIFIER COLON type | CONST IDENTIFIER COLON type ASSIGNMENT expression
    expression -> IDENTIFIER | INT | FLOAT | TRUE | FALSE | expression SUM expression | expression MULT expression
    type -> KW_INT | KW_FLOAT | KW_BOOL
    function -> FN IDENTIFIER LPAR parameters RPAR COLON type LBRACE block RBRACE
    parameters -> ε | parameters parameter end_parameters
    end_parameters -> ε | COMMA
    parameter -> IDENTIFIER COLON type
    condition -> expression EQUALS expression | expression
    block -> ε | block body SEMICOLON
    body -> assignment | conditional | loop | RETURN expression
    assignment -> IDENTIFIER ASSIGNMENT expression
    condition -> IF LPAR condition RPAR LBRACE block RBRACE ELSE LBRACE block RBRACE | IF LPAR condition RPAR LBRACE block RBRACE 
    loop -> WHILE LPAR condition RPAR LBRACE block RBRACE 
```

## 🤔 Como usar o programa?
1.  Clone esse repositório

2. Utilize o comando abaixo do makefile para compilar o programa e executar o executável gerado com o arquivo de entrada padrão *in/in.txt*:
```
  make run 
```

Caso queira utilizar um arquivo diferente como entrada, utilize:
```
  make run IN=<nome-do-arquivo>
```

## 📝 Exemplo padrão
No arquivo *in/in.txt*, existe um exemplo de código na linguagem LF e a análise sintática correspondente encontra-se no arquivo *out/out.txt*.

## 🚧 Estrutura da saída
O arquivo *out/out.txt* que contém a análise sintática contém linhas com a seguinte estrutura:
```
    Regra: <regra generica> ===> <regra com os lexemas> | Informacoes: <informacoes das linhas e colunas dos lexemas>
```

Por exemplo, para a linha "teste = 8.5 + n", dada por:
```
    Regra: assignment -> IDENTIFIER ASSIGNMENT expression ===> assignment -> teste = expression | Informacoes: 'teste' => (7, 12), '=' => (7, 18)
```
onde 'teste' é um lexema IDENTIFIER, que está na linha 7 e coluna 12 e '=' é um lexema ASSIGNMENT que está na linha 7 e coluna 18.

## 👩‍💻 Autores
* Antônio Alves Pimentel
* Gabriele Jandres Cavalcanti
* Victor Wohlers Cardoso
