#!/bin/bash

if pgrep -f "systemd-inhibit.*sleep infinity" > /dev/null; then
  pkill -f "systemd-inhibit.*sleep infinity"
else
  nohup systemd-inhibit --what=sleep --mode=block sleep infinity >/dev/null 2>&1 &
fi