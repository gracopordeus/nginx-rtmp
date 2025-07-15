# Alterado para uma versão mais recente do Debian com suporte
FROM debian:bullseye-slim

# Define as versões para consistência
ENV NGINX_VERSION 1.21.6
ENV RTMP_MODULE_VERSION 1.2.2
ENV DEBIAN_FRONTEND noninteractive

# Instala as dependências necessárias para compilar
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpcre3-dev \
    libssl-dev \
    zlib1g-dev \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Baixa o código-fonte do NGINX
RUN git clone --depth 1 --branch release-${NGINX_VERSION} https://github.com/nginx/nginx.git /usr/src/nginx

# Baixa o código-fonte do módulo NGINX-RTMP
RUN git clone --depth 1 --branch v${RTMP_MODULE_VERSION} https://github.com/arut/nginx-rtmp-module.git /usr/src/nginx-rtmp-module

# Baixa o código-fonte do módulo NGINX-SRT
RUN git clone --depth 1 https://github.com/VOVKE/nginx-srt-module.git /usr/src/nginx-srt-module

# Entra no diretório do NGINX
WORKDIR /usr/src/nginx

# Configura, compila e instala o NGINX com os dois módulos
RUN ./auto/configure \
    --with-threads \
    --with-http_ssl_module \
    --add-module=/usr/src/nginx-rtmp-module \
    --add-module=/usr/src/nginx-srt-module \
    && make \
    && make install

# Limpa os arquivos de compilação para reduzir o tamanho da imagem
RUN rm -rf /usr/src/*

# Copia sua nova configuração do NGINX
COPY ./nginx/nginx.conf /usr/local/nginx/conf/nginx.conf

# Copia os arquivos do seu frontend para o diretório web padrão do NGINX
COPY ./frontend /usr/local/nginx/html

# Expõe as portas que o NGINX vai usar
EXPOSE 80
EXPOSE 10000/udp

# Comando para iniciar o NGINX em modo foreground
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
