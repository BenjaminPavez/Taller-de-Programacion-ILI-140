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
	
func realizar_pedido():
	var pedido = randi_range(1, 4)
	match pedido:
		1:  # 1 Mote con jugo
			tienda.porcentaje_mote -= 2
			tienda.porcentaje_jugo -= 2
			tienda.gramos_envases -= 20
		2:  # 2 Motes con jugo
			tienda.porcentaje_mote -= 4
			tienda.porcentaje_jugo -= 4
			tienda.gramos_envases -= 40
		3:  # Envase con mote
			tienda.porcentaje_mote -= 6
			tienda.gramos_envases -= 20
		4:  # Envase con jugo
			tienda.porcentaje_jugo -= 6
			tienda.gramos_envases -= 20
	
	# Seguridad para evitar valores negativos
	tienda.porcentaje_mote = max(tienda.porcentaje_mote, 0)
	tienda.porcentaje_jugo = max(tienda.porcentaje_jugo, 0)
	tienda.gramos_envases = max(tienda.gramos_envases, 0)

func _on_terminar_atencion():
	if cliente_atendido and pedido_en_espera:
		# Aplicar el gasto
		tienda.porcentaje_mote -= pedido_en_espera.req_mote
		tienda.porcentaje_jugo -= pedido_en_espera.req_jugo
		tienda.gramos_envases -= pedido_en_espera.req_envases

		# Clampear a cero
		tienda.porcentaje_mote = max(tienda.porcentaje_mote, 0)
		tienda.porcentaje_jugo = max(tienda.porcentaje_jugo, 0)
		tienda.gramos_envases = max(tienda.gramos_envases, 0)

		var fila = get_node(controlador_fila)
		await fila.quitar_cliente_con_animacion(cliente_atendido)

	cliente_atendido = null
	cliente_pendiente = null
	pedido_en_espera = null
	get_node(ui_orden).text = "Libre"
	ocupado = false
