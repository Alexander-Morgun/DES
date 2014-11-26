#pragma once
#include "stdint.h"
#include "stddef.h"

extern void DES_encrypt(uint8_t data[],
                        size_t data_size,
                        uint8_t key[8]);

extern void DES_decrypt(uint8_t data[],
                        size_t data_size,
                        uint8_t key[8]);
     