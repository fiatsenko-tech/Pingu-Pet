extends Area2D


func _ready():
	print("AREA DE PRUEBA LISTA")


func _input_event(_viewport, event, _shape_idx):
	print("AREA DE PRUEBA RECIBIÓ INPUT")

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("CLICK EN AREA DE PRUEBA")
