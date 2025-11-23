#!/bin/bash

cd "/home/dwaris/git/orpheusdl/"
parallel --jobs 3 --tmuxpane --bar "./orpheus.py {}" < "$1"
