#!/bin/bash

INPUT_FILE="${1:-downloads.txt}"

parallel --jobs 3 --tmuxpane --bar "./orpheus.py {}" < "$INPUT_FILE"
