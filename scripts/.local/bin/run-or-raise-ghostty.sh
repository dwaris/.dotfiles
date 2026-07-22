#!/usr/bin/env bash

if hyprctl clients -j | grep -qi "com.mitchellh.ghostty"; then
    hyprctl dispatch 'hl.dsp.focus({ window = "class:^(com\\.mitchellh\\.ghostty)$" })'
else
    ghostty
fi