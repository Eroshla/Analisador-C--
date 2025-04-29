%option noyywrap
%option yylineno

KEYWORDS        "break"|"if"|"else"|"for"|"return"|"struct"|"while"
TYPES           "int"|"float"|"char"|"string"|"long"|"double"|"short"|"void"
OPERATORS       \+|\-|\*|\/|%|\|\||&&|==|!=|<=|>=|>|<
ATRIBUTION      =
DIGIT           [0-9]+
CHARACTER_CONSTANT  \'[a-zA-Z0-9!@#\$%¨&*()\-+=\[\]{}]\' 
STRING_CONSTANT     \"([^\\\n"]|\\.)*\"
IDENTIFIER_CONSTANT [a-zA-Z_][a-zA-Z0-9_]*
DELIMITERS      [(){}\[\];,]
INVALID_IDENTIFIER {DIGIT}+{IDENTIFIER_CONSTANT}

%%

{KEYWORDS} {
    printf("Keyword encontrada: %s\n", yytext);
}

{TYPES} {
    printf("Tipo encontrado: %s\n", yytext);
}

{OPERATORS} {
    printf("Operador encontrado: %s\n", yytext);
}

{ATRIBUTION} {
    printf("Atribuição encontrada: %s\n", yytext);
}

{DIGIT} {
    printf("Número encontrado: %s\n", yytext);
}

{CHARACTER_CONSTANT} {
    printf("Caractere constante encontrado: %s\n", yytext);
}

{STRING_CONSTANT} {
    printf("String encontrada: %s\n", yytext);
}

{IDENTIFIER_CONSTANT} {
    printf("Identificador encontrado: %s\n", yytext);
}

{DELIMITERS} {
    printf("Delimitador encontrado: %s\n", yytext);
}

{INVALID_IDENTIFIER} {
    printf("Identificador inválido encontrado: %s\n", yytext);
}

\#[^\n]*                 ;
\/\/[^\n]*               ;
\/\*([^*]|\*+[^*/])*\*+\/ ;

[ \t\n]+                ;

. {
    printf("Erro na linha %d: '%s' não pertence ao alfabeto.\n", yylineno, yytext);
    exit(1);
}

%%

int main() {
    yylex();
    return 0;
}