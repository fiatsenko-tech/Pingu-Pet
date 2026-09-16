extends Control

var pingu_acostado = false
var pingu_durmiendo = false

onready var lampara = $Lampara

func _ready():
	lampara.connect("estado_cambiado", self, "_on_Lampara_estado_cambiado")
	Necesidades.connect("energia_cambiada", self, "_on_energia_cambiada")

func _on_energia_cambiada():
	actualizar_estado_sueno()

func pingu_llego_a_la_cama():
	pingu_acostado = true
	
	actualizar_estado_sueno()
	
	print("Pingu está acostado: ", pingu_acostado)

func actualizar_estado_sueno():
	if pingu_acostado and not lampara.encendida and Necesidades.energia < 100:
		pingu_durmiendo = true
	else:
		pingu_durmiendo = false
	
	Necesidades.pingu_durmiendo = pingu_durmiendo
	
	print("Pingu durmiendo: ", pingu_durmiendo)

func _on_Lampara_estado_cambiado():
	actualizar_estado_sueno()

func _exit_tree():
	Necesidades.pingu_durmiendo = false
