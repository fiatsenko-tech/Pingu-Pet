extends Area2D


func _ready():
	print("🔥 AREA2D DEL REFRIGERADOR ESTÁ LISTA")


func _input_event(viewport, event, shape_idx):
	print("🟢 AREA2D RECIBIÓ INPUT")

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("🖱️ CLICK EN REFRIGERADOR")

	elif event is InputEventScreenTouch:
		if event.pressed:
			print("📱 TOQUE EN REFRIGERADOR")
