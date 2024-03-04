/**
 * @file
 * 
 * 
 * @copyright (C) Victor Baldin, 2024.
 */

#include <stdio.h>
#include <stdlib.h>

#include "com-patcher.hpp"

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Error: no input file\n");
        return EXIT_FAILURE;
    }

    if (!patch_com_file(argv[1]))
        return EXIT_FAILURE;
    return 0; 
}
