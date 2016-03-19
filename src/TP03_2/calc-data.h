#ifndef __CALC_DATA__
#define __CALC_DATA__

#include "calc-lex.h"
#include "symtable.h"

typedef struct CalcData
{
    yyscan_t scanner;
    SymbolTable* symt;
} CalcData;

#endif
