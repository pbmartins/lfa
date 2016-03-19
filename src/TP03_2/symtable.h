#include <map>
#include <string>

class SymbolTable
{
public:
    SymbolTable() { }
    ~SymbolTable() { }
    void addToST(std::string vid, double value) { table[vid] = value; }
    double valueOf(std::string vid) { if (table.count(vid)) return table.at(vid); return 0.0; }

private:
    std::map<std::string, double> table;
};
