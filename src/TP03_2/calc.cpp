#include <string>
#include <math.h>
#include "calc-parse.h"
#include "calc-lex.h"
#include "calc-data.h"

int yyparse(CalcData*);

int main(int argc, char *argv[])
{
    /* instantiate and init calculator data */
    CalcData calc_data;

    if (yylex_init(&calc_data.scanner))
    {
        fprintf(stderr, "Fail initing scanner\n");
        return(EXIT_FAILURE);
    }

    calc_data.symt = new SymbolTable;

    /* set up input stream */
    yyset_in(stdin, calc_data.scanner);

    /* call the parser */
    while (1)
    {
        printf("> "); fflush(stdout);
        yyparse(&calc_data);
    }

    /* clean up and quit */
    yylex_destroy(calc_data.scanner);
    delete calc_data.symt;
    return 0;
}

