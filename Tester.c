#include "DES.h"
#include "stdio.h"
#include "string.h"

int main()
{
    uint8_t data[] = {0, 0, 0, 0, 0, 1, 0, 0};
    size_t data_size = 8;
    uint8_t key[8] = {0};
    DES_encrypt(data, data_size, key);
    for (size_t i = 0; i < data_size; ++i) {
        printf("%02X ", (data[i]));
    }
    return 0;
}