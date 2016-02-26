%{
    #include <stdio.h>

    enum { BELONGS=257, OTHER, INVALID, EOL };
%}

%option noyywrap
%option reentrant
%option noinput nounput

er1     (aaa|bbb|ccc)
any     [abc]*
other   [abc]+

%%

^{any}{er1}{any}$   { return BELONGS; }
^{other}$           { return OTHER; }
\n                  { return EOL; }
^.+$                { return INVALID; }

%%

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

    #define belongs(t)   printf("\"%s\" - belongs",t)
    #define other(t)     printf("\"%s\" - does not belong",t)
    #define invalid(t)   printf("\"%s\" - contains invalid characters",t)

    /* do scanning */
    int tid;
    while ((tid = yylex(scanner)) != 0)
    {
        switch (tid)
        {
            case BELONGS:
                belongs(yyget_text(scanner));
                break;
            case OTHER:
                other(yyget_text(scanner));
                break;
            case INVALID:
                invalid(yyget_text(scanner));
                break;
            case EOL:
                printf("\n");
                break;
        }
    }

    /* clean up and quit */
    yylex_destroy(scanner);
    return 0;
}

