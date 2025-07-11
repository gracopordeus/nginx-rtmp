# Usamos uma imagem base recente do FFmpeg
FROM jrottenberg/ffmpeg:6.1-ubuntu

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o script de inicialização para dentro do container
COPY start_stream.sh .

# Dá permissão de execução ao script
RUN chmod +x ./start_stream.sh

# Expõe a porta interna onde o FFmpeg vai servir o HTTP-FLV
EXPOSE 8080

# Comando para executar o script quando o container iniciar.
# Esta é a forma "exec", que é mais robusta e evita problemas de parsing do shell.
CMD ["./start_stream.sh"]
