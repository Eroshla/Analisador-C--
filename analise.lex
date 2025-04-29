%option noyywrap
/* Faz com que o analisador rode ate o fim do yyin (arq recebido) e retorne automaticamente. */ 
%option yylineno
/* Contador de linha próprio do flex */

KEYWORDS break | if | else | for | return | struct | while | return 
TYPES int | float | char | string | long | double | short | void
OPERATORS \+ | \- | \* | \/ | % | \|\ | && | == | != | <= | >= | > | < |
ATRIBUTION =
DIGIT [0-9]
CHARACTER_CONSTANT \'[a-zA-Z0-9!@#\$%¨&*()\-\+=(){}[]]/'
STRING_CONSTANT \"[a-zA-Z0-9!@#\$%\^&*()\-=\+\\]*\"
IDENTIFIER_CONSTANT [a-zA-Z_][a-zA-Z0-9_]*
DELIMITERS [(){}\[\];,]
INVALID_IDENTIFIER {DIGIT}+{IDENTIFIER_CONSTANT}

%%

{KEYWORDS}{
    printf("keyword encontrado: %s\n", yytext);
}

{TYPES}{
    printf("Tipo encontrado: %s\n", yytext)
}
{OPERATORS}{
    printf("Operador encontrado: %s\n", yytext)
}
{ATRIBUTION}{
    printf("Atribuição encontrada: %s\n", yytext)
}
{DIGIT}{
    printf("Digito encontrado: %s\n", yytext)
}
{CHARACTER_CONSTANT}{
    printf("Caracter constante encontrado: %s\n", yytext)
}