#include "ast.h"

////////////////////////////////////////////////////

double ASTNodeNum::eval()
{
    return value;
}

////////////////////////////////////////////////////

double ASTNodeBOpr::eval()
{
    switch (op)
    {
        case '+':
            return left->eval() + right->eval();
        case '-':
            return left->eval() - right->eval();
        case '*':
            return left->eval() * right->eval();
        case '/':
            return left->eval() / right->eval();
        case '^':
            return pow(left->eval, right->eval);
        case '=':
            return right->eval();
        default:
            return NAN;
    }
}

////////////////////////////////////////////////////

ASTNodeBOpr::~ASTNodeBOpr()
{
    delete left;
    delete right;
}

////////////////////////////////////////////////////

double ASTNodeUOpr::eval()
{
    switch (op)
    {
        case '-':
            return - right->eval();
        default:
            return NAN;
    }
}

////////////////////////////////////////////////////

ASTNodeUOpr::~ASTNodeUOpr()
{
    delete right;
}

////////////////////////////////////////////////////

ASTNodeVar::~ASTNodeVar()
{
    delete st;
}

////////////////////////////////////////////////////

double ASTNodeVar::eval()
{
    return st->valueOf(vid);
}

////////////////////////////////////////////////////

double ASTNodeFunc::eval()
{
    return vfunc(right->eval);
}

////////////////////////////////////////////////////

ASTNodeFunc::~ASTNodeFunc()
{
    //delete st;
}

////////////////////////////////////////////////////



////////////////////////////////////////////////////
