import cv2
import time

# O URL do stream RTMP, usando o nome do serviço 'srs' como hostname.
# Este nome é resolvido pela rede interna do Docker Compose.
stream_url = 'rtmp://srs:1935/live/livestream'

print(f"Tentando conectar ao stream: {stream_url}")

# Loop para tentar reconectar caso a conexão falhe inicialmente
while True:
    cap = cv2.VideoCapture(stream_url)

    if not cap.isOpened():
        print("Erro: Não foi possível abrir o stream. Tentando novamente em 5 segundos...")
        time.sleep(5)
        continue

    print("Conexão com o stream estabelecida com sucesso.")
    break

while True:
    # Lê um quadro (frame) do vídeo
    ret, frame = cap.read()

    # Se a leitura falhar (por exemplo, o stream terminou), sai do loop
    if not ret:
        print("Stream encerrado ou perdido.")
        break

    # ----------------------------------------------------
    # AQUI ENTRA O SEU CÓDIGO DE INFERÊNCIA YOLO/SSD
    # Exemplo:
    #   results = model.predict(frame)
    #   processed_frame = results.render()
    # ----------------------------------------------------
    
    # Para fins de demonstração, exibimos o quadro original
    # Em um serviço real, você processaria o quadro e talvez enviaria os resultados para outro lugar
    cv2.imshow('Feed para Análise de ML', frame)

    # Pressione 'q' para sair
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Libera os recursos
cap.release()
cv2.destroyAllWindows()
print("Aplicação encerrada.")
