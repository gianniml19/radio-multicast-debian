#!/usr/bin/env bash
# Enable strict mode: fail on unset vars (-u) and pipeline errors (pipefail)
set -uo pipefail

# Path to the playlist file
PLAYLIST="${PLAYLIST:-/data/stations.m3u}"
# Base multicast address (e.g. 239.10.10.X)
BASE_ADDR="${BASE_ADDR:-239.10.10}"
# UDP port for all streams
PORT="${PORT:-5000}"
# Multicast TTL value
TTL="${TTL:-5}"
# Maximum number of streams to launch
MAX_STREAMS="${MAX_STREAMS:-20}"

# Check if playlist file exists
if [[ ! -f "$PLAYLIST" ]]; then
  echo "Playlist $PLAYLIST not found!" >&2
  exit 1
fi

echo "Starting multicast streaming from playlist: $PLAYLIST"
echo "Multicast addresses: ${BASE_ADDR}.X"
echo "Using UDP port: $PORT"
echo "Maximum streams: $MAX_STREAMS"

i=0

# Read playlist line by line
while IFS= read -r raw; do
  # Trim leading/trailing whitespace
  line="$(echo "$raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  # Skip empty lines
  [[ -z "$line" ]] && continue

  # Skip comment lines (#EXTM3U, #EXTINF, etc.)
  [[ "$line" == \#* ]] && continue

  # Only accept http:// or https:// URLs
  if ! echo "$line" | grep -qE '^https?://'; then
    echo "Skipping invalid line: $line"
    continue
  fi

  ((i++))
  # Stop if MAX_STREAMS reached
  if (( i > MAX_STREAMS )); then
    echo "MAX_STREAMS=$MAX_STREAMS reached — ignoring remaining entries."
    break
  fi

  addr="${BASE_ADDR}.${i}"
  echo "[$i] Source: $line -> udp://${addr}:${PORT}"

  # Launch ffmpeg for this stream
  ffmpeg -re -i "$line" \
    -c copy \
    -f mpegts "udp://${addr}:${PORT}?ttl=${TTL}&pkt_size=1316" \
    -loglevel warning -nostats &

done < "$PLAYLIST"

echo "All ffmpeg processes started."
wait
