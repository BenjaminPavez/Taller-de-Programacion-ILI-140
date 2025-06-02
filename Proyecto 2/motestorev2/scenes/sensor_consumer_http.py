# sensor_consumer_http.py
import pika
from flask import Flask
import threading

app = Flask(__name__)
ultimo_mensaje_jugo = "4.0,7,50"  # Valores iniciales para jugo
ultimo_mensaje_mote = "4.0,25"    # Valores iniciales para mote

def callback_jugo(ch, method, properties, body):
    global ultimo_mensaje_jugo
    ultimo_mensaje_jugo = body.decode()

def callback_mote(ch, method, properties, body):
    global ultimo_mensaje_mote
    ultimo_mensaje_mote = body.decode()

def rabbit_thread():
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()
    channel.queue_declare(queue='sensores_jugo')
    channel.queue_declare(queue='sensores_mote')
    channel.basic_consume(queue='sensores_jugo', on_message_callback=callback_jugo, auto_ack=True)
    channel.basic_consume(queue='sensores_mote', on_message_callback=callback_mote, auto_ack=True)
    channel.start_consuming()

@app.route('/sensores_jugo')
def sensores_jugo():
    return ultimo_mensaje_jugo

@app.route('/sensores_mote')
def sensores_mote():
    return ultimo_mensaje_mote

if __name__ == '__main__':
    threading.Thread(target=rabbit_thread, daemon=True).start()
    app.run(port=5000)