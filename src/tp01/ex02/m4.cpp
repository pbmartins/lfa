#include "m.h"

#include <string.h>
#include <stdio.h>

bool M(const char* u) {
    int a = 0, b = 0;

    for (int i = 0; i < strlen(u); i++) {
        if (u[i] == 'a')
            a++;
        else if (u[i] == 'b')
            b++;
    }
    return b == 0 || (a % 2) == 0;
}