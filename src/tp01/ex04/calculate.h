#include <map>
#include <iostream>
#ifndef __CALCULATE_H__
#define __CALCULATE_H__

typedef std::map<std::string, std::string> variablesMap;
/** \brief Language recognizer
 * \param u word to be evaluated
 * \return \c true if word belongs to the language 
 *      and \c false otherwise
 */
double calculate(char* u, variablesMap* variables);

int priority(char op1, char op2);

int isOperator(char c);

int isAssociative(char c, int type);
#endif // __CALCULATE_H__
