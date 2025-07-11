ffmpeg -i "http://192.168.0.103:8080/video" \
    -vcodec libx264 -preset ultrafast -tune zerolatency \
    -f flv rtmp://nginx-rtmp/live/stream
