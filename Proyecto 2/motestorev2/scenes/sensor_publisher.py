# sensor_publisher.py
import pika
import random
import time

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.queue_declare(queue='sensores_jugo')

while True:
    ph = round(random.uniform(3.0, 5.0), 2)         # pH entre 3.0 y 5.0
    azucar = random.randint(0, 15)                  # Azúcar entre 0 y 15
    altura = random.randint(0, 100)                 # Altura entre 0 y 100
    mensaje = f"{ph},{azucar},{altura}"
    channel.basic_publish(exchange='', routing_key='sensores_jugo', body=mensaje)
    print(f"Enviado: {mensaje}")
    time.sleep(2)