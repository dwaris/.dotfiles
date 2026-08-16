#!/usr/bin/env bash
set -euo pipefail

KEYRING_FILE="$HOME/.local/share/keyrings/Default.keyring"
LOGIN_FILE="$HOME/.local/share/keyrings/login.keyring"

echo "=== oo7 GNOME Keyring Migration Utility ==="
echo ""

if [[ ! -f "$KEYRING_FILE" && -f "$LOGIN_FILE" ]]; then
  echo "Copying login.keyring to Default.keyring..."
  cp "$LOGIN_FILE" "$KEYRING_FILE"
fi

if [[ ! -f "$KEYRING_FILE" ]]; then
  echo "Error: No legacy keyring found at $KEYRING_FILE"
  exit 1
fi

echo "Legacy keyring found: $KEYRING_FILE"
echo "Please enter the password used to encrypt your old GNOME keyring."
echo ""

# Read password without echoing to terminal
stty -echo
printf "Password: "
read -r KEYRING_PASS
stty echo
echo ""

if [[ -z "$KEYRING_PASS" ]]; then
  echo "Migration canceled: empty password provided."
  exit 1
fi

echo "Starting oo7 keyring migration..."
printf "%s" "$KEYRING_PASS" | oo7-daemon -l -r -v

echo ""
echo "Migration command executed. Restarting oo7-daemon user service..."
systemctl --user restart oo7-daemon

echo ""
echo "Migration complete! Verifying keyring status..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/test-oo7.sh"
