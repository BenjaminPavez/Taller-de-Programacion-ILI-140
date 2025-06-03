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

#Recursos totales de la tienda
var porcentaje_mote := 30.0
var porcentaje_jugo := 30.0
var gramos_envases := 200.0 #600 = 30 envases de 20 gramos

var ph_jugo := 4
var azucar_jugo := 8
var ph_mote := 4

func actualizar_niveles_desde_sensores():
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_niveles_recibidos)
	http.request("http://localhost:5000/sensores_jugo") # O el endpoint que tengas

func _on_niveles_recibidos(result, response_code, headers, body):
	if response_code == 200:
		var datos = body.get_string_from_utf8().split(",")
		# Asumiendo que recibes "ph,azucar,altura"
		ph_jugo = float(datos[0])
		azucar_jugo = float(datos[1])
		porcentaje_jugo = float(datos[2])
		# Actualiza los widgets o variables necesarias aquí

func actualizar_niveles_mote():
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_niveles_mote_recibidos)
	http.request("http://localhost:5000/sensores_mote")

func _on_niveles_mote_recibidos(result, response_code, headers, body):
	if response_code == 200:
		var datos = body.get_string_from_utf8().split(",")
		ph_mote = float(datos[0])
		porcentaje_mote = float(datos[1])

func actualizar_niveles_envases():
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_niveles_envases_recibidos)
	http.request("http://localhost:5000/sensores_peso")

func _on_niveles_envases_recibidos(result, response_code, headers, body):
	if response_code == 200:
		gramos_envases = float(body.get_string_from_utf8())

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
	actualizar_niveles_desde_sensores()
	actualizar_niveles_mote()
	actualizar_niveles_envases()

	peso_mote.value = porcentaje_mote
	altura_jugo.value = porcentaje_jugo
	peso_envases.value = gramos_envases

	$SistemaJugo.evaluar(jugo_ph.value, jugo_azucar.value, porcentaje_jugo)
	$SistemaMote.evaluar(mote_ph.value, porcentaje_mote)

	# Alerta por peso de envases
	print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA: %d gr" % gramos_envases)
	if gramos_envases < 100:
		peso_envases_alerta.text = "¡Pocos envases!"
		if not envases_bajo_emitido:
			emit_signal("envases_bajos")
			envases_bajo_emitido = true
	else:
		peso_envases_alerta.text = "Suficientes envases = %d gr" % gramos_envases
		envases_bajo_emitido = false
	
	#Llamar a empleados si hay valores irregulares en azucar o ph
	if jugo_ph.value < 3.5 or jugo_ph.value > 4.5 or jugo_azucar.value < 2.0 or jugo_azucar.value > 10.0:
		if not $ControladorReposicion.empleado_jugo_activo:
			$ControladorReposicion.crear_empleado("jugo")

	if mote_ph.value < 3.5 or mote_ph.value > 4.5:
		if not $ControladorReposicion.empleado_mote_activo:
			$ControladorReposicion.crear_empleado("mote")
