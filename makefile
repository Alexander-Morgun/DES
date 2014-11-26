OUTPUT_FILE = DES.exe

all: compile
COMPILER = gcc
GCC_KEYS = -std=c99 -Wall -Wextra -pedantic -Werror -O3
GCC_LINKER_KEYS = -c
FASM_COMPILER = ../FASM.EXE
FASM_COMPILER_KEYS =
compile: DES.obj Tester.obj
	$(COMPILER) $(GCC_KEYS) DES.obj Tester.obj -o $(OUTPUT_FILE)

DES.obj: DES.ASM initial_permutation.txt final_permutation.txt
	$(FASM_COMPILER) $(FASM_COMPILER_KEYS) DES.ASM

initial_permutation.txt: print_permutations
final_permutation.txt: print_permutations
    
print_permutations:    
	python print_permutations.py

Tester.obj: DES.h Tester.c
	$(COMPILER) $(GCC_KEYS) $(GCC_LINKER_KEYS) Tester.c -o Tester.obj

disasm:
	$(COMPILER) -masm=intel -S -O0 DES.c