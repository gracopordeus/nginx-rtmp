# Dockerfile

# Use a imagem base oficial do tiangolo/nginx-rtmp
# Esta imagem já vem com o Nginx e o módulo RTMP pré-compilados.
FROM tiangolo/nginx-rtmp:latest

# Remove o arquivo de configuração padrão que vem com a imagem base.
# Isso garante que não haverá conflitos e que apenas a sua configuração será usada.
RUN rm /etc/nginx/nginx.conf

# Copia o seu arquivo de configuração nginx.conf personalizado
# do diretório de build (a raiz do seu repositório Git)
# para dentro do container, no local onde o Nginx espera encontrá-lo.
COPY nginx.conf /etc/nginx/nginx.conf

# O comando padrão (CMD) já é fornecido pela imagem base tiangolo/nginx-rtmp,
# que é 'nginx -g "daemon off;"'. Não precisamos alterá-lo aqui.
# No entanto, se você quisesse, poderia adicionar aqui:
# CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
# Mas a imagem base já se encarrega de usar /etc/nginx/nginx.conf
