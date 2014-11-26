format MS COFF

section '.text' code readable executable

public DES_encrypt as "_DES_encrypt"
public DES_decrypt as "_DES_decrypt"

block_size = 8

DES_decrypt:
DES_encrypt:
    push    ebp
    mov ebp, esp

label .data dword at ebp + 8
label .size dword at ebp + 12
label .key  dword at ebp + 16

    push ebx ecx edx esi edi
    mov eax, [.data]
    mov ebx, [.size]
@@:
    call encrypt_block
    sub ebx, block_size
    jnz @b

    pop edi esi edx ecx ebx
    mov esp, ebp
    pop ebp
    retn 0

encrypt_block:
    mov ecx, [eax]
    mov edx, [eax + 4]
    ; bt ecx, 8
    ; adc edx, 0
initial_permutation:
    include 'initial_permutation.txt'
encryption:
    ; block on esi:edi
final_permutation:
    ; include 'final_permutation.txt'
    ; mov [eax], ecx
    ; mov [eax + 4], edx
    mov [eax], esi
    mov [eax + 4], edi
    add eax, block_size
    ret

section '.data' data readable writeable
