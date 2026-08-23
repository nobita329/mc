#!/usr/bin/env bash
set -e

PORT="${SERVER_PORT:-25565}"

if command -v bash >/dev/null 2>&1 && (echo > /dev/tcp/127.0.0.1/${PORT}) >/dev/null 2>&1; then
  exit 0
fi

exit 1
