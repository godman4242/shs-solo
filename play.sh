#!/bin/bash
# Straw Hat Samurai Duels — local solo launcher.
#
# Starts the local PHP/asset server and launches the patched SWF in Ruffle.
# The game auto-logs in as Guest and auto-starts, so no clicking is needed.
#
# Usage:  ./play.sh          (foreground)
#         ./play.sh --bg     (background)

set -euo pipefail
cd "$(dirname "$0")"

PORT=8765
SWF=shs3_solo.swf

if ! command -v ruffle >/dev/null 2>&1; then
  echo "Ruffle not found. Install with: brew install --cask ruffle" >&2
  exit 1
fi

# Stop any previous instance
pkill -f "solo_server.py" 2>/dev/null || true
pkill -f "ruffle.*${SWF}" 2>/dev/null || true
sleep 1

# Start the local backend
python3 solo_server.py "$PORT" >/tmp/shs-solo.log 2>&1 &
SERVER_PID=$!
sleep 2

# Wait for the server to answer
if ! curl -sk --max-time 5 -o /dev/null "http://playerio.localhost:${PORT}/${SWF}"; then
  echo "Local server failed to start. See /tmp/shs-solo.log" >&2
  exit 1
fi

echo "───────────────────────────────────────────────"
echo "  Straw Hat Samurai Duels — local solo build"
echo "  URL : http://playerio.localhost:${PORT}/${SWF}"
echo "  Auto-logs in as Guest and starts the game."
echo "  Press Ctrl-C to stop."
echo "───────────────────────────────────────────────"

# NOTE: the game is patched to point its PHP backend at
# http://playerio.localhost:8765/solo/server/ — the domain must contain
# "playerio" because the game's own checkSiteLock() gate rejects any other host.
ruffle "http://playerio.localhost:${PORT}/${SWF}" &
RUFFLE_PID=$!

if [ "${1:-}" = "--bg" ]; then
  echo "Running in background (server pid $SERVER_PID, ruffle pid $RUFFLE_PID)."
  exit 0
fi

trap 'kill $RUFFLE_PID $SERVER_PID 2>/dev/null || true' EXIT
wait $RUFFLE_PID
