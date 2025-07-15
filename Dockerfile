# Usa uma imagem base Python slim para ser leve, com o Debian Bullseye
FROM python:3.9-slim-bullseye

# Define a variável de ambiente para a porta SRT.
ENV SRT_PORT 5000

# Instala ffmpeg e outras dependências de sistema necessárias para o OpenCV
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
RUN pip install --no-cache-dir -r requirements.txt

# Copia o seu script Python para dentro do contêiner
COPY srt_inference_script.py /app/srt_inference_script.py

# Expõe a porta UDP para o stream SRT.
EXPOSE ${SRT_PORT}/udp

# --- NOVA LINHA DE DEBUG ---
# Executa o script Python e redireciona stdout e stderr para /dev/null
# para ver se isso ajuda a inicialização ou a capturar erros.
# Esta linha abaixo é mais robusta para capturar a saída inicial.
# Se o problema for com o comando "python" em si, isso vai expor.
CMD ["/bin/bash", "-c", "python /app/srt_inference_script.py 2>&1"]
