extends Node2D

var abierto = false

onready var zona_comida = $ZonaComida
onready var panel = $PanelRefrigerador

onready var boton_pescado = $PanelRefrigerador/EspacioPescado/TextureButton
onready var label_pescado = $PanelRefrigerador/EspacioPescado/Label
onready var boton_dona = $PanelRefrigerador/EspacioDona/TextureButton2
onready var label_dona = $PanelRefrigerador/EspacioDona/Label2
onready var label_pizza = $PanelRefrigerador/EspacioPizza/Label3
onready var boton_pizza = $PanelRefrigerador/EspacioPizza/TextureButton4 
onready var label_sushi = $PanelRefrigerador/EspacioSushi/Label4
onready var boton_sushi = $PanelRefrigerador/EspacioSushi/TextureButton6
onready var label_torta = $PanelRefrigerador/EspacioTorta/Label5
onready var boton_torta = $PanelRefrigerador/EspacioTorta/TextureButton5
onready var label_completo = $PanelRefrigerador/EspacioCompleto/Label6
onready var boton_completo = $PanelRefrigerador/EspacioCompleto/TextureButton3
onready var boton_cerrar = $PanelRefrigerador/BotonCerrar
onready var plato = get_node("../Plato")

func _ready():
	zona_comida.connect("input_event", self, "_on_ZonaComida_input_event")
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_pescado.connect("pressed", self, "_on_BotonPescado_pressed")
	boton_dona.connect("pressed", self, "_on_BotonDona_pressed")
	boton_sushi.connect("pressed", self, "_on_BotonSushi_pressed")
	boton_pizza.connect("pressed", self, "_on_BotonPizza_pressed")
	boton_completo.connect("pressed", self, "_on_BotonCompleto_pressed")
	boton_torta.connect("pressed", self, "_on_BotonTorta_pressed")
	
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
	
	var cantidad_pizza = Inventario.food["pizza"]
	label_pizza.text = "x " + str(cantidad_pizza)
	boton_pizza.disabled = cantidad_pizza <= 0
	
	var cantidad_sushi = Inventario.food["sushi"]
	label_sushi.text = "x " + str(cantidad_sushi)
	boton_sushi.disabled = cantidad_sushi <= 0
		
	var cantidad_completo = Inventario.food["completo"]
	label_completo.text = "x " + str(cantidad_completo)
	boton_completo.disabled = cantidad_completo <= 0
		
	var cantidad_torta = Inventario.food["torta"]
	label_torta.text = "x " + str(cantidad_torta)
	boton_torta.disabled = cantidad_torta <= 0

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

func _on_BotonPizza_pressed():
	if Inventario.food["pizza"] <= 0:
		return
	
	Inventario.food["pizza"] -= 1
	plato.agregar_alimento("pizza")
	
	actualizar_inventario()

func _on_BotonSushi_pressed():
	if Inventario.food["sushi"] <= 0:
		return
	
	Inventario.food["sushi"] -= 1
	plato.agregar_alimento("sushi")
	
	actualizar_inventario()

func _on_BotonTorta_pressed():
	if Inventario.food["torta"] <= 0:
		return
	
	Inventario.food["torta"] -= 1
	plato.agregar_alimento("torta")
	
	actualizar_inventario()

func _on_BotonCompleto_pressed():
	if Inventario.food["completa"] <= 0:
		return
	
	Inventario.food["completo"] -= 1
	plato.agregar_alimento("completo")
	
	actualizar_inventario()

func _on_BotonCerrar_pressed():
	cerrar()
