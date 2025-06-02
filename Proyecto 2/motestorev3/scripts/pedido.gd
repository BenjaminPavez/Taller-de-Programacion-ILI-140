class_name Pedido

var tipo : int
var req_mote : float = 0
var req_jugo : float = 0
var req_envases : float = 0

func _init(tipo_pedido: int):
	tipo = tipo_pedido
	match tipo:
		1:
			req_mote = 2
			req_jugo = 2
			req_envases = 20
		2:
			req_mote = 4
			req_jugo = 4
			req_envases = 40
		3:
			req_mote = 6
			req_envases = 20
		4:
			req_jugo = 6
			req_envases = 20
