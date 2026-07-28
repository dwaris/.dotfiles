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
  notify-send -u "$urgency" -h string:x-canonical-private-synchronous:vpn "VPN" "$msg" >/dev/null 2>&1 || true
}

cli_is_connected() {
  status_out="$(run_with_timeout 10 protonvpn status 2>/dev/null || true)"
  printf '%s' "$status_out" | grep -Eqi '(^|[[:space:]:])connected([[:space:]]|$)' \
    && ! printf '%s' "$status_out" | grep -Eqi 'disconnected|not[[:space:]]+connected'
}

if ! command -v protonvpn >/dev/null 2>&1; then
  notify_vpn "critical" "protonvpn command not found"
  exit 1
fi

if cli_is_connected; then
  notify_vpn "low" "Disconnecting..."
  if run_with_timeout 45 protonvpn disconnect >/dev/null 2>&1; then
    sleep 1
    notify_vpn "normal" "Disconnected"
    pkill -RTMIN+1 waybar || true
    exit 0
  fi
  notify_vpn "critical" "Disconnect failed"
  pkill -RTMIN+1 waybar || true
  exit 1
else
  if [ "$SAFE_MODE" = true ]; then
    SAFE_COUNTRIES="CH IS"
    
    RANDOM_COUNTRY=$(echo "$SAFE_COUNTRIES" | tr ' ' '\n' | shuf -n 1)
    
    notify_vpn "low" "Connecting to: $RANDOM_COUNTRY..."
    if run_with_timeout 60 protonvpn connect --country "$RANDOM_COUNTRY" >/dev/null 2>&1; then
      sleep 1
      notify_vpn "normal" "Connected ($RANDOM_COUNTRY)"
      pkill -RTMIN+1 waybar || true
      exit 0
    fi
  else
    notify_vpn "low" "Connecting to fastest..."
    if run_with_timeout 60 protonvpn connect >/dev/null 2>&1; then
      sleep 1
      notify_vpn "normal" "Connected (Fastest)"
      pkill -RTMIN+1 waybar || true
      exit 0
    fi
  fi
  
  notify_vpn "critical" "Connection failed"
  pkill -RTMIN+1 waybar || true
  exit 1
fi


