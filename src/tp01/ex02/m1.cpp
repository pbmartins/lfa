#include "m.h"

#include <string.h>
#include <stdio.h>

bool M(const char* u)
{
    for (int i = 2; i < strlen(u); i++)
    {
        if ((u[i] == u[i-1]) && (u[i] == u[i-2])) 
        {
            return true;
        }
    }
    return false;
}
