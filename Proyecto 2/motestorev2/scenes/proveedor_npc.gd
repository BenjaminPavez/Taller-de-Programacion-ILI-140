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
	await get_tree().create_timer(2.0).timeout  # Reducido para testing
	
	var tienda = get_tree().current_scene.get_node("../moteStore")
	
	match tipo:
		"mote":
			# Actualizar valores locales
			tienda.porcentaje_mote = 100.0
			var nuevo_ph = randf_range(3.0, 6.0)
			tienda.mote_ph.value = nuevo_ph
			# Enviar valores correctos para mote (pH, peso basado en porcentaje)
			var peso_mote = (tienda.porcentaje_mote / 100.0) * 25.0  # peso máximo 25
			_enviar_actualizacion_sensor(
				"mote",
				str(nuevo_ph) + "," + str(peso_mote)
			)
			print("Reposición MOTE: pH=" + str(nuevo_ph) + ", peso=" + str(peso_mote))
			
		"jugo":
			# Actualizar valores locales
			tienda.porcentaje_jugo = 100.0
			var nuevo_ph = randf_range(3.0, 6.0)
			var nuevo_azucar = randf_range(5.0, 20.0)
			tienda.jugo_ph.value = nuevo_ph
			tienda.jugo_azucar.value = nuevo_azucar
			# Enviar valores correctos para jugo (pH, azúcar, altura basada en porcentaje)
			var altura_jugo = tienda.porcentaje_jugo  # altura directa del porcentaje
			_enviar_actualizacion_sensor(
				"jugo",
				str(nuevo_ph) + "," + str(nuevo_azucar) + "," + str(altura_jugo)
			)
			print("Reposición JUGO: pH=" + str(nuevo_ph) + ", azúcar=" + str(nuevo_azucar) + ", altura=" + str(altura_jugo))
			
		"envases":
			# Actualizar valores locales
			tienda.gramos_envases = 600.0
			# Enviar peso correcto para envases
			_enviar_actualizacion_sensor(
				"envases",
				str(tienda.gramos_envases)
			)
			print("Reposición ENVASES: peso=" + str(tienda.gramos_envases))
	
	print("Reposición de " + tipo + " completada")
	
	# Esperar un poco antes de salir para ver el efecto
	await get_tree().create_timer(1.0).timeout
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

func _enviar_actualizacion_sensor(tipo_sensor: String, valor: String):
	print("Enviando actualización - Tipo: " + tipo_sensor + ", Valor: " + valor)
	var http = HTTPRequest.new()
	add_child(http)
	
	# Conectar señales para debug
	http.request_completed.connect(_on_request_completed)
	
	var body = {"tipo": tipo_sensor, "valor": valor}
	var json_body = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	
	# Cambiar puerto a 5001 (publisher)
	var error = http.request("http://localhost:5001/actualizar_sensor", headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("Error enviando request: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("Response code: " + str(response_code))
	if response_code == 200:
		print("Actualización enviada exitosamente")
	else:
		print("Error en actualización: " + body.get_string_from_utf8())
