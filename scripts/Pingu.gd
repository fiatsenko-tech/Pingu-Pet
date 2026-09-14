extends Node2D

var velocidad = 100
var posicion_destino = Vector2.ZERO

var moviendose = false
var direccion = 0

onready var area_comida = $AreaComida

func _ready():
	area_comida.connect("area_entered", self, "_on_area_comida_entered")
	area_comida.connect("area_exited", self, "_on_area_comida_exited")

func _on_area_comida_entered(area):
	print("Comida entro en pingu")

func _on_area_comida_exited(area):
	print("comida salio de pingu")


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

