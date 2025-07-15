import cv2
import numpy as np
import subprocess
import os
import sys
import time

# --- Configurações do Stream ---
# Obtém a porta SRT da variável de ambiente (definida no Dockerfile)
SRT_PORT = os.getenv('SRT_PORT', '5000') # Padrão para 5000 se não estiver definida
# As dimensões devem corresponder à resolução do stream da sua câmera IP Webcam.
# Ajuste conforme necessário para evitar erros de redimensionamento.
# Você pode tentar detectar automaticamente ou assumir uma resolução comum.
# Para este exemplo, estamos assumindo uma resolução.
WIDTH, HEIGHT = 640, 480 # Exemplo: 640x480. Altere para a sua resolução real!

print(f"Iniciando receptor SRT na porta UDP: {SRT_PORT}")
print(f"Resolução esperada do stream: {WIDTH}x{HEIGHT}")

# --- Comando FFmpeg para receber o stream SRT ---
# Este comando instrui o FFmpeg a ouvir o stream SRT e enviá-lo
# como vídeo bruto (rawvideo) para a saída padrão (pipe:1).
# O Python então lerá esta saída padrão.
command = [
    'ffmpeg',
    '-i', f'srt://0.0.0.0:{SRT_PORT}?mode=listener', # Ouve em todas as interfaces na porta SRT
    '-f', 'rawvideo',       # Saída em formato de vídeo bruto
    '-pix_fmt', 'bgr24',    # Formato de pixel BGR24, que é o padrão do OpenCV
    '-s', f'{WIDTH}x{HEIGHT}', # Resolução de saída. ESSENCIAL que seja a do seu stream.
    '-an',                  # Desabilita o áudio
    '-loglevel', 'warning', # Nível de log do FFmpeg (warning, error, fatal, quiet)
    'pipe:1'                # Envia para a saída padrão
]

# Inicia o processo FFmpeg como um subprocesso
# stdout=subprocess.PIPE permite que o script Python leia a saída do FFmpeg
# stderr=subprocess.PIPE para capturar erros e debug
process = None
try:
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print("Processo FFmpeg iniciado. Aguardando conexão SRT...")

    # Loop para ler frames e fazer inferência
    while True:
        # Lê 3 bytes por pixel * largura * altura para um frame BGR24
        raw_frame = process.stdout.read(WIDTH * HEIGHT * 3)

        if not raw_frame:
            # Se não houver mais dados, o stream pode ter terminado ou houve um erro
            print("Fim do stream ou erro ao ler o frame bruto.")
            # Lê o stderr para ver se há mensagens de erro do ffmpeg
            stderr_output = process.stderr.read().decode('utf-8')
            if stderr_output:
                print("Erros do FFmpeg:\n", stderr_output)
            break

        # Converte os bytes brutos para um array NumPy e remodela para o formato de imagem
        frame = np.frombuffer(raw_frame, np.uint8).reshape((HEIGHT, WIDTH, 3))

        # --- AQUI É ONDE VOCÊ INTEGRARIA SEUS MODELOS YOLO/SSD ---
        # Exemplo de processamento (substitua pela sua lógica de inferência):
        # try:
        #     # Exemplo com um modelo de detecção de objetos (YOLO, SSD, etc.)
        #     # Supondo que 'your_detection_model' esteja carregado aqui ou em uma função
        #     # results = your_detection_model.predict(frame)
        #     # frame_with_detections = draw_boxes_on_frame(frame, results)
        #     # cv2.imshow('Inferência YOLO/SSD', frame_with_detections)
        #     pass # Remova esta linha ao integrar seu modelo
        # except Exception as e:
        #     print(f"Erro durante a inferência: {e}", file=sys.stderr)

        # Para fins de demonstração, apenas mostra o frame
        cv2.imshow('SRT Camera Stream (Preview)', frame)

        # Pressione 'q' para sair
        if cv2.waitKey(1) & 0xFF == ord('q'):
            print("Encerrando por solicitação do usuário.")
            break

except KeyboardInterrupt:
    print("Encerrado pelo usuário (Ctrl+C).")
except Exception as e:
    print(f"Ocorreu um erro inesperado: {e}", file=sys.stderr)
finally:
    # Garante que o processo FFmpeg seja encerrado corretamente
    if process and process.poll() is None: # Se o processo ainda estiver rodando
        print("Encerrando processo FFmpeg...")
        process.terminate() # Envia sinal de término
        try:
            process.wait(timeout=5) # Espera até 5 segundos pelo término
        except subprocess.TimeoutExpired:
            print("FFmpeg não encerrou. Matando o processo.")
            process.kill() # Força o encerramento se não terminar
    cv2.destroyAllWindows()
    print("Script encerrado.")
