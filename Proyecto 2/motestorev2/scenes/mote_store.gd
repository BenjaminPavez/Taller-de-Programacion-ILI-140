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

# Recursos totales de la tienda
var porcentaje_mote := 100.0
var porcentaje_jugo := 100.0
var gramos_envases := 600.0 #600 = 30 envases de 20 gramos

func _ready():
	$ControladorTimer.start()
	$SistemaJugo.set_widgets(jugo_ph, jugo_ph_alerta, jugo_azucar_alerta, jugo_altura_alerta)
	$SistemaMote.set_widgets(mote_ph, mote_ph_alerta, peso_mote_alerta)
func _on_controlador_timer_timeout():
	peso_mote.value = porcentaje_mote
	altura_jugo.value = porcentaje_jugo
	peso_envases.value = gramos_envases
	
	# ph y azucar aleatorios por ahora (luego hay que simularlos bien)
	jugo_ph.value = randf_range(3.0, 6.0)
	jugo_azucar.value = randf_range(5.0, 20.0)
	mote_ph.value = randf_range(3.0, 6.0)

	$SistemaJugo.evaluar(jugo_ph.value, jugo_azucar.value, porcentaje_jugo)
	$SistemaMote.evaluar(mote_ph.value, porcentaje_mote)

	# Alerta por peso de envases
	if gramos_envases < 100:
		peso_envases_alerta.text = "¡Pocos envases!"
	else:
		peso_envases_alerta.text = "Suficientes envases"
