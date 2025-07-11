# nginx-rtmp/Dockerfile

# Usamos a imagem original do tiangolo/nginx-rtmp
FROM tiangolo/nginx-rtmp:latest

# Remove o arquivo de configuração padrão
RUN rm -f /etc/nginx/nginx.conf

# Copia o seu nginx.conf personalizado (apenas RTMP)
COPY nginx.conf /etc/nginx/nginx.conf
