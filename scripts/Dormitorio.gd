extends Control

var pingu_acostado = false
var pingu_durmiendo = false

onready var lampara = $Lampara
onready var oscuridad = get_tree().current_scene.get_node("CanvasLayer/Oscuridad")

func _ready():
	lampara.connect("estado_cambiado", self, "_on_Lampara_estado_cambiado")
	
	Necesidades.connect("energia_cambiada", self, "_on_energia_cambiada")
	
	oscuridad.visible = not lampara.encendida

func _on_energia_cambiada():
	if pingu_durmiendo and Necesidades.energia >= 100:
		print("Pingu llegó a 100 de energía → despertando")
		
		var pingu = get_tree().current_scene.get_node("Pingu")
		pingu.despertar()

func pingu_llego_a_la_cama():
	var pingu = get_tree().current_scene.get_node("Pingu")
	pingu.acostarse()

func pingu_termino_de_acostarse():
	pingu_acostado = true
	
	print("Pingu está acostado en la cama")
	
	if not lampara.encendida and Necesidades.energia < 100:
		var pingu = get_tree().current_scene.get_node("Pingu")
		pingu.dormirse()
		pingu_durmiendo = true
		Necesidades.pingu_durmiendo = true
		print("Pingu comenzó a dormir. Energía: ", Necesidades.energia)

func pingu_termino_de_despertar():
	pingu_durmiendo = false
	Necesidades.pingu_durmiendo = false
	
	var pingu = get_tree().current_scene.get_node("Pingu")
	pingu.puede_arrastrarse = true
	
	print("Pingu terminó de despertar. Sigue acostado: ", pingu_acostado)

func _on_Lampara_estado_cambiado():
	
	if lampara.encendida:
		oscuridad.visible = false
	else:
		oscuridad.visible = true
	
	if not pingu_acostado:
		return
	
	var pingu = get_tree().current_scene.get_node("Pingu")
	
	if lampara.encendida:
		print("Lámpara encendida")
		
		if pingu_durmiendo:
			print("Pingu estaba durmiendo → despertando")
			pingu.despertar()
	else:
		print("Lámpara apagada")
		
		if not pingu_durmiendo and Necesidades.energia < 100:
			print("Pingu está acostado y tiene energía menor a 100 → durmiendo")
			pingu.dormirse()
			pingu_durmiendo = true
			Necesidades.pingu_durmiendo = true

func _exit_tree():
	Necesidades.pingu_durmiendo = false
	oscuridad.visible = false
