# sensor_consumer_http.py
import pika
from flask import Flask, jsonify
import threading
import json

app = Flask(__name__)

# Variables globales para almacenar los últimos mensajes
ultimo_mensaje_jugo = "4.0,7,50"  # Valores iniciales para jugo
ultimo_mensaje_mote = "4.0,25"    # Valores iniciales para mote
ultimo_mensaje_peso = "600.0"     # Valor inicial para el peso de los vasos

def callback_peso(ch, method, properties, body):
    global ultimo_mensaje_peso
    ultimo_mensaje_peso = body.decode()
    print(f"[CONSUMER] Peso actualizado: {ultimo_mensaje_peso}")

def callback_jugo(ch, method, properties, body):
    global ultimo_mensaje_jugo
    ultimo_mensaje_jugo = body.decode()
    print(f"[CONSUMER] Jugo actualizado: {ultimo_mensaje_jugo}")

def callback_mote(ch, method, properties, body):
    global ultimo_mensaje_mote
    ultimo_mensaje_mote = body.decode()
    print(f"[CONSUMER] Mote actualizado: {ultimo_mensaje_mote}")

def rabbit_thread():
    try:
        connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
        channel = connection.channel()
        
        # Declarar las colas
        channel.queue_declare(queue='sensores_jugo')
        channel.queue_declare(queue='sensores_mote')
        channel.queue_declare(queue='sensores_peso')
        
        # Configurar consumers
        channel.basic_consume(queue='sensores_jugo', on_message_callback=callback_jugo, auto_ack=True)
        channel.basic_consume(queue='sensores_mote', on_message_callback=callback_mote, auto_ack=True)
        channel.basic_consume(queue='sensores_peso', on_message_callback=callback_peso, auto_ack=True)
        
        print("[CONSUMER] Iniciando consumo de mensajes RabbitMQ...")
        channel.start_consuming()
    except Exception as e:
        print(f"Error en RabbitMQ thread: {e}")

@app.route('/sensores_peso')
def sensores_peso():
    return ultimo_mensaje_peso

@app.route('/sensores_jugo')
def sensores_jugo():
    return ultimo_mensaje_jugo

@app.route('/sensores_mote')
def sensores_mote():
    return ultimo_mensaje_mote

@app.route('/estado_completo')
def estado_completo():
    try:
        # Parsear los datos
        ph_jugo, azucar, altura = map(float, ultimo_mensaje_jugo.split(','))
        ph_mote, peso_mote = map(float, ultimo_mensaje_mote.split(','))
        peso_envases = float(ultimo_mensaje_peso)
        
        return jsonify({
            "jugo": {"ph": ph_jugo, "azucar": azucar, "altura": altura},
            "mote": {"ph": ph_mote, "peso": peso_mote},
            "envases": {"peso": peso_envases}
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health')
def health():
    return jsonify({"status": "OK", "consumer": "running"})

if __name__ == '__main__':
    # Iniciar el hilo de RabbitMQ
    threading.Thread(target=rabbit_thread, daemon=True).start()
    print("Iniciando sensor_consumer en puerto 5000...")
    app.run(host='0.0.0.0', port=5000, debug=False)