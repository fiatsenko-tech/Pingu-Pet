extends Node2D

var encendida = true

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			encendida = !encendida
			
			print ("Lampara encendida: ", encendida)
