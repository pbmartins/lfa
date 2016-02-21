#ifndef __M1_H__
#define __M1_H__

/** \brief Language recognizer
 * \param u word to be evaluated
 * \return \c true if word belongs to the language 
 *      and \c false otherwise
 */
int calculate(char* u[]);

char* convert(char* u[]);

int priority(char c, char t);
#endif // __M1_H__
