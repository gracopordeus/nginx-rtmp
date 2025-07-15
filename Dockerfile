# Usa uma imagem base Alpine Linux, que é leve e inclui o ffmpeg
FROM alpine/ffmpeg:latest

# Define a porta padrão do SRT (pode ser qualquer uma acima de 1024 que esteja livre)
# Vamos usar 5000 para este exemplo
ENV SRT_PORT 5000

# Expõe a porta SRT
EXPOSE ${SRT_PORT}/udp

# O comando que será executado quando o contêiner iniciar.
# ffmpeg irá "ouvir" (listen) na porta especificada para o stream SRT.
# -i srt://0.0.0.0:${SRT_PORT}?mode=listener : Define o input como SRT, escutando em todas as interfaces.
# -c copy : Copia o stream de vídeo e áudio sem re-encode. Isso economiza CPU.
# -f mpegts : Formato de saída para facilitar o acesso via outro ffmpeg/OpenCV no Python.
# udp://127.0.0.1:12345 : Envia o stream decodificado para uma porta UDP interna.
# Isso cria um "túnel" dentro do contêiner que pode ser acessado pelo seu script Python.
CMD ffmpeg -i srt://0.0.0.0:${SRT_PORT}?mode=listener \
           -c copy \
           -f mpegts udp://127.0.0.1:12345
