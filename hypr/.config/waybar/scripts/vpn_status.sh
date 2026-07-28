#!/usr/bin/env sh

set -u

run_with_timeout() {
  seconds="$1"
  shift
  if command -v timeout >/dev/null 2>&1; then
    timeout "$seconds" "$@"
  else
    "$@"
  fi
}

escape_json() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | awk '{if (NR>1) printf "\\n"; printf "%s", $0}'
}

proton_status() {
  if ! command -v protonvpn >/dev/null 2>&1; then
    text=""
    class="disconnected"
    tooltip="protonvpn command not found"
  else
    if ! ip link 2>/dev/null | grep -Eq "proton|pvpn|tun" >/dev/null 2>&1; then
      printf '{"text":"","class":"disconnected","tooltip":"Proton VPN disconnected"}\n'
      return
    fi

    raw_status="$(run_with_timeout 8 protonvpn status 2>/dev/null || true)"

    if printf '%s' "$raw_status" | grep -Eqi '(^|[[:space:]:])connected([[:space:]]|$)' \
      && ! printf '%s' "$raw_status" | grep -Eqi 'disconnected|not[[:space:]]+connected'; then
      text=""
      class="connected"

      # 14 Eyes: US, UK, CA, AU, NZ (5) + DK, FR, NL, NO (9) + DE, BE, IT, ES, SE (14)
      eyes_regex="United States|United Kingdom|Canada|Australia|New Zealand|Denmark|France|Netherlands|Norway|Germany|Belgium|Italy|Spain|Sweden"

      # Extract relevant detail lines for a rich tooltip
      details="$(printf '%s\n' "$raw_status" | grep -Ei 'server|country|city|ip|gateway|protocol|load' | sed 's/^[[:space:]]*//')"

      if [ -n "$details" ]; then
        tooltip="$details"
      else
        tooltip="Proton VPN connected"
      fi

      if printf '%s' "$raw_status" | grep -Eqi "$eyes_regex"; then
        class="warning"
      fi
    else
      text=""
      class="disconnected"
      tooltip="Proton VPN disconnected"
    fi
  fi

  esc_tooltip="$(escape_json "$tooltip")"
  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$esc_tooltip"
}

proton_status

