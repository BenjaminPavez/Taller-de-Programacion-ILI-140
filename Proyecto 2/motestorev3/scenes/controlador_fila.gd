extends Node

@export var nodo_fila_clientes: NodePath
@export var punto_salida: Marker2D
const MAX_CLIENTES = 15 #Cantidad maxima de clientes en la fila

var clientes_fila: Array[Node2D] = []

func puede_agregar_cliente() -> bool:
	return clientes_fila.size() < MAX_CLIENTES

func agregar_cliente(cliente: Node2D):
	var nodo_fila = get_node(nodo_fila_clientes)
	nodo_fila.add_child(cliente)
	clientes_fila.append(cliente)
	_actualizar_posiciones()

func agregar_cliente_con_animacion(cliente: Node2D):
	var nodo_fila = get_node(nodo_fila_clientes)
	
	var posicion_en_fila = nodo_fila.global_position + Vector2(0, clientes_fila.size() * 20)
	
	cliente.connect("llego_a_fila", Callable(self, "_on_cliente_llego_a_fila").bind(cliente))

	cliente.caminar_a_fila(posicion_en_fila)
	
func _on_cliente_llego_a_fila(cliente: Node2D):
	var nodo_fila = get_node(nodo_fila_clientes)

	if cliente.get_parent() != null:
		cliente.get_parent().remove_child(cliente)
	
	var old_global_pos = cliente.global_position
	
	nodo_fila.add_child(cliente)
	cliente.global_position = old_global_pos
	
	clientes_fila.append(cliente)

func quitar_cliente():
	if clientes_fila.size() > 0:
		var cliente = clientes_fila.pop_front()
		
		cliente.caminar_a_fila(punto_salida.global_position)
		await cliente.tween_fin
		cliente.queue_free()
		
		await  get_tree().process_frame
		acomodar_fila()

func quitar_cliente_con_animacion(cliente: Node2D):
	clientes_fila.erase(cliente)

	cliente.caminar_a_salida(punto_salida.global_position)

	await cliente.tween_fin
	cliente.queue_free()

	await get_tree().process_frame
	acomodar_fila()

func acomodar_fila():
	var nodo_fila = get_node(nodo_fila_clientes)
	for i in range(clientes_fila.size()):
		var nueva_pos = nodo_fila.global_position + Vector2(0, i * 20)
		clientes_fila[i].caminar_hacia(nueva_pos)

func sacar_siguiente_cliente() -> Node2D:
	if clientes_fila.size() == 0:
		return null
	return clientes_fila[0]
	
func _actualizar_posiciones():
	#organizar visualmente a los clientes
	for i in range(clientes_fila.size()):
		clientes_fila[i].position = Vector2(100, 100 + i * 40)  # Posicion vertical en fila
