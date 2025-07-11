#!/bin/bash

CAMERA_URL=${CAMERA_URL:-http://host.docker.internal:8080/video}

ffmpeg -i "$CAMERA_URL" \
  -vcodec libx264 -preset ultrafast -tune zerolatency \
  -f flv rtmp://nginx-rtmp/live/stream
