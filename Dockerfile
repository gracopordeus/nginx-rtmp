# Usa a versão do Debian que já sabemos que funciona
FROM debian:bullseye-slim

# Define as versões dos componentes
ENV NGINX_VERSION 1.21.6
ENV RTMP_MODULE_VERSION 1.2.2

# Instala as dependências - trocamos 'git' por 'wget'
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpcre3-dev \
    libssl-dev \
    zlib1g-dev \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho para baixar os fontes
WORKDIR /usr/src

# --- CORREÇÃO APLICADA AQUI ---
# Baixa os códigos-fonte usando wget em um formato multi-linha para clareza e robustez
RUN wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    wget -q https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v${RTMP_MODULE_VERSION}.tar.gz -O nginx-rtmp.tar.gz && \
    wget -q https://github.com/VOVKE/nginx-srt-module/archive/refs/heads/master.tar.gz -O nginx-srt.tar.gz

# Extrai os arquivos baixados
RUN tar -xzvf nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzvf nginx-rtmp.tar.gz && \
    tar -xzvf nginx-srt.tar.gz

# Entra no diretório do NGINX extraído para compilar
WORKDIR /usr/src/nginx-${NGINX_VERSION}

# Configura, compila e instala o NGINX com os módulos
RUN ./configure \
    --with-threads \
    --with-http_ssl_module \
    --add-module=../nginx-rtmp-module-${RTMP_MODULE_VERSION} \
    --add-module=../nginx-srt-module-master \
    && make \
    && make install

# Limpa os arquivos de compilação
RUN rm -rf /usr/src/*

# Copia sua configuração do NGINX
COPY ./nginx/nginx.conf /usr/local/nginx/conf/nginx.conf

# Copia os arquivos do seu frontend
COPY ./frontend /usr/local/nginx/html

# Expõe as portas
EXPOSE 80
EXPOSE 10000/udp

# Comando para iniciar o NGINX
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
