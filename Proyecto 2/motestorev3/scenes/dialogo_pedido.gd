extends Node2D

@onready var icono = $HBoxContainer/TextureRect

func mostrar_pedido(tipo: int):
	var ruta_icono = ""

	match tipo:
		1:
			ruta_icono = "res://assets/sprites/moteConJugo.png"
		2:
			ruta_icono = "res://assets/sprites/moteConJugo.png"
		3:
			ruta_icono = "res://assets/sprites/mote.png"
		4:
			ruta_icono = "res://assets/sprites/jugo.png"
		5:
			ruta_icono = "res://assets/sprites/cara.png"

	icono.texture = load(ruta_icono)
