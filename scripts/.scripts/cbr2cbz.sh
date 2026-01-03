#!/bin/bash

process_file() {
    local file="$1"
    local name="${file%.*}"
    local work_dir="tmp/${name}"

    mkdir -p "$work_dir"
    unrar x -inul "$file" "$work_dir/"

    cd "$work_dir" 
    zip -r -q -1 "../../${name}.cbz" .
    rm -rf "$work_dir"
}
export -f process_file

mkdir -p tmp
find . -maxdepth 1 -name "*.cbr" | parallel --tmux-pane --bar process_file {}

rmdir tmp 2>/dev/null
find . -name "*.cbr" -exec rm {} \;
