#include "symbol-table.h"

#include <stdio.h>

void SymbolTable::assign(std::string var, double value)
{
    table[var] = value;
}

double SymbolTable::valueOf(std::string var)
{
    if (table.count(var))
        return table.at(var);
    return 0.0;
}

