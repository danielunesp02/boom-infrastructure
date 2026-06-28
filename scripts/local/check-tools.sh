#!/usr/bin/env bash
set -euo pipefail

for cmd in git terraform docker gh ssh; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd"
  else
    echo "[MISSING] $cmd"
  fi
done
