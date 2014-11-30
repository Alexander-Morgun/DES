#pragma once
#include "stdint.h"
#include "stddef.h"

extern void DES_encrypt(void *data,
                        size_t data_size,
                        void *key);

extern void DES_decrypt(void *data,
                        size_t data_size,
                        void *key);
     