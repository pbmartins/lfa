#include "m.h"

#include <string.h>
#include <stdio.h>

bool M(const char* u) {
    int num = 0;

    while((u = strstr(u, "aba"))) {
        u += strlen("aba") - 1;
        num++;
    }
    return num > 1;
}