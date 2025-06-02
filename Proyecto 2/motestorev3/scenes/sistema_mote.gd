extends Node

var ph_barra : ProgressBar
var ph_alerta : Label
var peso_alerta : Label

signal mote_bajo
var mote_bajo_emitido := false

func set_widgets(barra_ref: ProgressBar, ph_alerta_ref: Label, peso_alerta_ref: Label):
	ph_barra = barra_ref
	ph_alerta = ph_alerta_ref
	peso_alerta = peso_alerta_ref

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
