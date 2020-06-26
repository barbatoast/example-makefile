/*
engine.c:
    This file performs setup of the system and contains the primary packet readin logic.
*/

#include <stdio.h>
#include <stdlib.h>

#include "input.h"
#include "output.h"

int main(int argc, char *argv[])
{
    if (argc < 2) {
        printf("Error, not enough arguments\n");
        printf("Usage: %s <iface>\n", argv[0]);
    }

    load_module_input();
    load_module_output();

    return EXIT_SUCCESS;
}
