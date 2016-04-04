#ifndef __SYMBOL_TABLE__
#define __SYMBOL_TABLE__

#include <map>
#include <string>

class SymbolTable
{
public:
    SymbolTable() {}
    ~SymbolTable() {}

    void assign(std::string var, double value);
    double valueOf(std::string var);

private:
    std::map<std::string, double> table;
};

#endif
