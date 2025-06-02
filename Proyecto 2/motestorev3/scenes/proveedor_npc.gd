extends Node2D

@export var tipo: String = "mote" # mote, jugo, envases
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var punto_reposicion: Marker2D
var punto_salida: Marker2D
var ultima_direccion: Vector2 = Vector2.DOWN

func _ready():
	punto_reposicion = get_tree().current_scene.get_node("PuntoReposicion_" + tipo)
	punto_salida = get_tree().current_scene.get_node("PuntoSalidaProveedores")
	caminar_hacia(punto_reposicion.global_position, _al_llegar_a_reposicion)

func caminar_hacia(destino: Vector2, al_llegar_callback: Callable):
	var direccion = (destino - global_position).normalized()
	ultima_direccion = direccion
	reproducir_animacion_caminata(direccion)

	var duracion = global_position.distance_to(destino) / 100.0
	var tween = create_tween()
	tween.tween_property(self, "global_position", destino, duracion)
	tween.tween_callback(al_llegar_callback)

func reproducir_animacion_caminata(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if dir.y > 0 else "walk_up")

func reproducir_animacion_parado():
	if abs(ultima_direccion.x) > abs(ultima_direccion.y):
		sprite.play("stand_right" if ultima_direccion.x > 0 else "stand_left")
	else:
		sprite.play("stand_down" if ultima_direccion.y > 0 else "stand_up")

func _al_llegar_a_reposicion():
	reproducir_animacion_parado()
	await get_tree().create_timer(20).timeout
	
	var tienda = get_tree().current_scene.get_node("../moteStore")
	
	match tipo:
		"mote":
			tienda.porcentaje_mote = 100.0
			# Aqui se actualiza aleatoriamente 1 vez el valor de ph mote
			tienda.mote_ph.value = randf_range(3.0, 6.0)
		"jugo":
			tienda.porcentaje_jugo = 100.0
			# Aqui se actualiza aleatoriamente 1 vez el valor de ph y azucar del jugo
			tienda.jugo_ph.value = randf_range(3.0, 6.0)
			tienda.jugo_azucar.value = randf_range(5.0, 20.0)
		"envases":
			tienda.gramos_envases = 600.0
	
	print("Reposición de " + tipo + " completada")
	
	caminar_hacia(punto_salida.global_position, _al_salir)

func _al_salir():
	reproducir_animacion_parado()
	queue_free()

	# Marcar proveedor como libre
	var controlador = get_tree().current_scene.get_node("ControladorReposicion")
	match tipo:
		"mote": controlador.proveedor_mote_activo = false
		"jugo": controlador.proveedor_jugo_activo = false
		"envases": controlador.proveedor_envases_activo = false
