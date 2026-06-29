#!/usr/bin/env bash
set -euo pipefail

echo "Testing Boom local infrastructure..."
echo

if ! docker info >/dev/null 2>&1; then
  echo "[ERROR] Docker daemon is not running."
  echo "Start Docker Desktop, Colima, or another Docker daemon first."
  exit 1
fi

echo "Docker containers:"
docker ps --filter "name=boom-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo
echo "Testing Nginx..."
curl -fsS http://localhost:8088/ | grep -q "Boom local infrastructure is running"
echo "[OK] Nginx is responding"

echo
echo "Testing health endpoint..."
curl -fsS http://localhost:8088/health | grep -q "OK"
echo "[OK] Health endpoint is responding"

echo
echo "Testing PostgreSQL container health..."
POSTGRES_STATUS="$(docker inspect --format='{{.State.Health.Status}}' boom-postgres 2>/dev/null || true)"
if [[ "$POSTGRES_STATUS" == "healthy" ]]; then
  echo "[OK] PostgreSQL is healthy"
else
  echo "[WARN] PostgreSQL health status: ${POSTGRES_STATUS}"
fi

echo
echo "Testing Redis container health..."
REDIS_STATUS="$(docker inspect --format='{{.State.Health.Status}}' boom-redis 2>/dev/null || true)"
if [[ "$REDIS_STATUS" == "healthy" ]]; then
  echo "[OK] Redis is healthy"
else
  echo "[WARN] Redis health status: ${REDIS_STATUS}"
fi

echo
echo "Local infrastructure is ready."
