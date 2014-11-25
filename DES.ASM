format MS COFF

section '.text' code readable executable

public DES_encrypt as "_DES_encrypt"
public DES_decrypt as "_DES_decrypt"

DES_decrypt:
DES_encrypt:
    push    ebp
    mov ebp, esp
label .data dword at ebp+8        ;num1 argument is now located at ebp+8
label .size  dword at ebp+12       ;num2 argument is now is located at ebp+12

    push ebx
    mov eax, [.data]
    mov ebx, [.size]
@@:
    inc byte [eax]
    inc eax
    dec ebx
    jnz @b

    pop ebx
    mov esp, ebp
    pop ebp
    retn 0

section '.data' data readable writeable
