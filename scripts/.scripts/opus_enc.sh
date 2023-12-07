#!/bin/bash

mkdir final

find . -name "*.flac" | parallel 'opusenc {} --bitrate 192 --music ./final/{.}.opus'
mv final/*.opus .
rm ./*.flac
rmdir final
