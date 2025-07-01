%{
    #include <stdio.h>
    #include <stdlib.h>
    extern int yyparse();
    extern FILE* yyin;

    int yylex();
    void yyerror(const char *s);
%}

%token BREAK CONTINUE ELSE IF RETURN WHILE FOR
%token MAIS MENOS VEZES DIVIDIDO MODULO IGUAL DIFERENTE MENOR MENOR_IGUAL MAIOR MAIOR_IGUAL REFERENCIA E_LOGICO OU_LOGICO NEGACAO
%token INT FLOAT VOID CHAR SHORT LONG
%token ASSIGNMENT 
%token CHARACTER STRING IDENTIFIER
%token ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVE FECHA_CHAVE VIRGULA PONTO_VIRGULA
%token DIGIT


%%

source:
    source declaracao
    | source statments
    | //lambda
    ;

tipo:
    INT
    | FLOAT
    | VOID
    | CHAR
    | SHORT
    | LONG
    ;

declaracao:
    tipo IDENTIFIER PONTO_VIRGULA
    | tipo IDENTIFIER ASSIGNMENT inicializacao PONTO_VIRGULA
    | tipo ponteiro IDENTIFIER PONTO_VIRGULA
    | tipo ponteiro IDENTIFIER ASSIGNMENT inicializacao PONTO_VIRGULA
    | tipo IDENTIFIER ABRE_PARENTESES FECHA_PARENTESES PONTO_VIRGULA
    | tipo IDENTIFIER ABRE_PARENTESES lista_parametros FECHA_PARENTESES PONTO_VIRGULA
    | tipo IDENTIFIER ABRE_PARENTESES FECHA_PARENTESES bloqueio
    | tipo IDENTIFIER ABRE_PARENTESES lista_parametros FECHA_PARENTESES bloqueio
    | tipo lista_identificadores PONTO_VIRGULA
    | tipo lista_identificadores ASSIGNMENT inicializacao PONTO_VIRGULA
    ;

inicializacao:
    DIGIT
    | IDENTIFIER
    | STRING
    | CHARACTER
    ;

expression:
    IDENTIFIER ASSIGNMENT expression
    | expression MAIS expression
    | expression MENOS expression
    | expression VEZES expression
    | expression DIVIDIDO expression
    | expression MODULO expression
    | expression IGUAL expression
    | expression DIFERENTE expression
    | expression MENOR expression
    | expression MENOR_IGUAL expression
    | expression MAIOR expression
    | expression MAIOR_IGUAL expression
    | expression E_LOGICO expression
    | expression OU_LOGICO expression
    | expression NEGACAO expression
    | ABRE_PARENTESES expression FECHA_PARENTESES
    | ponteiro expression
    | IDENTIFIER ABRE_PARENTESES FECHA_PARENTESES
    | IDENTIFIER
    | IDENTIFIER ABRE_PARENTESES lista_argumentos FECHA_PARENTESES
    | STRING
    | DIGIT
    | CHARACTER

expression_statment:
    expression
    ;


ponteiro:
    VEZES
    | REFERENCIA
    | VEZES REFERENCIA
    ;


statment:
    expression_statment PONTO_VIRGULA
    | BREAK PONTO_VIRGULA
    | CONTINUE PONTO_VIRGULA
    | RETURN PONTO_VIRGULA
    | RETURN expression_statment PONTO_VIRGULA
    | if_statment
    | while_statment
    | for_statment
    | bloqueio
    ;

statments:
    statment
    | statments statment
    ;

lista_parametros:
    tipo IDENTIFIER
    | tipo ponteiro IDENTIFIER
    | lista_parametros VIRGULA tipo IDENTIFIER
    ;

lista_argumentos:
    expression
    | lista_argumentos VIRGULA expression
    ;

lista_identificadores:
    IDENTIFIER
    | lista_identificadores VIRGULA IDENTIFIER
;


bloqueio:
    ABRE_CHAVE source FECHA_CHAVE
    | ABRE_CHAVE FECHA_CHAVE
    ;

if_statment:
    IF ABRE_PARENTESES expression_statment FECHA_PARENTESES statment
    | IF ABRE_PARENTESES expression_statment FECHA_PARENTESES statment ELSE statment
    ;
while_statment:
    WHILE ABRE_PARENTESES expression_statment FECHA_PARENTESES statment
    ;

for_statment:
    FOR ABRE_PARENTESES expression_statment PONTO_VIRGULA expression_statment PONTO_VIRGULA expression_statment FECHA_PARENTESES statment

%%

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        yyin = fp;
    }
    if(yyin == NULL) {
        yyin = stdin;
    }

    int parserResult = yyparse();

    if(!parserResult){
        printf("the program respect the c-- rules!\n");
        return 0;
    } 
}

void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext;
    fprintf(stderr, "syntax error at line %d: unexpected token '%s'\n", yylineno, yytext);
    fprintf(stderr, "Talvez esteja faltando ponto e vírgula em alguma linha anterior!\n");
    exit(1);
}