#pragma once
#include "stdint.h"
#include "stddef.h"

extern void DES_encrypt(void *decrypted,
                        void *encrypted,
                        void *key,
                        size_t data_size);

extern void DES_decrypt(void *encrypted,
                        void *decrypted,
                        void *key,
                        size_t data_size);
     