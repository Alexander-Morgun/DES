OUTPUT_FILE = DES.exe

all: compile
COMPILER = gcc
GCC_KEYS = -std=c90 -Wall -Wextra -pedantic -Werror -O3
GCC_LINKER_KEYS = -c
FASM_COMPILER = ../FASM.EXE
FASM_COMPILER_KEYS =
compile: DES.obj Tester.obj
	$(COMPILER) $(GCC_KEYS) DES.obj Tester.obj -o $(OUTPUT_FILE)

DES.obj: DES.ASM
	$(FASM_COMPILER) $(FASM_COMPILER_KEYS) DES.ASM
    
Tester.obj: DES.c
	$(COMPILER) $(GCC_KEYS) $(GCC_LINKER_KEYS) DES.c -o Tester.obj