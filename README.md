# C-- Analyzer

Este projeto é um analisador léxico e sintático para uma linguagem fictícia chamada **C--**, inspirada na linguagem C. Foi desenvolvido como parte de um trabalho acadêmico da disciplina de **Linguagens Formais e Autômatos**, utilizando as ferramentas **Flex** e **Bison**.

O analisador lê um arquivo-fonte `.cmm`, identifica e classifica tokens (palavras-chave, identificadores, operadores, delimitadores, etc.), e verifica se o código segue as regras sintáticas definidas para a linguagem C--. Em caso de erro, o analisador informa a linha e o token inesperado.

---

## 🔧 Como rodar o projeto:

O projeto utiliza um **Makefile** para automatizar a compilação e execução.

### 1. Compilação

Para compilar o analisador, basta executar:

```sh
$ make
```

### 2. Rodar testes

Os arquivos `test...` contém exemplos válidos e inválidos para testes.

- Para rodar testes válidos:

```sh
$ make run-ok
```

- Para rodar testes inválidos:

```sh
$ make run-err
```

Esses comandos executam o analisador com os exemplos fornecidos.

### ⚠️ Problemas com caracteres invisíveis

Se ao rodar ocorrer um erro como:

```
' (hex: 0d 00 69)' não pertence ao alfabeto.
make: *** [makefile:17: run-err] Error 1
```

Execute os comandos abaixo para corrigir problemas de codificação/terminadores de linha:

```sh
sudo apt-get install dos2unix
iconv -f utf-8 -t utf-8 test.cmm -o test.cmm
dos2unix test.cmm
iconv -f utf-8 -t utf-8 test_err.cmm -o test_err.cmm
dos2unix test_err.cmm
```

Esses comandos garantem que os arquivos estejam com a codificação correta e que os finais de linha estejam no formato Unix.

---

## 📜 Sobre o Flex

O analisador léxico é definido no arquivo `analise.lex`, utilizando a ferramenta **Flex**. O código está organizado conforme o padrão:

```flex
%{ /* C code */ %}
%%   /* regras de reconhecimento de tokens */
%%   /* funções auxiliares, se houver */
```

### 🔹 Definições Iniciais

- `#include "analise.tab.h"`: importa os tokens definidos no Bison.
- `%option noyywrap`: evita necessidade de definir `yywrap()`.
- `%option yylineno`: ativa rastreamento do número de linha.

Também são definidas expressões regulares auxiliares, como:

```flex
ATRIBUTION          =         // operador =
FLOAT_CONSTANT      [0-9]+(\.[0-9]+)?
NUMERIC_CONSTANT    [0-9]+
CHARACTER_CONSTANT  \'([^"\n]|(\\\"))*\'
STRING_CONSTANT     \"([^"\n]|(\\\"))*\"
IDENTIFIER_CONSTANT [a-zA-Z_][a-zA-Z0-9_]*
```

### 🔹 Regras Léxicas

As regras associam padrões a tokens específicos, como:

```flex
"if"        { return IF; }
"else"      { return ELSE; }
"=="        { return IGUAL; }
"&&"        { return E_LOGICO; }
"int"       { return INT; }
";"         { return PONTO_VIRGULA; }
```

Expressões regulares também são usadas para identificar números, identificadores, caracteres, strings, e atribuições, com mensagens auxiliares no terminal para facilitar a depuração:

```flex
{NUMERIC_CONSTANT} {
    printf("Número encontrado: %s\n", yytext);
    return DIGIT;
}

{IDENTIFIER_CONSTANT} {
    printf("Identificador encontrado: %s\n", yytext);
    return IDENTIFIER;
}
```

### 🔹 Comentários e Espaços

O analisador ignora comentários no estilo `//`, `/* ... */` e diretivas do pré-processador iniciadas por `#`, além de espaços e quebras de linha.

### 🔹 Tratamento de Erros

Se um caractere não reconhecido for encontrado, uma mensagem de erro é exibida com a linha e o conteúdo inválido, e o programa é encerrado:

```flex
. {
    printf("Erro na linha %d: '%s' não pertence ao alfabeto.\n", yylineno, yytext);
    exit(1);
}
```

---

## 🎯 Sobre o Bison

O arquivo `analise.y` define:

- **Tokens recebidos do Flex**: `IF`, `ELSE`, `RETURN`, `WHILE`, `FOR`, operadores aritméticos (`MAIS`, `MENOS`, etc.), operadores relacionais (`IGUAL`, `DIFERENTE`, `MENOR`, etc.), operadores lógicos (`E_LOGICO`, `OU_LOGICO`, `NEGACAO`), tipos (`INT`, `FLOAT`, `VOID`, etc.) e símbolos (`PONTO_VIRGULA`, `ABRE_CHAVE`, etc.).

- **As construções sintáticas aceitas**:
  - Declarações de variáveis e listas de variáveis
  - Atribuições e expressões
  - Blocos de código
  - Comandos de controle de fluxo: `if`, `if-else`, `while`, `for`, `break`, `continue`, `return`
  - Declaração e chamada de funções com ou sem parâmetros
  - Ponteiros e referências
  - Expressões numéricas, relacionais e lógicas

Se a entrada não respeitar a gramática, o Bison gera uma mensagem de erro sintático informando a linha e o token inesperado. Além disso, há uma sugestão de que talvez esteja faltando ponto e vírgula em alguma linha anterior, para facilitar o diagnóstico do erro.

---

## 🧠 Gramática da linguagem C--

```
source → source declaracao
       | source statments
       | λ

tipo → INT | FLOAT | VOID | CHAR | SHORT | LONG

declaracao → tipo IDENTIFIER ;
           | tipo IDENTIFIER = inicializacao ;
           | tipo * IDENTIFIER ;
           | tipo * IDENTIFIER = inicializacao ;
           | tipo IDENTIFIER ( ) ;
           | tipo IDENTIFIER ( lista_parametros ) ;
           | tipo IDENTIFIER ( ) bloqueio
           | tipo IDENTIFIER ( lista_parametros ) bloqueio
           | tipo lista_identificadores ;
           | tipo lista_identificadores = inicializacao ;

inicializacao → DIGIT | IDENTIFIER | STRING | CHARACTER

ponteiro → * | & | * &

expression → IDENTIFIER = expression
           | expression + expression
           | expression - expression
           | expression * expression
           | expression / expression
           | expression % expression
           | expression == expression
           | expression != expression
           | expression < expression
           | expression <= expression
           | expression > expression
           | expression >= expression
           | expression && expression
           | expression || expression
           | ! expression
           | ( expression )
           | ponteiro expression
           | IDENTIFIER
           | IDENTIFIER ( )
           | IDENTIFIER ( lista_argumentos )
           | STRING | DIGIT | CHARACTER

expression_statment → expression

statment → expression_statment ;
         | break ;
         | continue ;
         | return ;
         | return expression_statment ;
         | if_statment
         | while_statment
         | for_statment
         | bloqueio

statments → statment | statments statment

lista_parametros → tipo IDENTIFIER
                 | tipo ponteiro IDENTIFIER
                 | lista_parametros , tipo IDENTIFIER

lista_argumentos → expression
                 | lista_argumentos , expression

lista_identificadores → IDENTIFIER
                      | lista_identificadores , IDENTIFIER

bloqueio → { source } | { }

if_statment → if ( expression_statment ) statment
            | if ( expression_statment ) statment else statment

while_statment → while ( expression_statment ) statment

for_statment → for ( expression_statment ; expression_statment ; expression_statment ) statment
```

---

## 🔗 Referências

### Flex
- [Manual do Flex (GNU)](https://ftp.gnu.org/old-gnu/Manuals/flex-2.5.4/html_mono/flex.html#SEC5)
- [Flex no GeeksforGeeks](https://www.geeksforgeeks.org/flex-fast-lexical-analyzer-generator/)

### Bison
- [Bison Manual](https://www.gnu.org/software/bison/manual/html_node/)
- [Parser com Flex e Bison](https://sayef.tech/post/writing-a-parser-using-flex-and-yaccbison/)
- [Simple C Compiler com Lex](https://medium.com/@princedonda4489/building-a-simple-c-compiler-using-lex-96869fbb1e39)

---

## 👨‍💻 Autores

Projeto desenvolvido por **Eros Lunardon** e **Igor Pinto**.
