@echo off

echo Instalando dependencias desde requirements.txt
pip install -r requirements.txt

echo Ejecutando el consumidor
start "" python motestorev3\scenes\sensor_consumer_http.py

echo Ejecutando el publisher
start "" python motestorev3\scenes\sensor_publisher.py

echo Ejecutando simulacion MoteStore
start "" "motestorev3\executable\MoteStore.exe"

echo Simulacion terminada
pause
