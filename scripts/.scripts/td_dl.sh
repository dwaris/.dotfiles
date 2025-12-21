#!/bin/bash

parallel --jobs 3 --tmuxpane --bar "./orpheus.py {}" < "$1"
