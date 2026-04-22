#!/usr/bin/env sh

set -u

cli_is_connected() {
  status_out="$(run_with_timeout 10 protonvpn status 2>/dev/null || true)"
  printf '%s' "$status_out" | grep -Eqi '(^|[[:space:]:])connected([[:space:]]|$)' \
    && ! printf '%s' "$status_out" | grep -Eqi 'disconnected|not[[:space:]]+connected'
}

run_with_timeout() {
  seconds="$1"
  shift
  if command -v timeout >/dev/null 2>&1; then
    timeout "$seconds" "$@"
  else
    "$@"
  fi
}

if ! command -v protonvpn >/dev/null 2>&1; then
  notify-send "VPN" "protonvpn command not found" >/dev/null 2>&1 || true
  exit 1
fi

if cli_is_connected; then
  if run_with_timeout 45 protonvpn disconnect >/dev/null 2>&1; then
    notify-send "VPN" "Disconnected" >/dev/null 2>&1 || true
    pkill -RTMIN+1 waybar
    exit 0
  fi
  notify-send "VPN" "Disconnect failed" >/dev/null 2>&1 || true
  pkill -RTMIN+1 waybar
  exit 1
else
  if run_with_timeout 45 protonvpn connect >/dev/null 2>&1; then
    notify-send "VPN" "Connected" >/dev/null 2>&1 || true
    pkill -RTMIN+1 waybar
    exit 0
  fi
  notify-send "VPN" "Connect failed" >/dev/null 2>&1 || true
  pkill -RTMIN+1 waybar
  exit 1
fi
