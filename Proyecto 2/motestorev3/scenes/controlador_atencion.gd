extends Node

@export var controlador_fila: NodePath
@export var ui_orden: NodePath
@export var tiempo_atencion = 15.0
@export var tienda: Node2D

var pedido_en_espera : Pedido = null
var cliente_pendiente : Node2D = null

var timer := Timer.new()
var ocupado = false
var cliente_atendido: Node2D = null

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_terminar_atencion"))
	set_process(true)

func _process(_delta):
	if not ocupado:
		var fila = get_node(controlador_fila)
		if cliente_pendiente == null and fila.clientes_fila.size() > 0:
			cliente_pendiente = fila.sacar_siguiente_cliente()
			pedido_en_espera = Pedido.new(randi_range(1, 4))
			
			cliente_pendiente.mostrar_pedido(pedido_en_espera.tipo)

		if cliente_pendiente and recursos_suficientes(pedido_en_espera):
			_atender_cliente(cliente_pendiente)

func _atender_cliente(cliente: Node2D):
	ocupado = true
	get_node(ui_orden).text = "Atendiendo a cliente..."
	
	cliente_atendido = cliente
	
	timer.start(tiempo_atencion)

func recursos_suficientes(pedido: Pedido) -> bool:
	return tienda.porcentaje_mote >= pedido.req_mote \
		and tienda.porcentaje_jugo >= pedido.req_jugo \
		and tienda.gramos_envases >= pedido.req_envases

func consumir_sensor(tipo: String, cantidad: float):
	print("Enviando consumo a publisher - Tipo: " + tipo + ", Cantidad: " + str(cantidad))
	var http = HTTPRequest.new()
	add_child(http)
	
	# Conectar señal para debug
	http.request_completed.connect(_on_consumo_completed)
	
	var body = {"tipo": tipo, "cantidad": cantidad}
	var json_body = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	
	# Cambiar puerto a 5001 (publisher)
	var error = http.request("http://localhost:5001/consumir", headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("Error enviando consumo: " + str(error))

func _on_consumo_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code == 200:
		print("Consumo registrado exitosamente")
	else:
		print("Error registrando consumo: " + str(response_code))

func _on_terminar_atencion():
	if cliente_atendido and pedido_en_espera:
		print("Procesando pedido - Mote: " + str(pedido_en_espera.req_mote) + 
			  ", Jugo: " + str(pedido_en_espera.req_jugo) + 
			  ", Envases: " + str(pedido_en_espera.req_envases))
		
		# SOLO enviar consumos al sensor publisher (él será la fuente de verdad)
		if pedido_en_espera.req_mote > 0:
			consumir_sensor("mote", pedido_en_espera.req_mote)
		if pedido_en_espera.req_jugo > 0:
			consumir_sensor("jugo", pedido_en_espera.req_jugo)
		if pedido_en_espera.req_envases > 0:
			consumir_sensor("envases", pedido_en_espera.req_envases)
		
		# Aplicar el gasto localmente también (mantener sincronía local)
		tienda.porcentaje_mote -= pedido_en_espera.req_mote
		tienda.porcentaje_jugo -= pedido_en_espera.req_jugo
		tienda.gramos_envases -= pedido_en_espera.req_envases

		# Clampear a cero
		tienda.porcentaje_mote = max(tienda.porcentaje_mote, 0)
		tienda.porcentaje_jugo = max(tienda.porcentaje_jugo, 0)
		tienda.gramos_envases = max(tienda.gramos_envases, 0)
		
		print("Nuevos niveles locales -> Mote: " + str(tienda.porcentaje_mote) + 
			  ", Jugo: " + str(tienda.porcentaje_jugo) + 
			  ", Envases: " + str(tienda.gramos_envases))
		
		# Se muestra cara feliz y espera 1.5 segundos antes de irse
		cliente_atendido.mostrar_pedido(5)
		await get_tree().create_timer(1.5).timeout

		var fila = get_node(controlador_fila)
		await fila.quitar_cliente_con_animacion(cliente_atendido)

	cliente_atendido = null
	cliente_pendiente = null
	pedido_en_espera = null
	get_node(ui_orden).text = "Libre"
	ocupado = false
