# Dan Test HTTP Server

## Build and run in Docker

A very lightweight image based on BusyBox v3.17 (around 4 MB) that serves files from the `files` directory on port 80. `test.html` is the default file that will be served when accessing the root URL.

```bash
docker build -t dan .
docker run --rm --name dan -p 3000:80 dan
# OR sh build.sh
```

## Run with Python

```bash
cd files && python3 -m http.server 3000 && cd -
# OR sh run.sh
```
