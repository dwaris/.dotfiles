#!/bin/bash

find . -name "*.flac" | parallel --bar "opusenc {} --bitrate 192 --music ./{.}.ogg && rm {}"