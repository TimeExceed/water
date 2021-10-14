#!/bin/bash

for (( cnt=0; 1; cnt++)) do
    echo -n "try $cnt"
    printf "\n"
    $@
    if [ $? -eq 0 ]; then
        break
    fi
done
