# Use uma imagem que já contém o módulo RTMP
FROM tiangolo/nginx-rtmp:latest

# Remove a configuração padrão para evitar conflitos
RUN rm /etc/nginx/conf.d/default.conf

# Copia sua configuração personalizada do NGINX
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copia os arquivos do seu player para o diretório web padrão do NGINX
COPY ./frontend /var/www/html
