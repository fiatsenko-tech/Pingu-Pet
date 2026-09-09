extends Node2D

var velocidad = 100
var posicion_centro = 576

var moviendose = false
var direccion = 0


func _process(delta):
	if moviendose:
		position.x += velocidad * direccion * delta

		if direccion == 1 and position.x >= posicion_centro:
			position.x = posicion_centro
			moviendose = false

		elif direccion == -1 and position.x <= posicion_centro:
			position.x = posicion_centro
			moviendose = false


func entrar_desde_izquierda():
	position.x = -100
	moviendose = true
	direccion = 1


func entrar_desde_derecha():
	position.x = 1250
	moviendose = true
	direccion = -1


func quedarse_en_centro():
	position.x = posicion_centro
	moviendose = false
