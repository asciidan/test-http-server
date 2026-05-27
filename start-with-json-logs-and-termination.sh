#!/bin/sh
set -eu

log_json() {
  while true; do
    now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf '{"timestamp":"%s","level":"info","service":"static-http","message":"dummy heartbeat for testing long JSON log lines","interval_seconds":5,"details":{"component":"static-file-server","mode":"busybox-httpd","note":"this log line is intentionally a bit longer to exercise log buffering and transport"}}\n' "$now"
    sleep 5
  done
}

log_json &
busybox httpd -f -v -p 3000 &

sleep 120
now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
printf '{"timestamp":"%s","level":"error","service":"static-http","message":"Intentional crash for testing","details":{"component":"static-file-server","reason":"timeout"}}\n' "$now" >&2
exit 1
