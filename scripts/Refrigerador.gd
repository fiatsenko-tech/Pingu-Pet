extends TextureButton

var panel_refrigerador = null

onready var plato = get_node("../Plato")

func _ready():
	print("PLATO: ", plato)

func _on_Refrigerador_pressed():
	abrir()

func abrir():
	if panel_refrigerador != null and is_instance_valid(panel_refrigerador):
		return
	
	panel_refrigerador = null
	
	var escena_panel = load("res://tscn/PanelRefrigerador.tscn")
	panel_refrigerador = escena_panel.instance()
	
	get_tree().current_scene.add_child(panel_refrigerador)
	panel_refrigerador.configurar(plato)
