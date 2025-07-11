# ffmpeg-streamer/Dockerfile

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

# AQUI ESTÁ A CORREÇÃO PRINCIPAL:
# Sobrescrevemos o ENTRYPOINT padrão da imagem base (que é "ffmpeg").
# Agora, o container irá executar nosso script diretamente.
ENTRYPOINT ["./start_stream.sh"]

# É uma boa prática limpar o CMD quando se define um ENTRYPOINT.
CMD []
