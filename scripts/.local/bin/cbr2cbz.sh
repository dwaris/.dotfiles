#!/usr/bin/env bash

process_file() {
    local file="$1"
    local name="${file%.*}"
    local work_dir="tmp/${name}"

    mkdir -p "$work_dir"
    if ! unrar x -inul "$file" "$work_dir/"; then
        echo "Failed to unrar $file"
        rm -rf "$work_dir"
        return 1
    fi

    # Ensure unrar actually unpacked files
    if [ -z "$(ls -A "$work_dir")" ]; then
        echo "Extracted directory is empty for $file"
        rm -rf "$work_dir"
        return 1
    fi

    # remember where you are coming from
    if (cd "$work_dir" && zip -r -q -1 "../../${name}.cbz" .) && [ -s "${name}.cbz" ]; then
        rm "$file"
        rm -rf "$work_dir"
    else
        echo "Failed to create cbz for $file"
        rm -f "${name}.cbz"
        rm -rf "$work_dir"
        return 1
    fi
}
export -f process_file

mkdir -p tmp
find . -maxdepth 1 -name "*.cbr" | parallel --tmuxpane --bar process_file {}

rmdir tmp 2>/dev/null
