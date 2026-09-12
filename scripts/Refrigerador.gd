extends Node2D

var abierto = false

onready var zona_comida = $ZonaComida
onready var panel = $PanelRefrigerador
onready var boton_pescado = $PanelRefrigerador/EspacioPescado/TextureButton
onready var label_pescado = $PanelRefrigerador/EspacioPescado/Label
onready var boton_cerrar = $PanelRefrigerador/BotonCerrar


func _ready():
	zona_comida.connect("input_event", self, "_on_ZonaComida_input_event")
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_pescado.connect("pressed", self, "_on_BotonPescado_pressed")
	
	panel.hide()
	


func _on_ZonaComida_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			abrir()


func abrir():
	if abierto:
		return
	
	abierto = true
	panel.show()
	actualizar_inventario()
	print("Refrigerador abierto")


func cerrar():
	abierto = false
	panel.hide()
	print("Refrigerador cerrado")


func actualizar_inventario():
	var cantidad = Inventario.food["pescado"]
	label_pescado.text = "x " + str(cantidad)
	boton_pescado.disabled = cantidad <= 0


func _on_BotonPescado_pressed():
	if Inventario.food["pescado"] <= 0:
		return
	
	Inventario.food["pescado"] -= 1
	
	actualizar_inventario()
	
	print("Pescado retirado. Quedan: ", Inventario.food["pescado"])


func _on_BotonCerrar_pressed():
	cerrar()
