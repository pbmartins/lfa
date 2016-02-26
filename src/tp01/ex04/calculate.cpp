#include "calculate.h"
#include <cstdlib>
#include <string>
#include <sstream>
#include <stdio.h>
#include <stack>
#include <utility>
#include <cassert>
#include <vector>
#include <initializer_list>
#include <math.h>

static int LEFT_ASSOC = 0, RIGHT_ASSOC = 1;
static std::map<char, std::vector<int> > operators_list;
//static std::map<std::string, std::string> variables;

double calculate(char* u, variablesMap* variables) {
    // Initialize operator list
    operators_list['+'] = std::vector<int>();
    operators_list.at('+').push_back(0);
    operators_list.at('+').push_back(LEFT_ASSOC);
    operators_list['-'] = std::vector<int>();
    operators_list.at('-').push_back(0);
    operators_list.at('-').push_back(LEFT_ASSOC);
    operators_list['*'] = std::vector<int>();
    operators_list.at('*').push_back(5);
    operators_list.at('*').push_back(LEFT_ASSOC);
    operators_list['/'] = std::vector<int>();
    operators_list.at('/').push_back(5);
    operators_list.at('/').push_back(LEFT_ASSOC);
    operators_list['%'] = std::vector<int>();
    operators_list.at('%').push_back(5);
    operators_list.at('%').push_back(LEFT_ASSOC);
    operators_list['^'] = std::vector<int>();
    operators_list.at('^').push_back(10);
    operators_list.at('^').push_back(RIGHT_ASSOC);

    // Initialize stack and variables map
    std::string input(u);
    std::string expression;
    std::stack<char> operators;

    // Convert to polenese notation (infix)
    for (int i = 0; i <= input.length(); i++) {
        char c, t;
        int point;
        if (i >= input.length())
            c = '\0';
        else
            c = input.at(i);

        if (c >= '0' && c <= '9') {                                                 // add numbers to return string
            point = 0;
            expression += "$";                                                      // marker of begin of a number
            expression += c;
            while ((i + 1 < input.length()) && (((c = input.at(i + 1)) >= '0' && c <= '9') || c == '.')) {
                if (c == '.' && (++point > 1))                                      // check of use of two or more points
                    throw std::invalid_argument("ERROR: Invalid expression! You cannot use two or more consecutive points in the same number.");
                expression += c;
                i++;
            }
            expression += '$';                                                      // marker of end of a number
        } else if (c >= 'a' && c <= 'z') {                                          // define variables
            std::string var;                                                        // get variable name
            var += c;
            while ((i + 1 < input.length()) && ((c = input.at(i + 1)) >= 'a' && c <= 'z')) {
                i++;
                var += c;
            }
            // get variable values
            point = 0;
            expression += '$';
            if ((i + 1 < input.length()) && input.at(i + 1) == '=') {
                i++;
                std::string number;
                while ((i + 1 < input.length()) && (((c = input.at(i + 1)) >= '0' && c <= '9') || c == '.')) {
                    if (c == '.' && (++point > 1))                                  // check of use of two or more points
                        throw std::invalid_argument("ERROR: Invalid expression! You cannot use two or more consecutive points in the same number.");
                    number += c;
                    i++;
                }
                variables->insert(std::make_pair(var, number));
                //variables[var] = number;                                            // save variable in the variables map
                expression += number;
            } else {
                if (variables->count(var))
                    expression += variables->at(var);
                else
                    expression += '0';
            }
            expression += '$';
        } else if (c == '(')
            operators.push(c);
        else if (c == ')' || c == '\0') {                                           // add operators to return string
            while (!operators.empty()) {                                            // add operatores until stack is empty or until find a '('
                t = operators.top();
                operators.pop();
                if (t == '(')
                    break;
                expression += t;
            }
        } else if (isOperator(c)) {                                                 // add operators to stack
            while (!operators.empty() && isOperator(operators.top())) {
                t = operators.top();
                if ((isAssociative(c, LEFT_ASSOC) && priority(c, t) <= 0)
                    || (isAssociative(c, RIGHT_ASSOC) && priority(c, t) < 0)) {     // check priority of operators and rearrange them accordly
                    operators.pop();                                                // if the current operator has less priority that the ones in the stack
                    expression = expression + t;                                    // add them to the expression
                    continue;
                }
                break;
            }
            operators.push(c);
        }
        // sqrt, cos, tan, sin not implemented
    }

    // printf("final expression - %s\n", expression.c_str());
    // Do the math
    std::stack<double> numbers;
    for (int i = 0; i < expression.length(); i++) {
        char op = expression.at(i);
        if (isOperator(op)) {                                                       // if the char is operator
            double n2 = numbers.top();                                              // remove top two numbers in the stack
            numbers.pop();
            double n1 = numbers.top();
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
                case '%':
                    numbers.push((int)n1 % (int)n2);
                case '^':
                    numbers.push(pow(n1, n2));
                    break;
            }
        } else if (op == '$') {                                                     // if op == '$', iterate until the end of the number
            std::string number;
            while ((i + 1 < expression.length()) && (((op = expression.at(i + 1)) >= '0' && op <= '9') || op == '.')) {
                number = number + op;
                i++;
            }
            i++;                                                                    // skip the second '$'
            double n = atof(number.c_str());
            numbers.push(n);
        }
    }

    return numbers.top();                                                           // return top of stack == result of operations
}

// Returns the difference between two operators
int priority(char op1, char op2){
    if (!isOperator(op1) || !isOperator(op2))
        return -1;
    return operators_list.at(op1).at(0) - operators_list.at(op2).at(0);
}

// Check if char is an operator
int isOperator(char c) {
    return operators_list.count(c);
}

// Check the associativity of an operator
int isAssociative(char c, int type) {
    if (!isOperator(c))
        return -1;
    else
        return operators_list.at(c).at(1) == type;
}

