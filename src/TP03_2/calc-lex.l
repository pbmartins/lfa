%{
    #include <stdlib.h>
    #include <math.h>
    #include <string>
    #include "calc-parse.h"
    double constValue(char* text);
%}


%option noyywrap
%option nounput noinput
%option nodefault yylineno
%option reentrant bison-bridge
%option header-file="calc-lex.h"

nint    [0-9]+
nreal   ([0-9]+|[0-9]*\.[0-9]+)((E|e)(\+|\-)?[0-9]+)?
num     {nint}|{nreal}

const   (pi|e)

cos     cos
sin     sin
tan     tan
sqrt    sqrt

id      [a-zA-Z_][a-zA-Z0-9_]*

notshow [;][\n]

args    ({id}([,][ ]?{id})*)?

funct   "define "{id}[ ]?"("{args}")"[ ]?[\n]?"{"[\n]?

endf    [;][\n]*[}]

return  "return "

valid   [-+()*/=\n^,{};]

spaces  [ \t]+

%%

{num}       { yylval->value = atof(yytext); return NUM; }

{const}     { yylval->value = constValue(yytext); return CONST; }

{cos}       { return COS; }
{sin}       { return SIN; }
{tan}       { return TAN; }
{sqrt}      { return SQRT; }

{notshow}   { return NOTSHOW; }

{funct}     { return FUNCT; }


{return}    { return RETURN; }

{id}        { yylval->vid = strdup(yytext); return ID; }

{spaces}    { }

{valid}     { return yytext[0]; }

.           { return INVALID; }

%%

double constValue(char* text) {
    if (!strcmp(text, "pi"))
        return 3.1415;
    else if (!strcmp(text, "e"))
        return 2.7183;
    else
        return -1;
}
