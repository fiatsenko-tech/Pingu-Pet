extends Node2D

var arrastrando = false
var offset = Vector2()
var posicion_original = Vector2()
var tocando_pingu = false

var distancia_jabon = 0.0
var ultima_posicion = Vector2.ZERO
var distancia_por_nivel = 150.0

var pingu = null

onready var area = $Area2D

func _ready():
	posicion_original = global_position
	
	pingu = get_parent().get_parent().get_parent().get_node("Pingu")
	
	area.connect("area_entered", self, "_on_area_entered")
	area.connect("area_exited", self, "_on_area_exited")


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if area.get_global_mouse_position().distance_to(global_position) < 200:
				arrastrando = true
				offset = global_position - get_global_mouse_position()
		else:
			arrastrando = false
			global_position = posicion_original
			
			if not tocando_pingu:
				global_position = posicion_original
	
	if event is InputEventMouseMotion and arrastrando:
		global_position = get_global_mouse_position() + offset


func _process(delta):
	if tocando_pingu and arrastrando:
		var distancia = global_position.distance_to(ultima_posicion)

		distancia_jabon += distancia
		ultima_posicion = global_position
		print("Distancia acumulada: ", distancia_jabon)

		if distancia_jabon >= distancia_por_nivel:
			distancia_jabon -= distancia_por_nivel

			if pingu == null:
				print("ERROR: Jabon no encontró a Pingu")
				return

			print("Pingu encontrado: ", pingu)
			print("Nivel de espuma actual: ", pingu.nivel_espuma)

			if pingu.nivel_espuma < 4:
				pingu.nivel_espuma += 1
	
				print("DESPUES DE SUMAR: ", pingu.nivel_espuma)
	
				actualizar_espuma()
		
				print("DESPUES DE ACTUALIZAR ESPUMA: ", pingu.nivel_espuma)


func actualizar_espuma():
	if pingu == null:
		return
		
	print("ESPUMA CAMBIÓ A NIVEL: ", pingu.nivel_espuma)	
	pingu.actualizar_espuma(pingu.nivel_espuma)


func _on_area_entered(area_entrante):
	if area_entrante.name == "AreaBano":
		tocando_pingu = true
		ultima_posicion = global_position
		print("Jabon tocando a pingu")


func _on_area_exited(area_saliente):
	if area_saliente.name == "AreaBano":
		tocando_pingu = false
		print("Jabon dejo de tocar a pingu")
