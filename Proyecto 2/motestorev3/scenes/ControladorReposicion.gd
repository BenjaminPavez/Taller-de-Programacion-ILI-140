extends Node

@export var sistema_mote_path: NodePath
@export var sistema_jugo_path: NodePath
@export var tienda_path: NodePath

# Proveedor scenes
@export var proveedor_mote_scene: PackedScene
@export var proveedor_jugo_scene: PackedScene
@export var proveedor_envases_scene: PackedScene

var proveedor_mote_activo = false
var proveedor_jugo_activo = false
var proveedor_envases_activo = false

@export var empleado_scene: PackedScene
var empleado_jugo_activo = false
var empleado_mote_activo = false

#func _ready():
	#var sistema_mote = get_node(sistema_mote_path)
	#var sistema_jugo = get_node(sistema_jugo_path)
	#var tienda = get_node(tienda_path)

	#sistema_mote.connect("mote_bajo", Callable(self, "_on_mote_bajo"))
	#sistema_jugo.connect("jugo_bajo", Callable(self, "_on_jugo_bajo"))
	#tienda.connect("envases_bajos", Callable(self, "_on_envases_bajo"))
	
func crear_proveedor(tipo: String):
	var proveedor_escena: PackedScene
	match tipo:
		"mote":
			proveedor_escena = proveedor_mote_scene
			proveedor_mote_activo = true
		"jugo":
			proveedor_escena = proveedor_jugo_scene
			proveedor_jugo_activo = true
		"envases":
			proveedor_escena = proveedor_envases_scene
			proveedor_envases_activo = true

	var proveedor = proveedor_escena.instantiate()
	proveedor.tipo = tipo
	proveedor.global_position = get_node("../PuntoEntradaProveedores").global_position
	get_tree().current_scene.add_child(proveedor)
	
func _on_mote_bajo():
	if not proveedor_mote_activo:
		crear_proveedor("mote")

func _on_jugo_bajo():
	if not proveedor_jugo_activo:
		crear_proveedor("jugo")

func _on_envases_bajo():
	if not proveedor_envases_activo:
		crear_proveedor("envases")
		
func crear_empleado(tipo: String):
	if tipo == "jugo" and empleado_jugo_activo: return
	if tipo == "mote" and empleado_mote_activo: return

	var empleado = empleado_scene.instantiate()
	empleado.tipo = tipo
	empleado.global_position = get_node("../PuntoEntradaEmpleados").global_position
	get_tree().current_scene.add_child(empleado)

	if tipo == "jugo": empleado_jugo_activo = true
	if tipo == "mote": empleado_mote_activo = true
