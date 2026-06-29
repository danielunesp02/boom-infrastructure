#!/usr/bin/env bash
set -euo pipefail

TOOLS=(git terraform oci ssh make)

for cmd in "${TOOLS[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd"
  else
    echo "[MISSING] $cmd"
  fi
done

if command -v docker >/dev/null 2>&1; then
  echo "[OK] docker CLI"
  if docker info >/dev/null 2>&1; then
    echo "[OK] docker daemon running"
  else
    echo "[WARN] docker daemon not running"
    echo "Docker local runtime will not work until Docker Desktop, Colima, or another Docker daemon is running."
  fi
else
  echo "[MISSING] docker"
fi

if docker compose version >/dev/null 2>&1; then
  echo "[OK] docker compose"
else
  echo "[WARN] docker compose not available"
fi
