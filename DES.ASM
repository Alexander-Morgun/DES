format MS COFF

section '.text' code readable executable

public DES_encrypt as "_DES_encrypt"
public DES_decrypt as "_DES_decrypt"

block_size = 8

DES_decrypt:
DES_encrypt:
    push    ebp
    mov ebp, esp
    sub esp, 8 * 16

label text dword at ebp + 8
label text_size dword at ebp + 12
label key  dword at ebp + 16
label round_keys dword at ebp - 4

    push ebx ecx edx esi edi
    mov eax, [key]
    mov esi, [eax]
    mov edi, [eax + 4]
    include 'PC-1.txt'
    ; C0 on ecx, D0 on edx
    mov ebx, 1
    lea eax, [round_keys]
    jmp generate_keys

rotate_key_part: ;part on ecx
    mov esi, ecx
    shr ecx, 1
    ror esi, 5
    and esi, 0x8000000
    or ecx, esi
    ret
 
rotate_key:
    call rotate_key_part
    xchg ecx, edx
    call rotate_key_part
    xchg ecx, edx
    ret

generate_keys:
    call rotate_key
    test ebx,0x8103 ; 1000 0001 0000 0011
    jnz @f
    call rotate_key
@@:
    include "PC-2.txt"
    ; key on esi:edi
    mov [eax], esi
    mov [eax - 4], edi
    sub eax, 8
    shl ebx, 1
    test ebx, 0x10000
    jz generate_keys
    
    mov eax, [key] ; delete me
    mov [eax], esi ; delete me
    mov [eax + 4], edi ; delete me
    
    mov eax, [text]
    mov ebx, [text_size]
@@:
    call encrypt_block
    sub ebx, block_size
    jnz @b

    pop edi esi edx ecx ebx
    mov esp, ebp
    pop ebp
    retn 0

encrypt_block:
    push eax ebx
    mov ecx, [eax]
    mov edx, [eax + 4]
initial_permutation:
    include 'initial_permutation.txt'
encryption:
    lea ebx, [round_keys]
    ; L0 on esi, R0 on edi
    include 'E BIT-SELECTION.txt'
    ; E(R0) on ecx:edx
    mov edi, [ebx]
    mov eax, [ebx - 4]
    xor ecx, edi
    xor edx, eax
final_permutation:
    ; include 'final_permutation.txt'
    ; mov [eax], ecx
    ; mov [eax + 4], edx
    pop ebx eax
    mov [eax], ecx
    mov [eax + 4], edx
    add eax, block_size
    ret

section '.data' data readable writeable
