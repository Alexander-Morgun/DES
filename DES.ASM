format MS COFF

section '.text' code readable executable

public DES_encrypt as "_DES_encrypt"
public DES_decrypt as "_DES_decrypt"

DES_decrypt:
DES_encrypt:
    push    ebp
    mov ebp, esp

label .data dword at ebp + 8
label .size dword at ebp + 12
label .key  dword at ebp + 16

    push ebx
    push esi
    mov eax, [.data]
    mov esi, [ebp + 8]
    mov ebx, [.size]
@@:
    call encrypt_block
    dec ebx
    jnz @b

    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    retn 0

encrypt_block:
    inc byte [eax]
    inc eax
    ret

section '.data' data readable writeable
