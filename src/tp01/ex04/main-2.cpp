#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

#include "calculate.h"

/** \brief String defining the alphabet */
static const char* alphabet = "abc";

int main(int argc, char* argv[])
{
    char* line = NULL;
    size_t n = 0;

    /* loop on given words */
    while (getline(&line, &n, stdin) > 0)
    {
        /* remove newline character if one exists */
        size_t len = strlen(line);
        len--;
        line[len] = '\0'; 

        /* check if word is weel-formed 
         * (only composed of letters from the alphabet) */
        if (strspn(line, alphabet) != len)
        {
            printf("\"%s\" contains invalid characters\n", line);
            continue;
        }

        /* check if word belongs to the language */
        if (M(line))
        {
            printf("\"%s\" belongs to L\n", line);
        }
        else
        {
            printf("\"%s\" does not belong to L\n", line);
        }
    }

    /* that's all */
    return 0;
}

