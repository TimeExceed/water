#!/bin/bash

for (( cnt=0; 1; cnt++)) do
    echo -n "try $cnt"
    printf "\n"
    $@
    if [ $? -eq 0 ]; then
        break
    fi
    echo "fail. sleep and then retry."
    sleep 1s
done
