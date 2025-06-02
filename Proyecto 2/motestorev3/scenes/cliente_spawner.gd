extends Node

@onready var cliente_escena = preload("res://scenes/ClientNPC/cliente.tscn")
@export var punto_entrada: Marker2D
@export var controlador_fila: NodePath

@export var min_llegada = 5.0 #Minimo tiempo para spawn de cliente
@export var max_llegada = 10.0 #Maximo tiempo para spawn de cliente

var timer := Timer.new()

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	_siguiente_cliente()

func _siguiente_cliente():
	var tiempo = randf_range(min_llegada, max_llegada)
	timer.start(tiempo)
	
func _on_timer_timeout():
	var fila = get_node(controlador_fila)
	var cliente = cliente_escena.instantiate()
	get_parent().add_child(cliente)
	
	cliente.global_position = punto_entrada.global_position

	if fila.puede_agregar_cliente():
		fila.agregar_cliente_con_animacion(cliente)
	else:
		# Cliente no entra en la fila, se va directamente al punto de salida
		cliente.connect("tween_fin", Callable(cliente, "queue_free"))
		var punto_salida = fila.punto_salida.global_position
		cliente.caminar_a_salida(punto_salida)
	
	_siguiente_cliente()
