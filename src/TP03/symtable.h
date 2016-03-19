#include <map>
#include <string>

class SymbolTable
{
public:
    SymbolTable() {}
    ~SymbolTable() {}

private:
    std::map<std::string, double> table;
};
