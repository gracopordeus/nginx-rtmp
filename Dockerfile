# Usa uma imagem base Alpine Linux, que é leve
FROM alpine:latest

# Instala Nginx, openssl e dependências para compilar
RUN apk add --no-cache nginx ffmpeg openssl-dev build-base pcre-dev zlib-dev

# Baixa e compila o módulo Nginx RTMP
RUN wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.zip -O nginx-rtmp-module.zip \
    && unzip nginx-rtmp-module.zip \
    && rm nginx-rtmp-module.zip \
    && cd nginx-rtmp-module-1.2.1 \
    && NGINX_VERSION=$(nginx -v 2>&1 | grep -oP 'nginx/\K[^ ]+') \
    && wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -O nginx.tar.gz \
    && tar -xzf nginx.tar.gz \
    && rm nginx.tar.gz \
    && cd nginx-$NGINX_VERSION \
    && ./configure --with-compat --add-dynamic-module=../nginx-rtmp-module-1.2.1 \
    && make modules \
    && cp objs/*.so /etc/nginx/modules/

# Copia o arquivo de configuração do Nginx personalizado
COPY nginx.conf /etc/nginx/nginx.conf

# Expõe as portas necessárias (RTMP padrão é 1935)
EXPOSE 1935

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
