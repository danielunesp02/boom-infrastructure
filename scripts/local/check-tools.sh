#!/usr/bin/env bash
set -euo pipefail

TOOLS=(git docker terraform gh ssh make)

for cmd in "${TOOLS[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd"
  else
    echo "[MISSING] $cmd"
  fi
done

if docker info >/dev/null 2>&1; then
  echo "[OK] docker daemon running"
else
  echo "[MISSING] docker daemon not running"
  echo "Try: colima start"
fi
