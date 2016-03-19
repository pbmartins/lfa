%code {
    #include "calc-lex.h"
    void yyerror(struct CalcData* pp, const char* s);
    #include "calc-data.h"
    #define scanner_ pp->scanner
}

%define api.pure
%defines "calc-parse.h"
%lex-param {scanner_}
%parse-param {struct CalcData* pp}

%token NUM
%token FUNC
%token DEFINE
%token INITFUNC
%token ENDFUNC
%token RETURN
%token ID
%token INVALID

%%

calc    :   inst '\n' { YYACCEPT; }
        |   func '\n' { YYACCEPT; }
        |	'\n' { YYACCEPT; }
        |   error '\n' { YYACCEPT; }
        ;

inst    :   exp
        |   ID '=' exp
        ;

exp     :	term
        |	exp '+' term
        |	exp '-' term
        ;

term    :	fact
        |	term '*' fact
        |	term '/' fact
        ;

fact	:	pow 
        |   pow '^' fact
        ;

pow     :  '-' pow
        |  opnd
        ;

opnd    :	NUM
        |   ID
        |	'(' exp ')'
        |   FUNC '(' exp ')'
        ;

func    :   DEFINE ID '(' param ')' INITFUNC funcbody ENDFUNC
        ;

param   :   ID
        |   param ',' ID
        ;

funcbody:   ID '=' exp
        |   RETURN exp
        ;


%%

#include <stdio.h>

void yyerror(struct CalcData* pp, const char* s)
{
    fprintf(stderr, "%s, near %s\n", s, yyget_text(pp->scanner));
}

