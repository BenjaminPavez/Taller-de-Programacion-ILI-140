# sensor_consumer_http.py
import pika
from flask import Flask
import threading

app = Flask(__name__)
ultimo_mensaje = "4.0,7,50"  # Valores iniciales

def callback(ch, method, properties, body):
    global ultimo_mensaje
    ultimo_mensaje = body.decode()

def rabbit_thread():
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()
    channel.queue_declare(queue='sensores_jugo')
    channel.basic_consume(queue='sensores_jugo', on_message_callback=callback, auto_ack=True)
    channel.start_consuming()

@app.route('/sensores_jugo')
def sensores_jugo():
    return ultimo_mensaje

if __name__ == '__main__':
    threading.Thread(target=rabbit_thread, daemon=True).start()
    app.run(port=5000)