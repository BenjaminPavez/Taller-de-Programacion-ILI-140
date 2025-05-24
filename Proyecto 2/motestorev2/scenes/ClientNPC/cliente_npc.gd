extends Node2D

signal tween_fin
signal llego_a_fila
@onready var sprite = $Cliente

# Variables para movimiento
var destino: Vector2
var velocidad = 100.0

func _animar_direccion(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite.play("walk_right")
		else:
			sprite.play("walk_left")
	else:
		if dir.y > 0:
			sprite.play("walk_down")
		else:
			sprite.play("walk_up")
			

func caminar_hacia(posicion: Vector2):
	destino = posicion
	
	var direccion = (destino - global_position).normalized()
	_animar_direccion(direccion)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", destino, global_position.distance_to(destino) / velocidad)
	tween.connect("finished", _al_llegar_salida)

func caminar_a_fila(posicion: Vector2):
	destino = posicion
	var direccion = (destino - global_position).normalized()
	_animar_direccion(direccion)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", destino, global_position.distance_to(destino) / velocidad)
	tween.connect("finished", Callable(self, "_al_llegar_fila"))

func caminar_a_salida(posicion: Vector2):
	destino = posicion
	var direccion = (destino - global_position).normalized()
	_animar_direccion(direccion)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", destino, global_position.distance_to(destino) / velocidad)
	tween.connect("finished", Callable(self, "_al_llegar_salida"))

func _al_llegar_fila():
	_animar_idle()
	emit_signal("llego_a_fila")

func _al_llegar_salida():
	_animar_idle()
	emit_signal("tween_fin")

func _animar_idle():
	var dir = (destino - global_position).normalized()
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite.play("stand_right")
		else: 
			sprite.play("stand_left")
	else:
		if dir.y > 0:
			sprite.play("stand_down")
		else: 
			sprite.play("stand_up")
