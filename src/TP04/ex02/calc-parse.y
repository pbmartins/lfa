%code top {
    #include "ast.h"
}

%code {
    #include "ast.h"
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
    ASTNode* vnode;
    double (*vfunc)(double);
}

%token <vnum> NUM
%token <vid> ID
%token <vnum> CONST
%token <vchar> INVALID
%token <vfunc> FUNC 
%token NOTSHOW

%expect 9

%type <vnode> exp term fact opnd

%%

calc    :   exp NOTSHOW      { YYACCEPT; }
        |   exp '\n'         { pp->ast = $1; return 1; }
        |	/* lambda */ '\n'   { pp->ast = NULL; return 1; }
        |   error '\n'          { pp->ast = NULL; return -1; }
        |   { return 0; }
        ;

exp     :	term                { $$ = $1; }
        |	exp '+' term        { $$ = new ASTNodeBOpr('+', $1, $3); }
        |	exp '-' term        { $$ = new ASTNodeBOpr('-', $1, $3); }
        ;

term    :   fact                { $$ = $1; }
        |   term '*' fact       { $$ = new ASTNodeBOpr('*', $1, $3); }
        |   term '/' fact       { $$ = new ASTNodeBOpr('/', $1, $3); }
        ;

fact	:	opnd                { $$ = $1; }
        |   opnd '^' fact       { $$ = new ASTNodeBOpr('^', $1, $3); }
        ;

opnd    :	NUM                 { $$ = new ASTNodeNum($1); }
        |   CONST               { $$ = new ASTNodeNum($1); }
        |   ID                  { $$ = new ASTNodeVar($1, pp->symt); }
        |   ID '=' exp          { $$ = new ASTNodeBOpr('=', new ASTNodeVar($1, pp->symt), $3); }
        |	'(' exp ')'         { $$ = $2; }
        |   FUNC '(' exp ')'    { $$ = new ASTNodeFunc($1, $3); }
        |   '-' opnd            { $$ = new ASTNodeUOpr('-', $2); }
        ;

%%

#include <stdio.h>

void yyerror(struct CalcData* pp, const char* s)
{
    fprintf(stderr, "%s\n", s);
}

