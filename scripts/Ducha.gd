extends Node2D

var arrastrando = false
var offset = Vector2()
var posicion_original = Vector2()

var tocando_pingu = false
var distancia_ducha = 0.0
var ultima_posicion = Vector2.ZERO
var distancia_por_nivel = 150.0

onready var area = $Area2D
onready var bano = get_parent()

func _ready():
	area.connect("area_entered", self, "_on_area_entered")
	area.connect("area_exited", self, "_on_area_exited")
	posicion_original = global_position


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if area.get_global_mouse_position().distance_to(global_position) < 200:
				arrastrando = true
				offset = global_position - get_global_mouse_position()
		else:
			arrastrando = false
			global_position = posicion_original

	if event is InputEventMouseMotion and arrastrando:
		global_position = get_global_mouse_position() + offset


func _on_area_entered(area_entrante):
	if area_entrante.name == "AreaBano":
		tocando_pingu = true
		ultima_posicion = global_position
		print("Ducha tocando a pingu")


func _on_area_exited(area_saliente):
	if area_saliente.name == "AreaBano":
		tocando_pingu = false
		print("Ducha dejo de tocar a pingu")


func _process(delta):
	if tocando_pingu and arrastrando:
		var distancia = global_position.distance_to(ultima_posicion)

		distancia_ducha += distancia
		ultima_posicion = global_position

		if distancia_ducha >= distancia_por_nivel:
			distancia_ducha -= distancia_por_nivel

			if bano.pingu.nivel_espuma > 0:
				bano.pingu.nivel_espuma -= 1
				bano.pingu.actualizar_espuma(bano.pingu.nivel_espuma)

				print("Nivel de espuma: ", bano.pingu.nivel_espuma)

				if bano.pingu.nivel_espuma == 0:
					bano.enjabonado = false
					print("Pingu terminó de bañarse")
