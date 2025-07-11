#!/bin/sh

# Adiciona uma pausa para garantir que o serviço Nginx esteja pronto para aceitar conexões.
echo "Aguardando 10 segundos para o Nginx iniciar..."
sleep 10

echo "Iniciando o FFmpeg para retransmitir o stream..."

# Comando FFmpeg corrigido:
# - A opção -listen 1 foi movida para antes da URL de saída.
# - Adicionado -an para ignorar o áudio por enquanto (simplifica o debug).
# - O comando é formatado com barras invertidas para melhor legibilidade.
ffmpeg \
    -i rtmp://nginx-rtmp-service:1935/live/celular_flv \
    -c:v copy \
    -an \
    -f flv \
    -listen 1 \
    http://0.0.0.0:8080/live/celular_flv

# Nota: Se o áudio for importante, você pode substituir "-an" (sem áudio) por "-c:a copy" (copiar áudio).
# Mas é uma boa prática começar sem áudio para garantir que o pipeline de vídeo funcione primeiro.
