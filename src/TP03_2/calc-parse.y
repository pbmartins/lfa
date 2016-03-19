%code {
    #include <math.h>
    #include "calc-lex.h"
    void yyerror(struct CalcData* pp, const char* s);
    #include "calc-data.h"
    #define scanner_ pp->scanner
}

%define api.pure
%defines "calc-parse.h"
%lex-param {scanner_}
%parse-param {struct CalcData* pp}

%union {
    double value;
    char* vid;
}

%token<value> NUM
%token<value> CONST
%token COS
%token SIN
%token TAN
%token SQRT
%token NOTSHOW
%token FUNCT
%token RETURN
%token<vid> ID
%token INVALID

%type<value> opnd fact term exp

%%

calc    :   exp NOTSHOW         { YYACCEPT; }
        |   exp '\n'            { fprintf(stdout, "ans = %g\n", $1); YYACCEPT; }
        |   function '\n'       { YYACCEPT; }
        |	'\n'                { YYACCEPT; }
        |   error '\n'          { YYACCEPT; }
        ;

exp     :	term                { $$ = $1; }
        |	exp '+' term        { $$ = $1 + $3; }
        |	exp '-' term        { $$ = $1 - $3; }
        ;

term    :	fact                { $$ = $1; }
        |	term '*' fact       { $$ = $1 * $3; }
        |	term '/' fact       { $$ = $1 / $3; }
        ;

fact	:	opnd                { $$ = $1; }
        |   opnd '^' fact       { $$ = pow($1, $3); }
        ;

opnd    :	NUM                 { $$ = $1; }
        |   CONST               { $$ = $1; }
        |   ID '=' exp          { $$ = $3; std::string str($1); pp->symt->addToST(str, $3); }
        |   ID                  { std::string str($1); $$ = pp->symt->valueOf(str); }
        |	'(' exp ')'         { $$ = $2; }
        |   COS '(' exp ')'     { $$ = cos($3); }
        |   SIN '(' exp ')'     { $$ = sin($3); }
        |   TAN '(' exp ')'     { $$ = tan($3); }
        |   SQRT '(' exp ')'    { $$ = sqrt($3); }
        |   '-' opnd            { $$ = -$2; }
        ;

function:   FUNCT funcbody ';' endfunc
        ;

funcbody:   exp
        |   RETURN exp
        ;

endfunc :   '\n' endfunc
        |   '}'
        ;

%%

#include <stdio.h>

void yyerror(struct CalcData* pp, const char* s)
{
    fprintf(stderr, "%s, near %s\n", s, yyget_text(pp->scanner));
}

