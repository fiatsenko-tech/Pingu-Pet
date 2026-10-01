extends Node2D

var panel_refrigerador = null

onready var zona_comida = $ZonaComida
onready var plato = get_node("../Plato")

func _ready():
	zona_comida.connect("input_event", self, "_on_ZonaComida_input_event")

func _on_ZonaComida_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			abrir()

func abrir():
	if panel_refrigerador != null:
		return
	
	var escena_panel = load("res://tscn/PanelRefrigerador.tscn")
	panel_refrigerador = escena_panel.instance()
	
	get_tree().current_scene.add_child(panel_refrigerador)
	panel_refrigerador.configurar(plato)
