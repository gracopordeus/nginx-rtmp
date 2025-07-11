# ffmpeg-streamer/Dockerfile

# Usamos uma imagem Docker com FFmpeg completo
# jrottenberg/ffmpeg:4.4-full é uma boa opção para começar.
# Se precisar de SRT, verifique se a imagem base suporta ou compile.
FROM jrottenberg/ffmpeg:4.4-full

# Expose a porta onde o FFmpeg vai servir o HTTP-FLV
EXPOSE 8080

# Comando para iniciar o FFmpeg quando o container for iniciado.
# Ele vai ler o stream RTMP do serviço 'nginx-rtmp-service' (nome do serviço no docker-compose)
# e re-transmitir como HTTP-FLV na porta 8080.
# O host 'nginx-rtmp-service' é resolvido pela rede interna do Docker Compose.
# O stream de saída HTTP-FLV será acessível em http://0.0.0.0:8080/live/celular_flv (dentro do container FFmpeg)
# que será mapeado para a porta 8081 da VPS.
CMD ["ffmpeg", \
     "-i", "rtmp://nginx-rtmp-service:1935/live/celular_flv", \
     "-c:v", "copy", \
     "-f", "flv", "http://0.0.0.0:8080/live/celular_flv"]

# Notas:
# - rtmp://nginx-rtmp-service:1935/live/celular_flv : 'nginx-rtmp-service' é o nome do serviço no docker-compose.yml.
# - -c:v copy : Copia o stream de vídeo sem re-encodificação, economizando CPU.
# - -f flv : Formato de saída FLV.
# - http://0.0.0.0:8080/live/celular_flv : FFmpeg serve HTTP-FLV. O '0.0.0.0' permite que ele seja acessível de fora do container.
