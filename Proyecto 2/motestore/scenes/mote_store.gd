extends Node2D

#Jugo
@onready var jugo_ph = $Sensores/SensorPHjugo/PHJugo
@onready var jugo_ph_alerta = $Sensores/SensorPHjugo/PHJugoAlerta

@onready var altura_jugo = $Sensores/SensorNivelJugo/NivelJugo
@onready var jugo_altura_alerta = $Sensores/SensorNivelJugo/NivelJugoAlerta

@onready var jugo_azucar = $Sensores/SensorAzucarJugo/AzucarJugo
@onready var jugo_azucar_alerta = $Sensores/SensorAzucarJugo/AzucarJugoAlerta

#Mote
@onready var mote_ph = $Sensores/SensorPHmote/PHMote
@onready var mote_ph_alerta = $Sensores/SensorPHmote/PHMoteAlerta

@onready var peso_mote = $Sensores/SensorPesoMote/PesoMote
@onready var peso_mote_alerta = $Sensores/SensorPesoMote/PesoMoteAlerta

#Envases
@onready var peso_envases = $Sensores/SensorEnvases/PesoEnvases
@onready var peso_envases_alerta = $Sensores/SensorEnvases/PesoEnvasesAlerta

func _ready():
	$ControladorTimer.start()
	$SistemaJugo.set_widgets(jugo_ph, jugo_ph_alerta, jugo_azucar_alerta, jugo_altura_alerta)
	$SistemaMote.set_widgets(mote_ph, mote_ph_alerta, peso_mote_alerta)
func _on_controlador_timer_timeout():
	# Simulación
	jugo_ph.value = randf_range(3.0, 20.0)
	jugo_azucar.value = randf_range(5.0, 100.0)
	altura_jugo.value = randf_range(10.0, 100.0)
	mote_ph.value = randf_range(3.0, 20.0)
	peso_mote.value = randf_range(1.0, 100.0)
	peso_envases.value = randf_range(1.0, 30.0)

	# Llamado a sistemas expertos
	$SistemaJugo.evaluar(jugo_ph.value, jugo_azucar.value, altura_jugo.value)
	$SistemaMote.evaluar(mote_ph.value, peso_mote.value)
	# Se revisa el peso de envases (no sistema experto al tener 1 "sensor")
	if peso_envases.value < 5:
		peso_envases_alerta.text = "¡Pocos envases!"
	else:
		peso_envases_alerta.text = "Suficientes envases"
