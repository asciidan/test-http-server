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
exec busybox httpd -f -v -p 80
