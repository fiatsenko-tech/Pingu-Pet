extends Node2D

var velocidad = 100
var posicion_destino = Vector2.ZERO

var moviendose = false
var direccion = 0
var mensaje_tiempo = 0.0

signal llego_al_destino

onready var area_comida = $AreaComida
onready var mensaje = $Mensaje

func _ready():
	area_comida.connect("area_entered", self, "_on_area_comida_entered")
	area_comida.connect("area_exited", self, "_on_area_comida_exited")


func _on_area_comida_entered(area):
	print("Comida entro en pingu")


func _on_area_comida_exited(area):
	print("Comida salio de pingu")


func _process(delta):
	if moviendose:
		global_position.x += velocidad * direccion * delta

		if direccion == 1 and global_position.x >= posicion_destino.x:
			global_position.x = posicion_destino.x
			moviendose = false
			emit_signal("llego_al_destino")

		elif direccion == -1 and global_position.x <= posicion_destino.x:
			global_position.x = posicion_destino.x
			moviendose = false
			emit_signal("llego_al_destino")
	
	if mensaje_tiempo > 0:
		mensaje_tiempo -= delta
		
		if mensaje_tiempo <= 0:
			mensaje.hide()

func mostrar_mensaje(texto):
	mensaje.text = texto
	mensaje.show()
	mensaje_tiempo = 2.0
	
func entrar_desde_izquierda():
	global_position.x = -100
	moviendose = true
	direccion = 1


func entrar_desde_derecha():
	global_position.x = 1250
	moviendose = true
	direccion = -1


func quedarse_en_destino():
	global_position = posicion_destino
	moviendose = false
