#!/usr/bin/env sh

set -u

SAFE_MODE=false
if [ "${1:-}" = "safe" ]; then
  SAFE_MODE=true
fi

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
  notify-send "VPN" "Disconnecting..." >/dev/null 2>&1 || true
  if run_with_timeout 45 protonvpn disconnect >/dev/null 2>&1; then
    sleep 1
    notify-send "VPN" "Disconnected" >/dev/null 2>&1 || true
    pkill -RTMIN+1 waybar
    exit 0
  fi
  notify-send "VPN" "Disconnect failed" >/dev/null 2>&1 || true
  pkill -RTMIN+1 waybar
  exit 1
else
  if [ "$SAFE_MODE" = true ]; then
    SAFE_COUNTRIES="CH IS"
    
    RANDOM_COUNTRY=$(echo "$SAFE_COUNTRIES" | tr ' ' '\n' | shuf -n 1)
    
    notify-send "VPN" "Connecting to: $RANDOM_COUNTRY..." >/dev/null 2>&1 || true
    if run_with_timeout 60 protonvpn connect --country "$RANDOM_COUNTRY" >/dev/null 2>&1; then
      sleep 1
      notify-send "VPN" "Connected ($RANDOM_COUNTRY)" >/dev/null 2>&1 || true
      pkill -RTMIN+1 waybar
      exit 0
    fi
  else
    notify-send "VPN" "Connecting to fastest..." >/dev/null 2>&1 || true
    if run_with_timeout 60 protonvpn connect >/dev/null 2>&1; then
      sleep 1
      notify-send "VPN" "Connected (Fastest)" >/dev/null 2>&1 || true
      pkill -RTMIN+1 waybar
      exit 0
    fi
  fi
  
  notify-send "VPN" "Connection failed" >/dev/null 2>&1 || true
  pkill -RTMIN+1 waybar
  exit 1
fi
