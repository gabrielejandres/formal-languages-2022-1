# Linguagens Formais | Analisador léxico | 2022.1
*Analisador léxico da linguagem LF*

## Tabela de Conteúdo

1. [Tecnologias utilizadas](#tecnologias-utilizadas)
2. [Tokens reconhecidos](#tokens-reconhecidos)
3. [Comentários](#comentarios)
4. [Como usar o programa?](#como-usar-o-programa)
5. [Exemplo padrão](#exemplo-padrão)
6. [Autores](#autores)

## 🖥️ Tecnologias utilizadas
O projeto foi desenvolvido utilizando a linguagem C e para a compilação recomenda-se o uso do GCC (GNU Compiler Collection). Foi utilizado também o Flex, que é um programa de computador que gera analisadores lexicais.

![Badge](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)

## 🪙 Tokens reconhecidos
- Identificadores (Token IDENTIFIER): uma sequência de letras, dígitos e sublinhados, começando com uma letra ou sublinhado. A linguagem diferencia maiúsculas e minúsculas.
- Literais inteiros (Token INT): uma sequência de dígitos não começada por zero.
- Literais float (Token FLOAT): Obrigatoriamente possui 3 partes - (1) uma sequência com um ou
mais dígitos, sendo o primeiro diferente de zero ou um zero, (2) um ponto e (3) pelo
menos um dígito após o ponto.
- Operadores binários:
  - Operador de soma (Token SUM OPERATOR): +
  - Operador de multiplicação (Token TIMES OPERATOR): *
  - Operador de comparação (Token EQUALS OPERATOR): ==
- Palavras reservadas e outros tokens: if, else, while, var, const, return, fn, = (atribuição), bool (tipo), int (tipo), float (tipo), true e false, (, ), {, }, ;, :
  - Os tokens correspondentes são sempre da forma *KEYWORD name*, onde *name* é uma das palavras reservadas acima.

## 💬 Comentários
Um comentário pode aparecer em qualquer lugar na linguagem LF. São dois estilos de comentários:
  - Comentário de linha: até o final da linha, iniciado por //
  - Comentário de bloco: iniciado por /* e terminado por */, podendo haver comentários aninhados.

Os comentários não são tokens e portanto são ignorados pelo analisador léxico.

Em relação aos comentários aninhados, é possível ter três casos:
  - Comentários aninhados com as mesmas quantidades de abertura e fechamento, por exemplo /* a /* b */ c*/
  - Comentários aninhados com mais aberturas do que fechamentos, por exemplo /* a /* b */
  - Comentários aninhados com mais fechamentos do que aberturas, por exemplo /* a */ b */

No analisador léxico desenvolvido, somente o primeiro caso será considerado um comentário válido. 
  - No segundo caso, como existe uma abertura sem um fechamento, tudo o que vier após esse comentário será considerado comentário também, uma vez que temos uma abertura sobrando.
  - No terceiro caso, somente a primeira parte será considerada um comentário, o *b* será considerado como um token do tipo IDENTIFIER e o * será um TIMES OPERATOR. Quando a / for lida, ocorrerá um erro léxico porque tal caractere não é aceito na linguagem.

## 🤔 Como usar o programa?
1.  Clone esse repositório

2. Utilize o comando abaixo do makefile para usar o flex, compilar o programa e executar o executável gerado com o arquivo de entrada padrão *in.txt*:
```
  make run 
```

Caso queira utilizar um arquivo diferente como entrada, utilize:
```
  make run IN=<nome-do-arquivo>
```

O resultado retornado pelo analisador léxico estará no arquivo *out.txt*. Cada linha do arquivo estará no formato *(TIPO DO TOKEN, LEXEMA, LINHA INICIAL, COLUNA INICIAL)*, onde a contagem de linhas e coluna inicia em 0.

## 📝 Exemplo padrão
No arquivo *in.txt*, existe um exemplo de código na linguagem LF com alguns tokens reconhecidos no arquivo *out.txt*.

## 👩‍💻 Autores
* Antônio Alves Pimentel
* Gabriele Jandres Cavalcanti
* Victor Wohlers Cardoso