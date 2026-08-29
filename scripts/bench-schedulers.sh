#!/usr/bin/env bash
set -euo pipefail

# Ensure script is run with root/sudo privileges to load/unload BPF schedulers
if [ "$EUID" -ne 0 ]; then
  echo "[-] Requesting sudo access to manage schedulers..."
  exec sudo "$0" "$@"
fi

# Track running background scheduler PID
CURRENT_SCHED_PID=""

stop_current_sched() {
  if [ -n "$CURRENT_SCHED_PID" ] && kill -0 "$CURRENT_SCHED_PID" 2>/dev/null; then
    kill -TERM "$CURRENT_SCHED_PID" 2>/dev/null || true
    wait "$CURRENT_SCHED_PID" 2>/dev/null || true
    CURRENT_SCHED_PID=""
  fi
  pkill -TERM -f "scx_" 2>/dev/null || true
  sleep 0.5
}

# Ensure cleanup on script exit or interrupt
cleanup() {
  echo ""
  echo "[*] Cleaning up background schedulers..."
  stop_current_sched
  pkill -9 -f "scx_" 2>/dev/null || true
  systemctl start scx.service 2>/dev/null || true
  echo "[*] Done."
}
trap cleanup EXIT INT TERM

# Stop background scx service while benchmarking
systemctl stop scx.service 2>/dev/null || true
stop_current_sched

# Determine command wrappers for NixOS
NIX_BENCH_WRAPPER=""
NIX_SCX_WRAPPER=""

if ! command -v hackbench &>/dev/null || ! command -v sysbench &>/dev/null; then
  if command -v nix &>/dev/null; then
    NIX_BENCH_WRAPPER="nix shell nixpkgs#rt-tests nixpkgs#sysbench --command"
  else
    echo "[-] Error: Please install 'rt-tests' and 'sysbench' (e.g. pacman -S rt-tests sysbench)"
    exit 1
  fi
fi

if ! command -v scx_rusty &>/dev/null; then
  if command -v nix &>/dev/null; then
    NIX_SCX_WRAPPER="nix shell nixpkgs#scx.full --command"
  fi
fi

run_bench() {
  if [ -n "$NIX_BENCH_WRAPPER" ]; then
    $NIX_BENCH_WRAPPER "$@"
  else
    "$@"
  fi
}

run_scx() {
  if [ -n "$NIX_SCX_WRAPPER" ] && ! command -v "$1" &>/dev/null; then
    $NIX_SCX_WRAPPER "$@"
  else
    "$@"
  fi
}

echo "========================================================================"
echo "          CachyOS & Sched-ext Automated Scheduler Benchmark             "
echo "  Host: $(hostname)"
echo "  CPU: $(lscpu | grep 'Model name' | sed 's/Model name:[ \t]*//')"
echo "  Cores/Threads: $(nproc) threads"
echo "  Kernel: $(uname -r)"
echo "========================================================================"
echo ""

# Results storage
declare -A HACKBENCH_RESULTS
declare -A SYSBENCH_RESULTS

SCHEDULERS=("BORE (In-Kernel)" "scx_rusty" "scx_lavd" "scx_bpfland")

for SCHED in "${SCHEDULERS[@]}"; do
  echo "------------------------------------------------------------------------"
  echo ">>> Testing Scheduler: $SCHED"
  echo "------------------------------------------------------------------------"

  # Stop previous scheduler cleanly
  stop_current_sched

  # Start scheduler
  case "$SCHED" in
    "BORE (In-Kernel)")
      # No BPF scheduler running = native in-kernel BORE
      ;;
    "scx_rusty")
      run_scx scx_rusty --perf 1024 &>/dev/null &
      CURRENT_SCHED_PID=$!
      ;;
    "scx_lavd")
      run_scx scx_lavd --performance &>/dev/null &
      CURRENT_SCHED_PID=$!
      ;;
    "scx_bpfland")
      run_scx scx_bpfland &>/dev/null &
      CURRENT_SCHED_PID=$!
      ;;
  esac

  # Settle time
  sleep 1.5

  # 1. Hackbench: IPC & Context Switch Latency (Lower is better)
  echo -n "  [1/2] Running Hackbench (Context Switch / IPC)... "
  HB_OUT=$(run_bench hackbench -p -T -l 2500 -g 16 2>&1)
  HB_TIME=$(echo "$HB_OUT" | grep -o 'Time: [0-9.]*' | awk '{print $2}')
  echo "${HB_TIME}s"
  HACKBENCH_RESULTS["$SCHED"]="${HB_TIME:-N/A}"

  # 2. Sysbench: Multi-Threaded Compute Throughput (Higher is better)
  echo -n "  [2/2] Running Sysbench CPU (Multi-core Throughput)... "
  SB_OUT=$(run_bench sysbench cpu --threads="$(nproc)" --cpu-max-prime=25000 run 2>&1)
  SB_EPS=$(echo "$SB_OUT" | grep "events per second:" | awk '{print $4}')
  echo "${SB_EPS} events/sec"
  SYSBENCH_RESULTS["$SCHED"]="${SB_EPS:-N/A}"
  echo ""
done

# Print final comparison table
echo ""
echo "========================================================================"
echo "                         FINAL BENCHMARK RESULTS                        "
echo "========================================================================"
printf "%-20s | %-18s | %-20s\n" "Scheduler" "Hackbench (s) ↓" "Sysbench (eps) ↑"
echo "---------------------+--------------------+---------------------"

for SCHED in "${SCHEDULERS[@]}"; do
  if [ -n "${HACKBENCH_RESULTS[$SCHED]+x}" ]; then
    printf "%-20s | %-18s | %-20s\n" \
      "$SCHED" \
      "${HACKBENCH_RESULTS[$SCHED]}s" \
      "${SYSBENCH_RESULTS[$SCHED]}"
  fi
done
echo "========================================================================"
echo "Notes: (↓ = Lower is better, ↑ = Higher is better)"
