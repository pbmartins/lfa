%code {
    #include <math.h>
    #include "calc-lex.h"
    #include "calc-data.h"
    void yyerror(struct CalcData* pp, const char*);
    #define scan_info pp->scaninfo
}

%define api.pure
%defines "calc-parse.h"
%lex-param {scan_info}
%parse-param {struct CalcData* pp}

%union
{
    double vnum;
    char* vid;
    char vchar;
    double (*vfunc)(double);
}

%token <vnum> NUM
%token <vid> ID
%token <vnum> CONST
%token <vfunc> FUNC 
%token NOTSHOW
%token <vchar> INVALID

%expect 9

%type <vnum> exp term fact opnd

%%

calc    :   exp NOTSHOW         { YYACCEPT; }
        |   exp '\n'            { pp->result = $1; return 1; }
        |	/* lambda */ '\n'   { pp->result = 0; return 1; }
        |   error '\n'          { pp->result = NAN; return -1; }
        |   { return 0; }
        ;

exp     :	term                { $$ = $1; }
        |	exp '+' term        { $$ = $1 + $3; }
        |	exp '-' term        { $$ = $1 - $3; }
        ;

term    :   fact                { $$ = $1; }
        |   term '*' fact       { $$ = $1 * $3; }
        |   term '/' fact       { $$ = $1 / $3; }
        ;

fact	:	opnd                { $$ = $1; }
        |   opnd '^' fact       { $$ = pow($1, $3); }
        ;

opnd    :	NUM                 { $$ = $1; }
        |   CONST               { $$ = $1; }
        |   ID                  { std::string str($1); $$ = pp->symt->valueOf(str); }
        |   ID '=' exp          { $$ = $3; std::string str($1); pp->symt->assign(str, $3); }
        |	'(' exp ')'         { $$ = $2; }
        |   FUNC '(' exp ')'    { $$ = $1($3); }
        |   '-' opnd            { $$ = -$2; }
        ;
%%

#include <stdio.h>

void yyerror(struct CalcData* pp, const char* s)
{
    fprintf(stderr, "%s\n", s);
}

