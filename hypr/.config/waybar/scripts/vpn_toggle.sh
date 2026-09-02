#!/usr/bin/env sh

set -u

SAFE_MODE=false
if [ "${1:-}" = "safe" ]; then
  SAFE_MODE=true
fi

run_with_timeout() {
  seconds="$1"
  shift
  if command -v timeout >/dev/null 2>&1; then
    timeout "$seconds" "$@"
  else
    "$@"
  fi
}

notify_vpn() {
  urgency="$1"
  msg="$2"
  timeout_ms="${3:-4000}"
  notify-send -u "$urgency" -t "$timeout_ms" -h string:x-canonical-private-synchronous:vpn "VPN" "$msg" >/dev/null 2>&1 || true
}

cli_is_connected() {
  status_out="$(run_with_timeout 10 protonvpn status 2>/dev/null || true)"
  printf '%s' "$status_out" | grep -Eqi '(^|[[:space:]:])connected([[:space:]]|$)' \
    && ! printf '%s' "$status_out" | grep -Eqi 'disconnected|not[[:space:]]+connected'
}

is_logged_in() {
  account_line="$(run_with_timeout 6 protonvpn info 2>/dev/null || true)"
  account=$(printf '%s\n' "$account_line" | sed -n "s/.*Account:[[:space:]]*'\([^']*\)'.*/\1/p")
  [ -n "$account" ] && [ "$account" != "None" ]
}

if ! command -v protonvpn >/dev/null 2>&1; then
  notify_vpn "normal" "protonvpn command not found" 5000
  exit 1
fi

if cli_is_connected; then
  notify_vpn "low" "Disconnecting..." 3000
  if run_with_timeout 45 protonvpn disconnect >/dev/null 2>&1; then
    sleep 1
    notify_vpn "normal" "Disconnected" 4000
    pkill -RTMIN+1 waybar || true
    exit 0
  fi
  notify_vpn "normal" "Disconnect failed" 5000
  pkill -RTMIN+1 waybar || true
  exit 1
else
  # Guard: ensure user is signed in before trying to connect
  if ! is_logged_in; then
    notify_vpn "normal" "Not signed in to Proton VPN.\nRun 'protonvpn signin' to connect." 6000
    exit 1
  fi

  if [ "$SAFE_MODE" = true ]; then
    SAFE_COUNTRIES="CH IS"
    RANDOM_COUNTRY=$(echo "$SAFE_COUNTRIES" | tr ' ' '\n' | shuf -n 1)
    
    notify_vpn "low" "Connecting to: $RANDOM_COUNTRY..." 3000
    if run_with_timeout 60 protonvpn connect --country "$RANDOM_COUNTRY" >/dev/null 2>&1; then
      sleep 1
      notify_vpn "normal" "Connected ($RANDOM_COUNTRY)" 4000
      pkill -RTMIN+1 waybar || true
      exit 0
    fi
  else
    notify_vpn "low" "Connecting to fastest..." 3000
    if run_with_timeout 60 protonvpn connect >/dev/null 2>&1; then
      sleep 1
      notify_vpn "normal" "Connected (Fastest)" 4000
      pkill -RTMIN+1 waybar || true
      exit 0
    fi
  fi
  
  notify_vpn "normal" "Connection failed" 5000
  pkill -RTMIN+1 waybar || true
  exit 1
fi
