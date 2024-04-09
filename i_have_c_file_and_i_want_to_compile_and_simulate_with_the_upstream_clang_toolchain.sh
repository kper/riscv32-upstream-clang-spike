#!/bin/bash

FILE=./src/main.c
if ! test -f "$FILE" ; then
	    echo "$FILE does not exist. You have to add it!"
	    exit
fi

docker run --rm --mount source="$(pwd)/startup.sh",target=/run/startup.sh,type=bind --mount source="$(pwd)/helper",target=/helper,type=bind --mount source="$(pwd)/src/",target=/code,type=bind -it riscv32-upstream-clang-spike sh /run/startup.sh
