# Usa uma imagem base Python slim para ser leve, com o Debian Bullseye
FROM python:3.9-slim-bullseye

# Define a variável de ambiente para a porta SRT.
ENV SRT_PORT 5000

# Instala ffmpeg e outras dependências de sistema necessárias para o OpenCV
# E AGORA TAMBÉM INSTALA 'iproute2' para ter o comando 'ss'
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsm6 \
    libxext6 \
    iproute2 \  # <-- Adicione esta linha para instalar iproute2 (que contém 'ss')
    && rm -rf /var/lib/apt/lists/*

# Copia o arquivo de requisitos para que o pip possa instalá-los
COPY requirements.txt /app/requirements.txt

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Instala as dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia o seu script Python para dentro do contêiner
COPY srt_inference_script.py /app/srt_inference_script.py

# Expõe a porta UDP para o stream SRT.
EXPOSE ${SRT_PORT}/udp

# Comando para iniciar o seu script Python (mantém o redirecionamento de erro)
CMD ["/bin/bash", "-c", "python /app/srt_inference_script.py 2>&1"]
