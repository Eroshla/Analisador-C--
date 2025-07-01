%{
    #include "analise.tab.h"    
%}

%option noyywrap
%option yylineno

ATRIBUTION      =
FLOAT_CONSTANT      [0-9]+(\.[0-9]+)?
NUMERIC_CONSTANT           [0-9]+
CHARACTER_CONSTANT         \'([^\"\n]|(\\\"))*\'
STRING_CONSTANT            \"([^\"\n]|(\\\"))*\"
IDENTIFIER_CONSTANT        [a-zA-Z_][a-zA-Z0-9_]*

%%

"break"         { return BREAK; }
"continue"      { return CONTINUE; }
"return"        { return RETURN; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"for"           { return FOR; }

"+"             { return MAIS; }
"-"             { return MENOS; }
"*"             { return VEZES; }
"/"             { return DIVIDIDO; }
"%"             { return MODULO; }
"=="            { return IGUAL; }
"!="            { return DIFERENTE; }
"<"             { return MENOR; }
"<="            { return MENOR_IGUAL; }
">"             { return MAIOR; }
">="            { return MAIOR_IGUAL; }
"&"             { return REFERENCIA; }
"&&"            { return E_LOGICO; }
"||"            { return OU_LOGICO; }
"!"             { return NEGACAO; }

"int"           { return INT; }
"float"         { return FLOAT; }
"void"          { return VOID; }
"char"          { return CHAR; }
"long"          { return LONG; }
"short"         { return SHORT; }

"("             { return ABRE_PARENTESES; }
")"             { return FECHA_PARENTESES; }
"{"             { return ABRE_CHAVE; }
"}"             { return FECHA_CHAVE; }
","             { return VIRGULA; }
";"             { return PONTO_VIRGULA; }


{ATRIBUTION} {
    printf("Atribuição encontrada: %s\n", yytext);
    return ASSIGNMENT;
}

{FLOAT_CONSTANT} {
    printf("Número real encontrado: %s\n", yytext);
    return DIGIT;
}

{NUMERIC_CONSTANT} {
    printf("Número encontrado: %s\n", yytext);
    return DIGIT;
}

{CHARACTER_CONSTANT} {
    printf("Caractere constante encontrado: %s\n", yytext);
    return CHARACTER;
}

{IDENTIFIER_CONSTANT} {
    printf("Identificador encontrado: %s\n", yytext);
    return IDENTIFIER;
}

{STRING_CONSTANT} {
    printf("String encontrada: %s\n", yytext);
    return STRING;
}

\#[^\n]*                 ;
\/\/[^\n]*               ;
\/\*([^*]|\*+[^*/])*\*+\/ ;

[ \t\n]+                ;

. {
    printf("DEBUG: yytext='%s' (hex: %02x %02x %02x)\n", yytext, yytext[0], yytext[1], yytext[2]);
    printf("Erro na linha %d: '%s' não pertence ao alfabeto.", yylineno, yytext);
    exit(1);
}

%%