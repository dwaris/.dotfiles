#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f -- "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_PATH")"
SHELLS_DIR="$(cd -- "$SCRIPT_DIR/../../../nixos/shells" && pwd)"

for flake in "$SHELLS_DIR"/*/flake.nix; do
	[[ -f "$flake" ]] || continue
	shell_dir="${flake%/*}"
	printf 'Updating %s\n' "${shell_dir##*/}"
	(
		cd -- "$shell_dir"
		nix flake update
	)
done
