#!/usr/bin/env bash

class="$1"
shift

if hyprctl clients -j | grep -qF "\"class\": \"$class\""; then
	re="${class//./\\\\.}"
	hyprctl dispatch "hl.dsp.focus({ window = \"class:^(${re})\$\" })"
else
	uwsm app -- "$@"
fi
