extends TextureButton

var arrastrando = false
var offset = Vector2()


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				arrastrando = true
				offset = rect_global_position - get_global_mouse_position()
			else:
				arrastrando = false
				comprobar_entrega()


func _process(_delta):
	if arrastrando:
		rect_global_position = get_global_mouse_position() + offset


func comprobar_entrega():
	var pingu = get_tree().get_root().get_node("Juego/Pingu")
	var zona_comida = pingu.get_node("ZonaComida")

	var posicion_pescado = get_global_rect().get_center()
	var posicion_pescado_local = pingu.to_local(posicion_pescado)

	var distancia = posicion_pescado_local.distance_to(zona_comida.position)

	print("Distancia del pescado a ZonaComida: ", distancia)

	if distancia <= 42.72:
		if Necesidades.hambre < 100:
			Necesidades.modificar_hambre(17)
			print("¡Pingu comió!")
			print("Hambre: ", Necesidades.hambre)
		else:
			print("Pingu está lleno")
	else:
		print("Pescado soltado fuera de ZonaComida")
