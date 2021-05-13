#!/usr/bin/python3
import subprocess as sp
import sys
from itertools import count

if __name__ == '__main__':
    args = sys.argv[1:]
    for turn in count(1):
        print('run', turn)
        p = sp.run(args)
        if p.returncode ==  0:
            break
