# sensor_publisher.py
import pika
import random
import time

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.queue_declare(queue='sensores_jugo')
channel.queue_declare(queue='sensores_mote')

while True:
    # Datos para jugo
    ph_jugo = round(random.uniform(3.0, 5.0), 2)
    azucar = random.randint(0, 15)
    altura = random.randint(0, 100)
    mensaje_jugo = f"{ph_jugo},{azucar},{altura}"
    channel.basic_publish(exchange='', routing_key='sensores_jugo', body=mensaje_jugo)
    print(f"[PUBLISHER JUGO] Enviado: {mensaje_jugo}")

    # Datos para mote
    ph_mote = round(random.uniform(3.0, 5.0), 2)
    peso = random.randint(0, 50)
    mensaje_mote = f"{ph_mote},{peso}"
    channel.basic_publish(exchange='', routing_key='sensores_mote', body=mensaje_mote)
    print(f"[PUBLISHER MOTE] Enviado: {mensaje_mote}")

    time.sleep(2)