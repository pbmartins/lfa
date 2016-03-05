%{
    #include <stdio.h>
    #include <map>
    #include <stack>
    #include <string>
    #include <math.h>
    #include <utility>
    #include <iostream>
    enum { NUM=257, ID, PAREN, ASIGN, ADDSUB, MULDIV, POW, TRIG, EOL, INVALID };
%}

%option noyywrap
%option reentrant
%option noinput nounput

num     ("-")?([0-9]+|[0-9]*\.[0-9]+)((E|e)(\+|\-)?[0-9]+)?
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
{id}(!{trig})       { return ID; }
{addsub}            { return ADDSUB; }
{muldiv}            { return MULDIV; }
{pow}               { return POW; }
{asign}             { return ASIGN; }
{trig}              { return TRIG; }
{paren}             { return PAREN; }
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

void printOPStack(std::stack<std::pair<std::string, int> > op) {
    while(!op.empty()) {
        printf("%s, %d\n", op.top().first.c_str(), op.top().second);
        op.pop();
    }
    printf("\n");
}


void printStack(std::stack<double> op) {
    while(!op.empty()) {
        printf("%f\n", op.top());
        op.pop();
    }
    printf("\n");
}

// Parsing the expression
double calculator(yyscan_t scanner, int inside) {
    std::stack<std::pair<std::string, int> > operators;
    std::stack<double> operands;

    /* do scanning */
    int tid, topOpType;
    std::string op, topOp;
    std::string var;
    double n, n1, n2;
    while ((tid = yylex(scanner)) != 0)
    {
        printf("init - char %c\n", yyget_text(scanner)[0]);
        printStack(operands);
        printOPStack(operators);

        std::map<std::string, double>::iterator it = variables.begin();
        std::cout << "mymap contains:\n";
        for (it=variables.begin(); it!=variables.end(); ++it)
            std::cout << it->first << " => " << it->second << '\n';

        switch (tid)
        {
            case NUM:
                n = atof(yyget_text(scanner));
                operands.push(n);
                break;
            case ID:
                var = yyget_text(scanner);
                if (variables.count(var))
                    operands.push(variables.at(var));
                /*else {
                    if (yylex(scanner) == ASIGN) {                              // check of ASIGN
                        if (yylex(scanner) == NUM) {                            // check for NUM
                            n = atof(yyget_text(scanner));                      // save NUM on stack and on variables map
                            operands.push(n);
                            variables[var] = n;
                        } else
                            throw std::invalid_argument("ERROR: Invalid asignment!");
                    } else
                        throw std::invalid_argument("ERROR: Invalid asignment!");
                }*/
                break;
            case ADDSUB: case MULDIV: case POW: case ASIGN:
                op = yyget_text(scanner);
                while(!operators.empty()) {
                    topOp = operators.top().first;
                    topOpType = operators.top().second;
                    if ((isLeftAssociative(tid) && tid <= topOpType)
                       || (isRightAssociative(tid) && tid < topOpType)) {
                        n2 = operands.top();
                        operands.pop();
                        n1 = operands.top();
                        operands.pop();
                        operands.push(calculate(n1, n2, topOp));
                        operators.pop();
                        continue;
                    }
                    break;
                }
                operators.push(std::make_pair(op, tid));
                break;
            case TRIG:
                op = yyget_text(scanner);
                operands.push(calculate(calculator(scanner, 1), 0, op));
                break;
            case PAREN:
                op = yyget_text(scanner);
                printf("parentesis\n");
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
                            n2 = operands.top();
                            operands.pop();
                            n1 = operands.top();
                            operands.pop();
                            operands.push(calculate(n1, n2, topOp));
                        }
                    }
                    if (inside && operators.empty())
                        return operands.top();
                }
                break;
            case INVALID:
                printf("%s - is no valid!\n", yyget_text(scanner));
                break;
            case EOL:
                printf("end of line\n");
                while(!operators.empty()) {
                    topOp = operators.top().first;
                    topOpType = operators.top().second;
                    operators.pop();
                    n2 = operands.top();
                    operands.pop();
                    n1 = operands.top();
                    operands.pop();
                    operands.push(calculate(n1, n2, topOp));
                    printf("operands - n1: %f %s n2: %f\n", n1, topOp.c_str(), n2);
                }
                printf("ans = %f\n", operands.top());
                return operands.top();
                break;
        }
    }
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
    while (1) 
        printf("ans = %f\n", calculator(scanner, 0));

    /* clean up and quit */
    yylex_destroy(scanner);
    return 0;
}

