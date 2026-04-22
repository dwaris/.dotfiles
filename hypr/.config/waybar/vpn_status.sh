#!/usr/bin/env sh

set -u

escape_json() {
  printf '%s' "$1" | sed ':a;N;$!ba;s/\\/\\\\/g;s/"/\\"/g;s/\n/\\n/g'
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

proton_status() {
  if ! command -v protonvpn >/dev/null 2>&1; then
    text="󰖃"
    class="disconnected"
    tooltip="protonvpn command not found"
  else
    # Fast path: if no proton/tun interface exists, it's definitely disconnected
    if ! ip link | grep -Eq "proton|pvpn|tun[0-9]" >/dev/null 2>&1; then
      printf '{"text":"󰖃","class":"disconnected","tooltip":"Proton VPN disconnected"}\n'
      return
    fi

    raw_status="$(run_with_timeout 8 protonvpn status 2>/dev/null || true)"

    if printf '%s' "$raw_status" | grep -Eqi '(^|[[:space:]:])connected([[:space:]]|$)' \
      && ! printf '%s' "$raw_status" | grep -Eqi 'disconnected|not[[:space:]]+connected'; then
      text="󰖂"
      class="connected"
      server_line="$(printf '%s\n' "$raw_status" | grep -Eim1 'server|country|city|ip|gateway')"
      if [ -n "$server_line" ]; then
        tooltip="${server_line}"
      else
        tooltip="Proton VPN connected"
      fi
    else
      text="󰖃"
      class="disconnected"
      tooltip="Proton VPN disconnected"
    fi
  fi

  esc_tooltip="$(escape_json "$tooltip")"
  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$esc_tooltip"
}

proton_status
