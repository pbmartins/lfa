#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

#include "calculate.h"

/** \brief String defining the alphabet */
static const char* alphabet = "0123456789+-*/^()";

int main(int argc, char* argv[])
{
    /* check number of arguments
     * 1 means no arguments are given */
    if (argc == 1)
    {
		fprintf(stderr, "Wrong line arguments\n"
			"%s string ...\n", argv[0]);
		return EXIT_FAILURE;
	}

    /* loop on given words */
    int i;
    for (i=1; i<argc; i++)
    {
        /* check if word is weel-formed 
         * (only composed of letters from the alphabet) */
        if (strspn(argv[i], alphabet) != strlen(argv[i]))
        {
            printf("\"%s\" contains invalid characters\n", argv[i]);
            continue;
        }
        char* p = convert(argv);
        int result = calculate(&p);
        printf("Result: %d", result);
    }

    /* that's all */
    return 0;
}

