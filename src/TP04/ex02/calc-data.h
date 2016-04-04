#ifndef __CALC_DATA__
#define __CALC_DATA__

#include "calc-lex.h"
#include "symbol-table.h"
#include "ast.h"

typedef struct CalcData
{
    yyscan_t scaninfo;
    SymbolTable* symt;
    ASTNode* ast;
} CalcData;

#endif
