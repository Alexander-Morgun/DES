#include "DES.h"
#include "stdio.h"
#include "string.h"
#include "assert.h"
#include "ctype.h"


#define block_length 8

uint8_t to_hex(char chr)
{
    if (isdigit(chr)) {
        return chr - '0';
    }
    else {
        return chr - 'A' + 10;
    }
}

void read_block(uint8_t buffer[block_length])
{
    char raw_string[2 * block_length] = {0};
    scanf("%16s", raw_string);
    for (int i = 0; i < block_length; ++i) {
        buffer[i] = (to_hex(raw_string[2 * i]) << 4) | to_hex(raw_string[2 * i + 1]);
    }
}

int main()
{
    freopen("./tests.txt", "r", stdin);
    int tests_count = 0;
    scanf("%d\n", &tests_count);
    for (int test = 0; test < tests_count; ++test) {
        uint8_t key[8] = {0};
        read_block(key);
        uint8_t data[block_length] = {0};
        read_block(data);
        uint8_t expected_result[block_length] = {0};
        read_block(expected_result);
        DES_encrypt(data, block_length, key);
        for (size_t i = 0; i < block_length; ++i) {
            assert(data[i] == expected_result[i]);
        }
    }
    printf("All tests passed\n");
    return 0;
}