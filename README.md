# Dan Test HTTP Server

## Build and run in Docker

A very lightweight image based on BusyBox v3.17 (around 4 MB) that serves files from the `files` directory on port 80. `test.html` is the default file that will be served when accessing the root URL.

```bash
docker build -t dan .
docker run --rm --name dan -p 3000:80 dan
# OR sh build.sh
```

## Build and run with JSON logs

Use [`withJsonLogs.Dockerfile`](withJsonLogs.Dockerfile) to keep the same static file serving behavior while also printing a JSON heartbeat log every 5 seconds.

```bash
docker build -f withJsonLogs.Dockerfile -t dan-json-logs .
docker run --rm --name dan-json-logs -p 3000:80 dan-json-logs
```

The container still serves [`files/test.html`](files/test.html) as the root page through BusyBox `httpd`, and stdout/stderr will include JSON log lines like:

```json
{"timestamp":"2026-03-27T09:00:00Z","level":"info","service":"static-http","message":"dummy heartbeat for testing long JSON log lines","interval_seconds":5,"details":{"component":"static-file-server","mode":"busybox-httpd","note":"this log line is intentionally a bit longer to exercise log buffering and transport"}}
```

## Run with Python

```bash
cd files && python3 -m http.server 3000 && cd -
# OR sh run.sh
```
