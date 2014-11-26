#include "DES.h"
#include "stdio.h"
#include "string.h"

int main()
{
    uint8_t data[] = "12345678987654321";
    size_t data_size = 17;
    uint8_t key[8] = {0};
    DES_encrypt(data, data_size, key);
    printf("%s", data);
    return 0;
}