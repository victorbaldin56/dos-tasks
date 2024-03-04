/**
 * @file
 *
 *  
 * @copyright (C) Victor Baldin, 2024.
 */

#include <sys/fcntl.h>
#include <sys/stat.h>

#include <assert.h>
#include <stdlib.h>

#include "com-patcher.hpp"

// Opcodes on Intel 286.
const unsigned char jne_opcode = 0x75;
const unsigned char nop_opcode = 0x90;

/** 
 * @brief Permormes crack on buffer.
 * @param buffer The buffer with COM file contents.
 * @param size   Size of the buffer.
 * @return bool flag.
 *
 * Simply finds the first JNE instruction in the buffer & replaces it and its 
 * operand by NOP.
 */
static bool patch_buffer(unsigned char* buffer, size_t size);

bool patch_com_file(const char input_file[]) {
    assert(input_file != nullptr);

    FILE* output = nullptr;
    bool flag = true;

    struct stat stbuf{};
    if (stat(input_file, &stbuf) == -1) {
        perror("stat");
        return false;
    }
    const size_t input_size = (size_t)stbuf.st_size;

    FILE* input = fopen(input_file, "r");
    if (input == nullptr) {
        perror("fopen");
        return false;
    }

    unsigned char* buffer = (unsigned char*)calloc(input_size, sizeof(*buffer));
    if (buffer == nullptr) {
        perror("alloc");
        flag = false;
        goto exit;
    }

    fread(buffer, input_size, sizeof(*buffer), input);
    if (!patch_buffer(buffer, input_size)) {
        fprintf(stderr, 
            "Error: JNE not found, this file does not seem to be crackable\n");
        flag = false;
        goto exit;
    }

    output = fopen("crack.com", "w");
    if (output == nullptr) {
        perror("fopen");
        flag = false;
        goto exit;
    }

    fwrite(buffer, input_size, sizeof(*buffer), output);

exit:
    fclose(input);
    free(buffer);
    return flag;
}

static bool patch_buffer(unsigned char* buffer, size_t size) {
    assert(buffer != nullptr && size);
    
    for (size_t i = 0; i < size - 1; ++i) {
        if (buffer[i] == jne_opcode) {
            buffer[i] = nop_opcode;
            buffer[i + 1] = nop_opcode;
            return true;
        }
    }

    return false;
}
