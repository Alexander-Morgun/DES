format MS COFF

section '.text' code readable executable

public DES_encrypt as "_DES_encrypt"
public DES_decrypt as "_DES_decrypt"

block_size = 8
round_key_size = 8
round_keys_number = 16
round_keys_size = round_keys_number * round_key_size

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

include "S blocks.txt"

stack_frame_size = round_keys_size + 2 * 4
label src dword at ebp + 8
label dst dword at ebp + 12
label key  dword at ebp + 16
label text_size dword at ebp + 20
label round_keys_begin dword at ebp - round_keys_size
label round_keys_end dword at ebp - round_key_size
label round_keys dword at ebp - round_keys_size - 4
label round_keys_delta dword at ebp  - round_keys_size - 8

DES_decrypt:
    push    ebp
    mov ebp, esp
    sub esp, stack_frame_size
    push ebx ecx edx esi edi
    lea eax, [round_keys_end]
    mov [round_keys], eax
    mov [round_keys_delta], -8
    jmp main

DES_encrypt:
    push    ebp
    mov ebp, esp
    sub esp, stack_frame_size
    push ebx ecx edx esi edi
    lea eax, [round_keys_begin]
    mov [round_keys], eax
    mov [round_keys_delta], 8
    jmp main

main:
    mov eax, [src]
    mov ebx, [dst]
    mov ecx, [text_size]
@@:
    mov edx, [eax]
    mov [ebx], edx
    inc eax
    inc ebx
    dec ecx
    jnz @b
    
    mov eax, [key]
    mov esi, [eax]
    mov edi, [eax + 4]
    include 'PC-1.txt'
    ; C0 on ecx, D0 on edx
    mov ebx, 1
    mov eax, [round_keys]

generate_keys:
    call rotate_key
    test ebx, 1000000100000011b
    jnz @f
    call rotate_key
@@:
    include "PC-2.txt"
    ; key on esi:edi
    mov [eax], esi
    mov [eax + 4], edi
    add eax, [round_keys_delta]
    shl ebx, 1
    test ebx, 0x10000
    jz generate_keys
    
    mov eax, [dst]
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
    mov ebx, 0
    ; L0 on esi, R0 on edi
round:
    push edi
    include 'E BIT-SELECTION.txt'
    ; E(R0) on ecx:edx
    mov edi, [round_keys_begin + ebx]
    mov eax, [round_keys_begin + ebx + 4]
    xor ecx, edi
    xor edx, eax

    xor eax, eax
    mov edi, edx
    shr edi, 18
    or al, [edi + S8]
    
    mov edi, edx
    shr edi, 12
    and edi, 111111b
    shl eax, 4
    or al, [edi + S7]

    mov edi, edx
    shr edi, 6
    and edi, 111111b
    shl eax, 4
    or al, [edi + S6]

    mov edi, edx
    and edi, 111111b
    shl eax, 4
    or al, [edi + S5]

    mov edi, ecx
    shr edi, 18
    and edi, 111111b
    shl eax, 4
    or al, [edi + S4]

    mov edi, ecx
    shr edi, 12
    and edi, 111111b
    shl eax, 4
    or al, [edi + S3]

    mov edi, ecx
    shr edi, 6
    and edi, 111111b
    shl eax, 4
    or al, [edi + S2]

    mov edi, ecx
    and edi, 111111b
    shl eax, 4
    or al, [edi + S1]
    
    include 'P.txt'
    xor esi, edx
    pop edi
    xchg esi, edi
    
    add ebx, 8
    cmp ebx, 8 * 16
    jne round
    ; L16 on esi, R16 on edi
final_permutation:
    include 'final_permutation.txt'
    pop ebx eax
    mov [eax], ecx
    mov [eax + 4], edx
    add eax, block_size
    ret

section '.data' data readable writeable
