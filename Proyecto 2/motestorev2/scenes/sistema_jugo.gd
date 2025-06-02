extends Node

var ph_barra : ProgressBar
var ph_alerta : Label
var azucar_alerta : Label
var altura_alerta : Label

signal jugo_bajo
var jugo_bajo_emitido := false

var http := HTTPRequest.new()

func _ready():
	add_child(http)
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	_actualizar_sensores()

func _actualizar_sensores():
	http.request("http://localhost:5000/sensores_jugo")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var datos = body.get_string_from_utf8().split(",")
		var ph = float(datos[0])
		var azucar = float(datos[1])
		var altura = float(datos[2])
		print("[MENSAJE PETICION HTTP] Recibido -> pH:", ph, ", Azúcar:", azucar, ", Altura:", altura)
		evaluar(ph, azucar, altura)
	#Espera 2 segundos y vuelve a pedir datos
	await get_tree().create_timer(2).timeout
	_actualizar_sensores()

func set_widgets(barra_ref: ProgressBar, ph_alerta_ref: Label, azucar_alerta_ref: Label, altura_alerta_ref: Label):
	ph_barra = barra_ref
	ph_alerta = ph_alerta_ref
	azucar_alerta = azucar_alerta_ref
	altura_alerta = altura_alerta_ref

func evaluar(ph: float, azucar: float, altura: float):
	# Evaluar pH
	if ph < 3.5 or ph > 4.5:
		ph_alerta.text = "pH fuera de rango  = %.1f" %ph
		ph_barra.add_theme_color_override("fg_color", Color.RED)
	else:
		ph_alerta.text = "pH correcto = %.1f" %ph
		ph_barra.add_theme_color_override("fg_color", Color.GREEN)

	# Evaluar azucar
	if azucar > 10:
		azucar_alerta.text = "Azúcar alta = %d" %azucar
	elif azucar < 2:
		azucar_alerta.text = "Azúcar baja = %d" %azucar
	else:
		azucar_alerta.text = "Azúcar normal = %d" %azucar

	# Evaluar nivel de jugo
	if altura < 20:
		altura_alerta.text = "Poco jugo"
		if not jugo_bajo_emitido:
			emit_signal("jugo_bajo")
			jugo_bajo_emitido = true
	else:
		altura_alerta.text = "Nivel adecuado"
		jugo_bajo_emitido = false
