#!/bin/bash

cd "/home/dwaris/github/orpheusdl/"
parallel --jobs 4 --tmuxpane --bar "./orpheus.py {}" < "$1"
