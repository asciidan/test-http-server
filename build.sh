#!/bin/bash

docker build -t dan .
docker run --rm --name dan -p 3000:3000 dan
