extends Node2D

@export var tipo: String = "jugo" # o "mote"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var punto_limpieza: Marker2D
var punto_salida: Marker2D
var ultima_direccion: Vector2 = Vector2.DOWN

func _ready():
	punto_limpieza = get_tree().current_scene.get_node("PuntoReposicion_" + tipo)
	punto_salida = get_tree().current_scene.get_node("PuntoSalidaEmpleados")
	caminar_hacia(punto_limpieza.global_position, _al_llegar_a_limpieza)

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

func _al_llegar_a_limpieza():
	reproducir_animacion_parado()
	await get_tree().create_timer(10).timeout

	var mote_store = get_tree().current_scene
	match tipo:
		"jugo":
			mote_store.jugo_ph.value = randf_range(3.5, 4.5)
			mote_store.jugo_azucar.value = randf_range(3.0, 10.0)
		"mote":
			mote_store.mote_ph.value = randf_range(3.5, 4.5)

	caminar_hacia(punto_salida.global_position, _al_salir)

func _al_salir():
	reproducir_animacion_parado()
	queue_free()

	var controlador = get_tree().current_scene.get_node("ControladorReposicion")
	match tipo:
		"jugo": controlador.empleado_jugo_activo = false
		"mote": controlador.empleado_mote_activo = false
