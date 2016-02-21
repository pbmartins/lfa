#include "m.h"

#include <string.h>
#include <stdio.h>

bool M(const char* u)
{
    const char* p = u;
    const char* begin;
    p = strstr(u, "b");
    if (!p)
        return true;
    else {
        begin = p;
        p = strstr(p + 1, "b");
        while((p = strstr(p + 1, "b"))) {
            char c = *(begin + 1); // get first char after first 'b'
            for (begin = begin + 2; begin < p && *begin != '\0'; begin++) {
                printf("%c\n", *begin);
                if (c != *begin) // get the value of the char of the incremented begin;
                    return false;
            }
        }
        return true;
    }
}
