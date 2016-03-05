%{
    #include <stdio.h>
    #include <map>
    #include <stack>
    #include <string>
    #include <cstring>
    #include <math.h>
    #include <utility>
    #include <iostream>
    #define PI 3.14159
    #define E 2.71828
    enum { NUM=257, CONST, ID, PAREN, ASIGN, ADDSUB, MULDIV, POW, TRIG, EOL, INVALID };
%}

%option noyywrap
%option reentrant
%option noinput nounput

num     ("-")?([0-9]+|[0-9]*\.[0-9]+)((E|e)(\+|\-)?[0-9]+)?
const   (pi|e)
id      ([a-zA-Z]+[a-zA-Z0-9]*)
addsub  ("+"|"-")
muldiv  ("*"|"/"|"%")
pow     (^)
asign   ("=")
trig    (cos|sin|tan|sqrt)
paren   ("("|")")
any     [abc]*
other   [abc]+

%%

{num}               { return NUM; }
{const}             { return CONST; }
{addsub}            { return ADDSUB; }
{muldiv}            { return MULDIV; }
{pow}               { return POW; }
{asign}             { return ASIGN; }
{trig}              { return TRIG; }
{paren}             { return PAREN; }
{id}                { return ID; }
\n                  { return EOL; }

%%
// Initalize variables map
static std::map<std::string, double> variables;

// Check the associativity of an operator
int isLeftAssociative(int op) {
    return op == ADDSUB || op == MULDIV || op == ASIGN || op == TRIG || op == PAREN;
}

int isRightAssociative(int op) {
    return op == POW;
}

// Calculate operations
double calculate(double n1, double n2, std::string op) {
    if (op == "+")
        return n1 + n2;
    else if (op == "-")
        return n1 - n2;
    else if (op == "*")
        return n1 * n2;
    else if (op == "/")
        return n1 / n2;
    else if (op == "%")
        return (int)n1 + (int)n2;
    else if (op == "^")
        return pow(n1, n2);
    else if (op == "cos")
        return cos(n1);
    else if (op == "sin")
        return sin(n1);
    else if (op == "tan")
        return tan(n1);
    else if (op == "sqrt")
        return sqrt(n1);
    else
        return -1;
}

// Parsing the expression
double calculator(yyscan_t scanner, int inside) {
    std::stack<std::pair<std::string, int> > operators;
    std::stack<std::pair<std::string, double> > operands;

    /* do scanning */
    int tid, topOpType;
    std::string op, topOp, var;
    double n, n1, n2;
    while ((tid = yylex(scanner)) != 0) {
        switch (tid) {
            case NUM:
                n = atof(yyget_text(scanner));
                operands.push(std::make_pair("none", n));
                break;
            case CONST:
                if (strcmp(yyget_text(scanner),"pi") == 0)
                    operands.push(std::make_pair("pi", PI));
                else if (strcmp(yyget_text(scanner),"e") == 0)
                    operands.push(std::make_pair("e", E));
                break;
            case ID:
                var = yyget_text(scanner);
                if (variables.count(var))
                    operands.push(std::make_pair(var, variables.at(var)));
                else
                    operands.push(std::make_pair(var, 0));
                break;
            case ADDSUB: case MULDIV: case POW: case ASIGN:
                op = yyget_text(scanner);
                while(!operators.empty()) {
                    topOp = operators.top().first;
                    topOpType = operators.top().second;
                    if ((isLeftAssociative(tid) && tid <= topOpType)
                       || (isRightAssociative(tid) && tid < topOpType)) {
                        if (topOpType == ASIGN) {
                            n = operands.top().second;
                            operands.pop();
                            var = operands.top().first;
                            operands.pop();
                            variables[var] = n;
                            printf("var %s = %f\n", var.c_str(), variables.at(var));
                            operands.push(std::make_pair(var, variables.at(var)));
                            continue;
                        }
                        n2 = operands.top().second;
                        operands.pop();
                        n1 = operands.top().second;
                        operands.pop();
                        operands.push(std::make_pair("none", calculate(n1, n2, topOp)));
                        operators.pop();
                        continue;
                    }
                    break;
                }
                operators.push(std::make_pair(op, tid));
                break;
            case TRIG:
                op = yyget_text(scanner);
                operands.push(std::make_pair("none", calculate(calculator(scanner, 1), 0, op)));
                break;
            case PAREN:
                op = yyget_text(scanner);
                if (op == "(")
                    operators.push(std::make_pair(op, tid));
                else {
                    while(!operators.empty()) {
                        topOp = operators.top().first;
                        topOpType = operators.top().second;
                        operators.pop();
                        if (topOp == "(")
                            break;
                        if ((isLeftAssociative(tid) && tid <= topOpType)
                           || (isRightAssociative(tid) && tid < topOpType)) {
                            if (topOpType == ASIGN) {
                                n = operands.top().second;
                                operands.pop();
                                var = operands.top().first;
                                operands.pop();
                                variables[var] = n;
                                operands.push(std::make_pair(var, variables.at(var)));
                                continue;
                            }
                            n2 = operands.top().second;
                            operands.pop();
                            n1 = operands.top().second;
                            operands.pop();
                            operands.push(std::make_pair("none", calculate(n1, n2, topOp)));
                        }
                    }
                    if (inside && operators.empty())
                        return operands.top().second;
                }
                break;
            case INVALID:
                printf("%s - is no valid!\n", yyget_text(scanner));
                break;
            case EOL:
                while(!operators.empty()) {
                    topOp = operators.top().first;
                    topOpType = operators.top().second;
                    operators.pop();
                    if (topOpType == ASIGN) {
                        n = operands.top().second;
                        operands.pop();
                        var = operands.top().first;
                        operands.pop();
                        variables[var] = n;
                        operands.push(std::make_pair(var, variables.at(var)));
                        continue;
                    }
                    n2 = operands.top().second;
                    operands.pop();
                    n1 = operands.top().second;
                    operands.pop();
                    operands.push(std::make_pair("none", calculate(n1, n2, topOp)));
                }
                return operands.top().second;
                break;
        }
    }
    return 0;
}


int main(int argc, char *argv[])
{
    /* init the scanner */
    yyscan_t scanner;
    if (yylex_init(&scanner))
    {
        fprintf(stderr, "Fail initing scanner\n");
        return(EXIT_FAILURE);
    }

    /* prepare input stream */
    switch (argc)
    {
        case 1: // read from stdin, the default
        {
            yyset_in(stdin, scanner);
            break;
        }
        case 2: // read from given file
        {
            FILE* fin;
            if ((fin = fopen(argv[1], "r")) == NULL)
            {
                fprintf(stderr, "Fail openning input file \"%s\"\n", argv[1]);
                exit(EXIT_FAILURE);
            }
            yyset_in(fin, scanner);
            break;
        }
        default:
        {
            fprintf(stderr, "Wrong number of arguments\n");
            exit(EXIT_FAILURE);
        }
    }
    while (1) {
        printf(">> ");
        printf("ans = %f\n", calculator(scanner, 0));
    }
    /* clean up and quit */
    yylex_destroy(scanner);
    return 0;
}

