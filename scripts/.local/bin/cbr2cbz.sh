#!/bin/bash

process_file() {
    local file="$1"
    local name="${file%.*}"
    local work_dir="tmp/${name}"

    mkdir -p "$work_dir"
    unrar x -inul "$file" "$work_dir/"

    # remember where you are coming from
    (cd "$work_dir" && zip -r -q -1 "../../${name}.cbz" .)

    if [ -f "${name}.cbz" ]; then
        rm "$file"
        rm -rf "$work_dir"
    else
        echo "Failed to create cbz for $file"
        rm -rf "$work_dir"
        return 1
    fi
}
export -f process_file

mkdir -p tmp
find . -maxdepth 1 -name "*.cbr" | parallel --tmux-pane --bar process_file {}

rmdir tmp 2>/dev/null
