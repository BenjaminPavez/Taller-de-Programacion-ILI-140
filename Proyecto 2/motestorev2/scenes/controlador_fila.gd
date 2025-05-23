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

'''
#Antigua funcion de agregar cliente con animacion (antes usaba la de arriba a esta) tambien me generaba bugs
func agregar_cliente_con_animacion(cliente: Node2D):
	var nodo_fila = get_node(nodo_fila_clientes)
	
	if cliente.get_parent() != null:
		cliente.get_parent().remove_child(cliente)
	
	#if clientes_fila.size() < 15:
	clientes_fila.append(cliente)
	nodo_fila.add_child(cliente)
		
	await get_tree().process_frame
	var _indice = clientes_fila.size() - 1
	var posicion_en_fila = nodo_fila.global_position + Vector2(0, (_indice + 1) * 50)
	cliente.caminar_hacia(posicion_en_fila)
'''

func agregar_cliente_con_animacion(cliente: Node2D):
	var nodo_fila = get_node(nodo_fila_clientes)
	
	var posicion_en_fila = nodo_fila.global_position + Vector2(0, clientes_fila.size() * 50)
	
	cliente.connect("llego_a_fila", Callable(self, "_on_cliente_llego_a_fila").bind(cliente))

	cliente.caminar_hacia(posicion_en_fila)
	
func _on_cliente_llego_a_fila(cliente: Node2D):
	#Con esto no tira el error pero la fila se desarma
	#if cliente.get_parent() != null:
	#	cliente.get_parent().remove_child(cliente)
	var nodo_fila = get_node(nodo_fila_clientes)
	nodo_fila.add_child(cliente)
	clientes_fila.append(cliente)
	
	# Aqui puede ir logica de turnos en la fila que no me esta funcionando

func quitar_cliente():
	if clientes_fila.size() > 0:
		var cliente = clientes_fila.pop_front()
		
		cliente.caminar_hacia(punto_salida.global_position)
		await cliente.tween_fin
		cliente.queue_free()
		
		await  get_tree().process_frame
		acomodar_fila()

'''
#Antigua funcion de acomodar fila que no me servia o me tiraba bugs
func acomodar_fila():
	var nodo_fila = get_node(nodo_fila_clientes)
	for i in range(clientes_fila.size()):
		var nueva_pos = nodo_fila.global_position + Vector2(0, (i + 1) * 50)
		clientes_fila[i].caminar_hacia(nueva_pos) 
'''
func acomodar_fila():
	var nodo_fila = get_node(nodo_fila_clientes)
	for i in range(clientes_fila.size()):
		var nueva_pos = nodo_fila.global_position + Vector2(0, i * 50)
		clientes_fila[i].caminar_hacia(nueva_pos)

func sacar_siguiente_cliente() -> Node2D:
	if clientes_fila.size() == 0:
		return null
	var cliente = clientes_fila.pop_front()
	cliente.queue_free()
	_actualizar_posiciones()
	return cliente
	
func _actualizar_posiciones():
	#organizar visualmente a los clientes
	for i in range(clientes_fila.size()):
		clientes_fila[i].position = Vector2(100, 100 + i * 40)  # Posicion vertical en fila
