%{
    #include <stdlib.h>

    #include "calc-parse.h"
%}


%option noyywrap
%option nounput noinput
%option nodefault yylineno
%option reentrant bison-bridge
%option header-file="calc-lex.h"

nint    [0-9]+
nreal   ([0-9]+|[0-9]*\.[0-9]+)((E|e)(\+|\-)?[0-9]+)?
num     {nint}|{nreal}

func    (cos|sin|tan|sqrt)

id      [a-zA-Z_][a-zA-Z0-9_]*

define  "define "

initf   [ ]*[\n]*[{]

endf    [;][\n]*[}]

return  "return "

valid   [-+()*/=\n^,]

spaces  [ \t]+

%%

{num}       { return NUM; }

{func}      { return FUNC; }

{define}    { return DEFINE; }

{initf}     { return INITFUNC; }

{endf}      { return ENDFUNC; }

{return}    { return RETURN; }

{id}        { return ID; }

{spaces}    { }

{valid}     { return yytext[0]; }

.           { return INVALID; }

%%

