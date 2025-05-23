extends Node

@export var controlador_fila: NodePath
@export var ui_orden: NodePath
@export var tiempo_atencion = 15.0

var timer := Timer.new()
var ocupado = false

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_terminar_atencion"))
	set_process(true)
	

func _process(_delta):
	if not ocupado:
		var fila = get_node(controlador_fila)
		if fila.clientes_fila.size() > 0:
			var cliente = fila.sacar_siguiente_cliente()
			_atender_cliente(cliente)

func _atender_cliente(_cliente: Node2D):
	ocupado = true
	get_node(ui_orden).text = "Atendiendo a cliente..."
	timer.start(tiempo_atencion)

func _on_terminar_atencion():
	get_node(ui_orden).text = "Libre"
	ocupado = false
