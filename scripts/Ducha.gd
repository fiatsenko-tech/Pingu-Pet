extends Node2D

var arrastrando = false
var offset = Vector2()
var posicion_original = Vector2()

onready var area = $Area2D
onready var bano = get_parent()

func _ready():
	area.connect("area_entered", self, "_on_area_entered")
	posicion_original = global_position


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if area.get_global_mouse_position().distance_to(global_position) < 200:
				arrastrando = true
				offset = global_position - get_global_mouse_position()
		else:
			arrastrando = false
			global_position = posicion_original

	if event is InputEventMouseMotion and arrastrando:
		global_position = get_global_mouse_position() + offset


func _on_area_entered(area_entrante):
	if area_entrante.name == "AreaBano":
		if not bano.enjabonado:
			print("Pingu no esta enjabonado")
			return

		var higiene_actual = Necesidades.higiene
		var puntos_faltantes = 100 - higiene_actual

		Necesidades.higiene = 100
		bano.enjabonado = false

		print("Ducha aplicada")
		print("Higiene antes: ", higiene_actual)
		print("Ducha: +", puntos_faltantes)
		print("Higiene despues: ", Necesidades.higiene)
		print("Enjabonado: ", bano.enjabonado)
