#!/bin/sh
set -eu

OOM_START_DELAY_SECONDS="${OOM_START_DELAY_SECONDS:-5}"
OOM_SLEEP_EVERY_MB="${OOM_SLEEP_EVERY_MB:-2}"
OOM_SLEEP_SECONDS="${OOM_SLEEP_SECONDS:-1}"
OOM_LOG_EVERY_MB="${OOM_LOG_EVERY_MB:-10}"

log_json() {
  while true; do
    now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    printf '{"timestamp":"%s","level":"info","service":"static-http","message":"dummy heartbeat while memory pressure test is running","interval_seconds":5,"details":{"component":"static-file-server","mode":"busybox-httpd","test":"oom-kill-simulation"}}\n' "$now"
    sleep 5
  done
}

consume_memory_forever() {
  chunk="$(dd if=/dev/zero bs=1M count=1 2>/dev/null | tr '\0' 'x')"
  memory_blob=""
  allocated_mb=0

  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '{"timestamp":"%s","level":"info","service":"static-http","message":"starting intentional memory pressure test","details":{"component":"memory-hog","start_delay_seconds":%s,"sleep_every_mb":%s,"sleep_seconds":%s,"log_every_mb":%s,"chunk_size_mb":1}}\n' "$now" "$OOM_START_DELAY_SECONDS" "$OOM_SLEEP_EVERY_MB" "$OOM_SLEEP_SECONDS" "$OOM_LOG_EVERY_MB"

  if [ "$OOM_START_DELAY_SECONDS" -gt 0 ]; then
    sleep "$OOM_START_DELAY_SECONDS"
  fi

  while true; do
    memory_blob="${memory_blob}${chunk}"
    allocated_mb=$((allocated_mb + 1))

    if [ "$OOM_LOG_EVERY_MB" -gt 0 ] && [ $((allocated_mb % OOM_LOG_EVERY_MB)) -eq 0 ]; then
      now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
      printf '{"timestamp":"%s","level":"warn","service":"static-http","message":"intentional memory allocation for OOMKilled testing","allocated_mb":%s,"details":{"component":"memory-hog","chunk_size_mb":1}}\n' "$now" "$allocated_mb" >&2
    fi

    if [ "$OOM_SLEEP_EVERY_MB" -gt 0 ] && [ $((allocated_mb % OOM_SLEEP_EVERY_MB)) -eq 0 ]; then
      sleep "$OOM_SLEEP_SECONDS"
    fi
  done
}

log_json &
busybox httpd -f -v -p 3000 &
consume_memory_forever