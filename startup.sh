#!/bin/bash
set -e

echo "This is the program which will be run..."
cat /code/main.c

clang-17 -c -O0 -fno-omit-frame-pointer --target=riscv32 -march=rv32im -o /code/main.o /code/main.c
clang-17 -c -O0 -fno-omit-frame-pointer --target=riscv32 -march=rv32im -o /code/init.o /helper/init.s
clang-17 -c -O0 -fno-omit-frame-pointer --target=riscv32 -march=rv32im -o /code/trap.o /helper/trap.s
clang-17 -c -O0 -fno-omit-frame-pointer --target=riscv32 -march=rv32im -o /code/vars.spike.o /helper/vars.spike.s
clang-17 -c -O0 -fno-omit-frame-pointer --target=riscv32 -march=rv32im -o /code/common.o /helper/common.c
clang-17 -static --target=riscv32 -nostdlib -T/helper/link.ld /code/init.o /code/trap.o /code/vars.spike.o /code/common.o /code/main.o -o /code/main

file /code/main
/opt/riscv-cross/bin/riscv32-unknown-linux-gnu-objdump -d /code/main

echo "Compilation was ok"
echo "Running spike..."

/opt/spike/bin/spike -d --isa=rv32im /code/main
echo "Status Code is $?"
