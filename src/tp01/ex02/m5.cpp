#include "m.h"

#include <string.h>
#include <stdio.h>

bool M(const char* u) {
    int c = 0, abc = 0;

    for (int i = 0; i < strlen(u) - 1; i++)
        if (u[i] == 'c' && (u[i + 1] == 'a' || u[i + 1] == 'b'))
            c++;

    while ((u = strstr(u, "abc"))) {
        u += strlen("abc") -1 ;
        abc++;
    }

    return abc >= c;
}