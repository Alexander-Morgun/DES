#include "DES.h"
#include "stdio.h"
#include "string.h"

int main()
{
    uint8_t data[] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF};
    size_t data_size = 8;
    const size_t key_size = 8;
    uint8_t key[8] = {0x13, 0x34, 0x57, 0x79, 0x9B, 0xBC, 0xDF, 0xF1};
    DES_encrypt(data, data_size, key);
    for (size_t i = 0; i < data_size; ++i) {
        printf("%02X ", (data[i]));
    }
    printf("\n");
    for (size_t i = 0; i < key_size; ++i) {
        printf("%02X ", (key[i]));
    }
    return 0;
}