extends Node2D

var arrastrando = false
var offset = Vector2()
var posicion_original = Vector2()
var tocando_pingu = false

onready var area = $Area2D

func _ready():
	posicion_original = global_position
	
	area.connect("area_entered", self, "_on_area_entered")
	area.connect("area_exited", self, "_on_area_exited")


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if area.get_global_mouse_position().distance_to(global_position) < 200:
				arrastrando = true
				offset = global_position - get_global_mouse_position()
		else:
			arrastrando = false
			global_position = posicion_original
			
			if not tocando_pingu:
				global_position = posicion_original
	
	if event is InputEventMouseMotion and arrastrando:
		global_position = get_global_mouse_position() + offset


func _on_area_entered(area_entrante):
	if area_entrante.name == "AreaBano":
		tocando_pingu = true
		print("Jabon tocando a pingu")


func _on_area_exited(area_saliente):
	if area_saliente.name == "AreaBano":
		tocando_pingu = false
		print("Jabon dejo de tocar a pngu")
