#!/bin/bash

cd "/home/dwaris/github/orpheusdl/"
parallel -j3 --linebuffer "./orpheus.py {}" < "$1"
