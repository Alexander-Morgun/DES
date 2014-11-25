#include "stdio.h"
#include "stdint.h"


extern void DES_encrypt(uint8_t[], size_t);

int main()
{
    uint8_t data[] = "12345";
    size_t size = 5;
    DES_encrypt(data, size);
    printf("%s", data);
    return 0;
}