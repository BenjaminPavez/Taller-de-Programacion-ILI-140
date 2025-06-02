extends Node

var ph_barra : ProgressBar
var ph_alerta : Label
var peso_alerta : Label

signal mote_bajo
var mote_bajo_emitido := false

var http := HTTPRequest.new()

func set_widgets(barra_ref: ProgressBar, ph_alerta_ref: Label, peso_alerta_ref: Label):
	ph_barra = barra_ref
	ph_alerta = ph_alerta_ref
	peso_alerta = peso_alerta_ref

func _ready():
	add_child(http)
	http.connect("request_completed", Callable(self, "_on_request_completed"))
	_actualizar_sensores()

func _actualizar_sensores():
	http.request("http://localhost:5000/sensores_mote")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var datos = body.get_string_from_utf8().split(",")
		var ph = float(datos[0])
		var peso = float(datos[1])
		print("[SISTEMA MOTE] Recibido -> pH:", ph, ", Peso:", peso)
		evaluar(ph, peso)
	await get_tree().create_timer(2).timeout
	_actualizar_sensores()

func evaluar(ph: float, peso: float):
	if ph < 3.5 or ph > 4.5:
		ph_alerta.text = "pH del mote fuera de rango = %.1f" %ph
		ph_barra.add_theme_color_override("fg_color", Color.RED)
	else:
		ph_alerta.text = "pH correcto = %.1f" %ph
		ph_barra.add_theme_color_override("fg_color", Color.GREEN)

	if peso < 10:
		peso_alerta.text = "Poco mote disponible"
		if not mote_bajo_emitido:
			emit_signal("mote_bajo")
			mote_bajo_emitido = true
	else:
		peso_alerta.text = "Cantidad de mote adecuada"
		mote_bajo_emitido = false
