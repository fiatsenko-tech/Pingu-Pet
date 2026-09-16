extends Node2D

var abierto = false

onready var zona_comida = $ZonaComida
onready var panel = $PanelRefrigerador

onready var boton_pescado = $PanelRefrigerador/EspacioPescado/TextureButton
onready var label_pescado = $PanelRefrigerador/EspacioPescado/Label
onready var boton_dona = $PanelRefrigerador/EspacioDona/TextureButton2
onready var label_dona = $PanelRefrigerador/EspacioDona/Label2
onready var boton_cerrar = $PanelRefrigerador/BotonCerrar
onready var plato = get_node("../Plato")

func _ready():
	zona_comida.connect("input_event", self, "_on_ZonaComida_input_event")
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_pescado.connect("pressed", self, "_on_BotonPescado_pressed")
	boton_dona.connect("pressed", self, "_on_BotonDona_pressed")
	
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

func cerrar():
	abierto = false
	panel.hide()

func actualizar_inventario():
	var cantidad_pescado = Inventario.food["pescado"]
	label_pescado.text = "x " + str(cantidad_pescado)
	boton_pescado.disabled = cantidad_pescado <= 0

	var cantidad_dona = Inventario.food["dona"]
	label_dona.text = "x " + str(cantidad_dona)
	boton_dona.disabled = cantidad_dona <= 0

func _on_BotonPescado_pressed():
	if Inventario.food["pescado"] <= 0:
		return

	Inventario.food["pescado"] -= 1
	plato.agregar_alimento("pescado")

	actualizar_inventario()

func _on_BotonDona_pressed():
	if Inventario.food["dona"] <= 0:
		return
	
	Inventario.food["dona"] -= 1
	plato.agregar_alimento("dona")
	
	actualizar_inventario()

func _on_BotonCerrar_pressed():
	cerrar()
