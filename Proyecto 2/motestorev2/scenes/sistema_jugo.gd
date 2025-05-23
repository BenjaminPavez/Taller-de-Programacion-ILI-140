extends Node

var ph_barra : ProgressBar
var ph_alerta : Label
var azucar_alerta : Label
var altura_alerta : Label

func set_widgets(barra_ref: ProgressBar, ph_alerta_ref: Label, azucar_alerta_ref: Label, altura_alerta_ref: Label):
	ph_barra = barra_ref
	ph_alerta = ph_alerta_ref
	azucar_alerta = azucar_alerta_ref
	altura_alerta = altura_alerta_ref

func evaluar(ph: float, azucar: float, altura: float):
	# Evaluar pH
	if ph < 3.5 or ph > 4.5:
		ph_alerta.text = "pH fuera de rango"
		ph_barra.add_theme_color_override("fg_color", Color.RED)
	else:
		ph_alerta.text = "pH correcto"
		ph_barra.add_theme_color_override("fg_color", Color.GREEN)

	# Evaluar azucar
	if azucar > 10:
		azucar_alerta.text = "Azúcar alta"
	else:
		azucar_alerta.text = "Azúcar normal"

	# Evaluar nivel de jugo
	if altura < 20:
		altura_alerta.text = "Poco jugo"
	else:
		altura_alerta.text = "Nivel adecuado"
