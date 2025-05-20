extends Node

var ph_barra : ProgressBar
var ph_alerta : Label
var peso_alerta : Label

func set_widgets(barra_ref: ProgressBar, ph_alerta_ref: Label, peso_alerta_ref: Label):
	ph_barra = barra_ref
	ph_alerta = ph_alerta_ref
	peso_alerta = peso_alerta_ref

func evaluar(ph: float, peso: float):
	if ph < 3.5 or ph > 4.5:
		ph_alerta.text = "pH del mote fuera de rango"
		ph_barra.add_theme_color_override("fg_color", Color.RED)
	else:
		ph_alerta.text = "pH correcto"
		ph_barra.add_theme_color_override("fg_color", Color.GREEN)

	if peso < 10:
		peso_alerta.text = "Poco mote disponible"
	else:
		peso_alerta.text = "Cantidad de mote adecuada"
