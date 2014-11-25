#include "stdio.h"
#include "stdint.h"


extern void demo(uint8_t[], size_t);

int main()
{
    uint8_t data[] = "12345";
    size_t size = 5;
    demo(data, size);
    printf("%s", data);
    return 0;
}