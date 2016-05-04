#ifndef __ABSTRACT_SYNTAX_TREE__
#define __ABSTRACT_SYNTAX_TREE__

#include <string>
#include <math.h>
#include "symbol-table.h"
////////////////////////////////////////////////////

/** \brief The base class for all AST nodes */
class ASTNode
{
public:
    ASTNode() {}
    virtual ~ASTNode() {}

    virtual double eval() = 0;
};

////////////////////////////////////////////////////

/** \brief A node representing a numeric constant */
class ASTNodeNum : public ASTNode
{
public:
    ASTNodeNum(double v) : value(v) {}

    ~ASTNodeNum() {}
    
    double eval();
private:
    double value;
};

////////////////////////////////////////////////////

/** \brief A node representing a binary operator */
class ASTNodeBOpr : public ASTNode
{
public:
    ASTNodeBOpr(unsigned char o, ASTNode* l, ASTNode* r) 
        : op(o), left(l), right(r) {}

    ~ASTNodeBOpr();

    double eval();
private:
    unsigned char op;   ///< The operator
    ASTNode* left;      ///< The left side operand
    ASTNode* right;     ///< The right side operand
};

////////////////////////////////////////////////////

/** \brief A node representing a binary operator */
class ASTNodeUOpr : public ASTNode
{
public:
    ASTNodeUOpr(unsigned char o, ASTNode* r) 
        : op(o), right(r) {}

    ~ASTNodeUOpr();

    double eval();
private:
    unsigned char op;   ///< The operator
    ASTNode* right;     ///< The right side operand
};

////////////////////////////////////////////////////

/** \brief A node representing a variable */
class ASTNodeVar : public ASTNode
{
public:
    ASTNodeVar(const char* id, SymbolTable* stp)
        : vid(id), st(stp) {}

    ~ASTNodeVar();

    double eval();

    void store(double val);

private:
    std::string vid;    ///< The variable id
    SymbolTable* st;    ///< The pointer to the symbol table
};

////////////////////////////////////////////////////

/** \brief A node representing a function */
class ASTNodeFunc : public ASTNode
{
public:
    ASTNodeFunc(double (*vf)(double), ASTNode* r)
        : vfunc(vf), right(r) {}

    ~ASTNodeFunc();

    double eval();

private:
    double (*vfunc)(double);
    ASTNode* right;     ///< The right side operand
};

////////////////////////////////////////////////////

#endif
