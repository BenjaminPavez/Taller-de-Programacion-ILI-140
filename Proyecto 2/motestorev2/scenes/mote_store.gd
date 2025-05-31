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

signal envases_bajos
var envases_bajo_emitido := false

# Recursos totales de la tienda
var porcentaje_mote := 30.0
var porcentaje_jugo := 30.0
var gramos_envases := 200.0 #600 = 30 envases de 20 gramos

var ph_jugo := 4
var azucar_jugo := 8
var ph_mote := 4

func _ready():
	$ControladorTimer.start()
	$SistemaJugo.set_widgets(jugo_ph, jugo_ph_alerta, jugo_azucar_alerta, jugo_altura_alerta)
	$SistemaMote.set_widgets(mote_ph, mote_ph_alerta, peso_mote_alerta)
	
	var controlador = $ControladorReposicion
	$SistemaJugo.connect("jugo_bajo", Callable(controlador, "_on_jugo_bajo"))
	$SistemaMote.connect("mote_bajo", Callable(controlador, "_on_mote_bajo"))
	connect("envases_bajos", Callable(controlador, "_on_envases_bajo"))
	
	jugo_ph.value = ph_jugo
	jugo_azucar.value = azucar_jugo
	mote_ph.value = ph_mote
	
func _on_controlador_timer_timeout():
	peso_mote.value = porcentaje_mote
	altura_jugo.value = porcentaje_jugo
	peso_envases.value = gramos_envases

	$SistemaJugo.evaluar(jugo_ph.value, jugo_azucar.value, porcentaje_jugo)
	$SistemaMote.evaluar(mote_ph.value, porcentaje_mote)

	# Alerta por peso de envases
	if gramos_envases < 100:
		peso_envases_alerta.text = "¡Pocos envases!"
		if not envases_bajo_emitido:
			emit_signal("envases_bajos")
			envases_bajo_emitido = true
	else:
		peso_envases_alerta.text = "Suficientes envases = %d gr" %gramos_envases
		envases_bajo_emitido = false
	
	#Llamar a empleados si hay valores irregulares en azucar o ph (Es como un extra porque no se consideraba en el diagrama)
	if jugo_ph.value < 3.5 or jugo_ph.value > 4.5 or jugo_azucar.value < 2.0 or jugo_azucar.value > 10.0:
		if not $ControladorReposicion.empleado_jugo_activo:
			$ControladorReposicion.crear_empleado("jugo")

	if mote_ph.value < 3.5 or mote_ph.value > 4.5:
		if not $ControladorReposicion.empleado_mote_activo:
			$ControladorReposicion.crear_empleado("mote")
