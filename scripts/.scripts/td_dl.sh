#!/bin/bash

cd "/home/dwaris/github/orpheusdl/"
parallel --jobs 3 --tmuxpane --bar "./orpheus.py {}" < "$1"
