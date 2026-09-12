extends Node2D

var velocidad = 100
var posicion_destino = Vector2.ZERO

var moviendose = false
var direccion = 0


func _process(delta):
	if moviendose:
		position.x += velocidad * direccion * delta

		if direccion == 1 and position.x >= posicion_destino.x:
			position.x = posicion_destino.x
			moviendose = false

		elif direccion == -1 and position.x <= posicion_destino.x:
			position.x = posicion_destino.x
			moviendose = false


func entrar_desde_izquierda():
	position.x = -100
	moviendose = true
	direccion = 1


func entrar_desde_derecha():
	position.x = 1250
	moviendose = true
	direccion = -1


func quedarse_en_destino():
	position = posicion_destino
	moviendose = false

