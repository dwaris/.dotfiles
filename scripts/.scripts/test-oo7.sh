#!/usr/bin/env bash
set -euo pipefail

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

pass() { echo -e "  [${GREEN}PASS${NC}] $1"; }
fail() { echo -e "  [${RED}FAIL${NC}] $1"; }
info() { echo -e "${BLUE}==>${NC} $1"; }

echo -e "${YELLOW}=== Testing oo7 Keyring & Secret Service Setup ===${NC}\n"

ERRORS=0

# 1. Check oo7-daemon systemd user service
info "1. Checking oo7-daemon systemd service..."
if systemctl --user is-active --quiet oo7-daemon 2>/dev/null || systemctl --user is-active --quiet dbus-org.freedesktop.secrets 2>/dev/null; then
  pass "oo7-daemon service is active and running."
else
  fail "oo7-daemon service is NOT running."
  ERRORS=$((ERRORS + 1))
fi

# 2. Check D-Bus Secret Service ownership
info "2. Checking D-Bus 'org.freedesktop.secrets' owner..."
if busctl --user status org.freedesktop.secrets >/dev/null 2>&1; then
  OWNER_PID=$(busctl --user status org.freedesktop.secrets 2>/dev/null | grep "^PID=" | cut -d= -f2 || echo "active")
  pass "D-Bus interface 'org.freedesktop.secrets' is active (PID: $OWNER_PID)."
else
  fail "'org.freedesktop.secrets' is NOT registered on D-Bus."
  ERRORS=$((ERRORS + 1))
fi

# 3. Verify gnome-keyring is NOT running
info "3. Verifying gnome-keyring is disabled..."
if pgrep -f "gnome-keyring-daemon" >/dev/null; then
  fail "gnome-keyring daemon is still running!"
  ERRORS=$((ERRORS + 1))
else
  pass "gnome-keyring is not running."
fi

# 4. Verify KWallet is NOT running
info "4. Verifying KWallet is disabled..."
if pgrep -f "kwalletd" >/dev/null; then
  fail "kwalletd daemon is still running!"
  ERRORS=$((ERRORS + 1))
else
  pass "kwalletd is not running."
fi

# 5. Check oo7 portal backend...
info "5. Checking oo7 portal backend..."
if systemctl --user is-active --quiet oo7-portal 2>/dev/null || busctl --user status org.freedesktop.impl.portal.desktop.oo7 >/dev/null 2>&1; then
  pass "oo7-portal interface is available."
else
  info "oo7-portal will activate on demand when Flatpak/Portal requests secrets."
fi

# 6. Functional test: Store and lookup secret using secret-tool
info "6. Testing secret storage & retrieval with secret-tool..."
TEST_SERVICE="oo7-test-suite"
TEST_USER="test-user"
TEST_SECRET="oo7-verification-secret-$RANDOM"

if command -v secret-tool >/dev/null 2>&1; then
  if printf "%s" "$TEST_SECRET" | timeout 5 secret-tool store --label="Test Secret" service "$TEST_SERVICE" user "$TEST_USER" >/dev/null 2>&1; then
    RETRIEVED_SECRET=$(secret-tool lookup service "$TEST_SERVICE" user "$TEST_USER" 2>/dev/null || echo "")
    if [[ "$RETRIEVED_SECRET" == "$TEST_SECRET" ]]; then
      pass "Secret successfully stored and retrieved from oo7 keyring via D-Bus!"
      secret-tool clear service "$TEST_SERVICE" user "$TEST_USER" >/dev/null 2>&1 || true
    else
      fail "Retrieved secret mismatch (Expected: $TEST_SECRET, Got: $RETRIEVED_SECRET)"
      ERRORS=$((ERRORS + 1))
    fi
  else
    fail "secret-tool timed out or failed. The oo7 'Login' collection is locked and waiting for a password unlock prompt."
    ERRORS=$((ERRORS + 1))
  fi
else
  fail "secret-tool binary not found in PATH."
  ERRORS=$((ERRORS + 1))
fi

echo ""
if [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}SUCCESS: oo7 keyring is fully functional and operating as your unified secret manager!${NC}"
  exit 0
else
  echo -e "${RED}FAILURE: Detected $ERRORS issue(s) with oo7 keyring setup.${NC}"
  exit 1
fi
