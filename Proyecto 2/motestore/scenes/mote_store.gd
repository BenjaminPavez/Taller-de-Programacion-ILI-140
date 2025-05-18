extends Node2D

# Variables que simulan los niveles
var nivel_jugo = 100
var nivel_mote = 100
var nivel_envases = 100

func _ready():
	$ControladorTimer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	nivel_jugo -= randi() % 5
	nivel_mote -= randi() % 3
	nivel_envases -= 1

	# Limita los valores
	nivel_jugo = clamp(nivel_jugo, 0, 100)
	nivel_mote = clamp(nivel_mote, 0, 100)
	nivel_envases = clamp(nivel_envases, 0, 100)

	actualizar_barras()
	verificar_suministros()

func actualizar_barras():
	$BarraJugo.value = nivel_jugo
	$BarraMote.value = nivel_mote
	$BarraEnvases.value = nivel_envases

func verificar_suministros():
	if nivel_jugo <= 20:
		print("⚠️ Poco jugo")
	if nivel_mote <= 20:
		print("⚠️ Poco mote")
	if nivel_envases <= 10:
		print("⚠️ Pocos envases")
