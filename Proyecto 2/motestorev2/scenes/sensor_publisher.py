# sensor_publisher.py
import pika
import time
from flask import Flask, request, jsonify
import threading

# Configuración de RabbitMQ
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.queue_declare(queue='sensores_jugo')
channel.queue_declare(queue='sensores_mote')
channel.queue_declare(queue='sensores_peso')

# Estado actual de los sensores
estado_jugo = {"ph": 4.0, "azucar": 10, "altura": 100}
estado_mote = {"ph": 4.0, "peso": 25}
estado_envases = {"peso": 600.0}

app = Flask(__name__)

@app.route('/actualizar_sensor', methods=['POST'])
def actualizar_sensor():
    global estado_jugo, estado_mote, estado_envases
    try:
        data = request.get_json()
        tipo = data['tipo']
        valor = data['valor']
        
        if tipo == "mote":
            ph, peso = map(float, valor.split(","))
            estado_mote = {"ph": ph, "peso": peso}
            print(f"[Reposición MOTE] pH: {ph}, Peso: {peso}")
        elif tipo == "jugo":
            ph, azucar, altura = map(float, valor.split(","))
            estado_jugo = {"ph": ph, "azucar": azucar, "altura": altura}
            print(f"[Reposición JUGO] pH: {ph}, Azúcar: {azucar}, Altura: {altura}")
        elif tipo == "envases":
            peso = float(valor)
            estado_envases = {"peso": peso}
            print(f"[Reposición VASOS] Peso: {peso}")
        
        return jsonify({"status": "OK"})
    except Exception as e:
        print(f"Error actualizando sensor: {e}")
        return jsonify({"status": "ERROR", "message": str(e)}), 400

@app.route('/consumir', methods=['POST'])
def consumir():
    global estado_jugo, estado_mote, estado_envases
    try:
        data = request.get_json()
        print(f"[DEBUG] Petición recibida en /consumir: {data}")
        
        tipo = data['tipo']
        cantidad = float(data['cantidad'])
        
        if tipo == "jugo":
            estado_jugo["altura"] = max(0, estado_jugo["altura"] - cantidad)
            print(f"[Consumo JUGO] Consumido: {cantidad}, Nuevo nivel: {estado_jugo['altura']}")
        elif tipo == "mote":
            estado_mote["peso"] = max(0, estado_mote["peso"] - cantidad)
            print(f"[Consumo MOTE] Consumido: {cantidad}, Nuevo peso: {estado_mote['peso']}")
        elif tipo == "envases":
            estado_envases["peso"] = max(0, estado_envases["peso"] - cantidad)
            print(f"[Consumo VASOS] Consumido: {cantidad}, Nuevo peso: {estado_envases['peso']}")
        
        return jsonify({"status": "OK"})
    except Exception as e:
        print(f"Error procesando consumo: {e}")
        return jsonify({"status": "ERROR", "message": str(e)}), 400

@app.route('/estado', methods=['GET'])
def obtener_estado():
    return jsonify({
        "jugo": estado_jugo,
        "mote": estado_mote,
        "envases": estado_envases
    })

def publicar_estado():
    while True:
        try:
            mensaje_jugo = f"{estado_jugo['ph']},{estado_jugo['azucar']},{estado_jugo['altura']}"
            channel.basic_publish(exchange='', routing_key='sensores_jugo', body=mensaje_jugo)
            
            mensaje_mote = f"{estado_mote['ph']},{estado_mote['peso']}"
            channel.basic_publish(exchange='', routing_key='sensores_mote', body=mensaje_mote)
            
            mensaje_envases = f"{estado_envases['peso']}"
            channel.basic_publish(exchange='', routing_key='sensores_peso', body=mensaje_envases)
            
            print(f"[PUBLICAR ESTADO] Jugo: {mensaje_jugo} | Mote: {mensaje_mote} | Envases: {mensaje_envases}")
        except Exception as e:
            print(f"Error publicando estado: {e}")
        
        time.sleep(2)

if __name__ == "__main__":
    # Iniciar el hilo de publicación
    threading.Thread(target=publicar_estado, daemon=True).start()
    print("Iniciando sensor_publisher en puerto 5001...")
    app.run(host='0.0.0.0', port=5001, debug=False)