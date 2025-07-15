# Usa uma imagem base Python slim para ser leve, com o Debian Bullseye
FROM python:3.9-slim-bullseye

# Define a variável de ambiente para a porta SRT.
# Você pode alterar esta porta, mas certifique-se de que corresponda no EasyPanel e no IP Webcam.
ENV SRT_PORT 5000

# Instala ffmpeg e outras dependências de sistema necessárias para o OpenCV
# (libsm6 e libxext6 são comuns para evitar erros de exibição headless com OpenCV)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Copia o arquivo de requisitos para que o pip possa instalá-los
COPY requirements.txt /app/requirements.txt

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Instala as dependências Python
# --no-cache-dir para economizar espaço
RUN pip install --no-cache-dir -r requirements.txt

# Copia o seu script Python para dentro do contêiner
COPY srt_inference_script.py /app/srt_inference_script.py

# Expõe a porta UDP para o stream SRT.
# É crucial que o protocolo seja UDP.
EXPOSE ${SRT_PORT}/udp

# Comando que será executado quando o contêiner iniciar.
# Ele irá rodar o seu script Python.
CMD ["python", "srt_inference_script.py"]
