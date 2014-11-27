block_size = 64
bits_in_register = 32

correction = [0] * bits_in_register
for byte in range(4):
    for bit in range(8):
       correction[byte * 8 + bit] = byte * 8 + 7 - bit
extended_correction = correction + [i + 32 for i in correction]

def is_high(number):
    return number >= bits_in_register

def print_permutation(permutation,
                      src_low,
                      src_high,
                      dst_low,
                      dst_high,
                      file,
                      from_memory=True, # src get from memory
                      to_memory=True, # dst would be immediately put into memory
                      dst_part_size = bits_in_register,
                      src_part_size = bits_in_register
                      ): 
    print("xor {0}, {0}".format(dst_low), file=file)
    print("xor {0}, {0}".format(dst_high), file=file)
    if to_memory:
        corrected_permutation = [permutation[i] for i in extended_correction[:len(permutation)]]
    else:
        corrected_permutation = permutation
    for dst_bit_index, src_bit_index in reversed(list(enumerate(corrected_permutation))):
        dst = [dst_low, dst_high][dst_bit_index >= dst_part_size]
        print("shl {}, 1".format(dst), file=file)
        if src_bit_index >= src_part_size:
            src = src_high
            src_bit_index -= src_part_size
        else:
            src = src_low
        if from_memory:
            src_bit_index = correction[src_bit_index]
        print("bt {}, {}".format(src, src_bit_index), file=file)
        print("adc {}, 0".format(dst), file=file)

initial_permutation = (
58, 50, 42, 34, 26, 18, 10,  2,
60, 52, 44, 36, 28, 20, 12,  4,
62, 54, 46, 38, 30, 22, 14,  6,
64, 56, 48, 40, 32, 24, 16,  8,
57, 49, 41, 33, 25, 17,  9,  1,
59, 51, 43, 35, 27, 19, 11,  3,
61, 53, 45, 37, 29, 21, 13,  5,
63, 55, 47, 39, 31, 23, 15,  7,
)
initial_permutation = [i - 1 for i in initial_permutation]
final_permutation = [0] * len(initial_permutation)
for index, value in enumerate(initial_permutation):
    final_permutation[value] = index
print_permutation(initial_permutation,
                  "ecx",
                  "edx",
                  "esi",
                  "edi",
                  open("./initial_permutation.txt", "w"),
                  to_memory=False);
print_permutation(final_permutation,
                  "esi",
                  "edi",
                  "ecx",
                  "edx",
                  open("./final_permutation.txt", "w"),
                  from_memory=False);
PC_1 = (
57, 49, 41, 33, 25, 17,  9,
 1, 58, 50, 42, 34, 26, 18,
10,  2, 59, 51, 43, 35, 27,
19, 11,  3, 60, 52, 44, 36,
63, 55, 47, 39, 31, 23, 15,
 7, 62, 54, 46, 38, 30, 22,
14,  6, 61, 53, 45, 37, 29,
21, 13,  5, 28, 20, 12,  4,
)
PC_1 = [i - 1 for i in PC_1]
print_permutation(PC_1,
                  "esi",
                  "edi",
                  "ecx",
                  "edx",
                  open("./PC-1.txt", "w"),
                  to_memory=False,
                  dst_part_size=28);
PC_2 = (
14, 17, 11, 24,  1,  5,
 3, 28, 15,  6, 21, 10,
23, 19, 12,  4, 26,  8,
16,  7, 27, 20, 13,  2,
41, 52, 31, 37, 47, 55,
30, 40, 51, 45, 33, 48,
44, 49, 39, 56, 34, 53,
46, 42, 50, 36, 29, 32,
)
PC_2 = [i - 1 for i in PC_2]
print_permutation(PC_2,
                  "ecx",
                  "edx",
                  "esi",
                  "edi",
                  open("./PC-2.txt", "w"),
                  from_memory=False,
                  to_memory=False,
                  src_part_size=28,
                  dst_part_size=24);