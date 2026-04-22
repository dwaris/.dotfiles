#!/bin/bash

if pgrep -f "systemd-inhibit.*sleep infinity" > /dev/null; then
  echo "{\"icon\": \"activated\"}"
else
  echo "{\"icon\": \"deactivated\"}"
fi