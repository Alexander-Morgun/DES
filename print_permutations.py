block_size = 64
bits_in_register = 32

correction = [0] * bits_in_register
for byte in range(4):
    for bit in range(8):
       correction[byte * 8 + bit] = byte * 8 + 7 - bit
extended_correction = correction + [i + 32 for i in correction]

def is_high(number):
    return number >= bits_in_register

def print_permutation(permutation, src_low, src_high, dst_low, dst_high, file):
    print("xor {0}, {0}".format(dst_low), file=file)
    print("xor {0}, {0}".format(dst_high), file=file)
    corrected_permutation = [permutation[i] for i in extended_correction]
    for dst_bit_index, src_bit_index in reversed(list(enumerate(corrected_permutation))):
        dst = [dst_low, dst_high][is_high(dst_bit_index)]
        print("shl {}, 1".format(dst), file=file)
        if is_high(src_bit_index):
            src = src_high
            src_bit_index -= bits_in_register
        else:
            src = src_low
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
                  open("./initial_permutation.txt", "w"));
print_permutation(final_permutation,
                  "esi",
                  "edi",
                  "ecx",
                  "edx",
                  open("./final_permutation.txt", "w"));