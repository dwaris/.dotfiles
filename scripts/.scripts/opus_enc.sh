#!/bin/bash

mkdir final

find . -name "*.flac" | parallel 'opusenc {} --bitrate 192 --music ./final/{.}.ogg'
mv final/*.ogg .
rm ./*.flac
rmdir final
