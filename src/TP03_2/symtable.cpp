#include "symtable.h"

/*void SymbolTable::addToST(std::string vid, double value) {
    table[vid] = value;
}
*/
double SymbolTable::valueOf(std::string vid) {
    if (table.count(vid))
        return table.at(vid);
    return 0.0;
}
