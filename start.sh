#!/usr/bin/env bash
set -e
PORT=${PORT:-8080}
OPEN_URL=${OPEN_URL:-1}

ensure_node() {
  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    return 0
  fi
  if command -v brew >/dev/null 2>&1; then
    echo "Node not found. Installing Node via Homebrew..."
    brew install node
    return 0
  fi
  echo "Node is missing and Homebrew not found."
  echo "Install Homebrew: https://brew.sh, then rerun this script."
  exit 1
}

ensure_http_server() {
  if command -v npx >/dev/null 2>&1; then
    return 0
  fi
  if command -v http-server >/dev/null 2>&1; then
    return 0
  fi
  echo "Installing http-server globally..."
  npm install -g http-server
}

impl="node"

ensure_node
ensure_http_server

if [ "$OPEN_URL" = "1" ]; then
  if command -v open >/dev/null 2>&1; then
    open "http://localhost:$PORT" >/dev/null 2>&1 &
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "http://localhost:$PORT" >/dev/null 2>&1 &
  fi
fi

if command -v npx >/dev/null 2>&1; then
  npx http-server . -p "$PORT" -c-1
elif command -v http-server >/dev/null 2>&1; then
  http-server . -p "$PORT" -c-1
else
  echo "http-server was not found even after install attempt."
  echo "You can try: npm install -g http-server"
  exit 1
fi
