#include "calculate.h"
#include <cstdlib>
#include <string.h>
#include <stdio.h>
#include <stack>
#include <math.h>

int calculate(const char* u[]) {
    std::stack<int> numbers;
    for (int i = 0; i < strlen(u[0]); i++) {
        char op = *(u[i]);
        if (op == '+' || op == '-' || op == '*' || op == '/' || op == '^') {
            int n1 = numbers.top();
            numbers.pop();
            int n2 = numbers.top();
            numbers.pop();
            switch (op) {
                case '+':
                    numbers.push(n1 + n2);
                    break;
                case '-':
                    numbers.push(n1 - n2);
                    break;
                case '*':
                    numbers.push(n1 * n2);
                    break;
                case '/':
                    numbers.push(n1 / n2);
                    break;
                case '^':
                    numbers.push(pow(n1, n2));
                    break;
            }
        }
            numbers.push(atof(u[0]));
    }
    return numbers.top();
}

char* convert(const char* u[]) {
    // 5 + (1 + 2) × 4 - 3
    // converted: 5 1 2 + 4 × + 3 −
    char to_return[strlen(u[0])];
    char* p = to_return;
    char op[5] = {'+', '-', '*', '/', '^'};

    std::stack<char> operators;
    operators.push('(');
    char c, t;

    for (int i = 0; i <= strlen(u[0]); i++) {
        c = *(u[i]);
        if (c >= '0' && c <= '9') // add numbers to return string
            *(p++) = c;
        else if (c == '(')
            operators.push(c);
        else if (c == ')' || c == '\0') // add operators to return string
            while (1) {
                t = operators.top();
                operators.pop();
                if (t == '(')
                    break;
                *(p++) = t;
            }
        else if (strstr(op, &c)) // add operators to stack
            while (1) {
                t = operators.top();
                operators.pop();
                if (priority(c, t)) {
                    operators.push(c);
                    operators.push(t);
                    break;
                } else
                    *(p++) = t;
            }
    }
    return to_return;
}

int priority(char c, char t){
    int pc, pt;

    if(c == '^')
        pc = 4;
    else if(c == '*' || c == '/')
        pc = 2;
    else if(c == '+' || c == '-')
        pc = 1;
    else if(c == '(')
        pc = 4;

    if(t == '^')
        pt = 3;
    else if(t == '*' || t == '/')
        pt = 2;
    else if(t == '+' || t == '-')
        pt = 1;
    else if(t == '(')
        pt = 0;

    return (pc > pt);
}