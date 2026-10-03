extends TextureButton

signal estado_cambiado

var encendida = true

func _on_Lampara_pressed():
	encendida = !encendida
	
	print("Lampara encendida: ", encendida)
	emit_signal("estado_cambiado")
