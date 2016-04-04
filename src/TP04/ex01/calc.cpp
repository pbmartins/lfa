#include "calc-parse.h"
#include "calc-data.h"
#include "calc-lex.h"

int yyparse(CalcData*);

int main(int argc, char *argv[])
{
    /* instantiate and init calculator data */
    CalcData calc_data;

    if (yylex_init(&calc_data.scaninfo))
    {
        fprintf(stderr, "Fail initing scanner\n");
        return(EXIT_FAILURE);
    }

    calc_data.symt = new SymbolTable;

    /* set up input stream */
    yyset_in(stdin, calc_data.scaninfo);

    /* call the parser */
    printf("> "); fflush(stdout);
    int ret;
    while ((ret=yyparse(&calc_data)) != 0)
    {
        if (calc_data.result == calc_data.result)
            printf("  = %g\n", calc_data.result);
        printf("> "); fflush(stdout);
    }
    printf("\n");

    /* clean up and quit */
    yylex_destroy(calc_data.scaninfo);
    delete calc_data.symt;
    return 0;
}

