# Dockerfile para FFmpeg como receptor/retransmissor SRT
FROM jrottenberg/ffmpeg:4.4-full # Ou outra imagem FFmpeg completa com SRT support

# O FFmpeg será o comando de entrada do container
# Recebe SRT na porta 1234 e retransmite como FLV via HTTP na porta 8080
# Este é um exemplo, os IPs e portas precisam ser ajustados para o seu caso.
# A URL de saída HTTP precisa ser persistente para o Colab.
CMD ffmpeg -i srt://0.0.0.0:1234?mode=listener -c:v copy -f flv http://127.0.0.1:8080/live/celular_flv
