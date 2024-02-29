#!/bin/bash

find . -name "*.flac" | parallel "opusenc {} --bitrate 192 --music ./{.}.ogg"

find . -name "*.flac" -exec rm {} \;
