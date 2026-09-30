extends Node2D

var posicion_destino = Vector2.ZERO
var mensaje_tiempo = 0.0
var nivel_espuma = 0
var habitacion_actual = 0

var arrastrando = false
var offset_arrastre = Vector2.ZERO
var posicion_anterior = Vector2.ZERO
var sobre_cama = false
var posicion_cama = Vector2.ZERO
var puede_arrastrarse = true

signal llego_al_destino
signal termino_de_acostarse
signal termino_de_despertar

onready var area_comida = $AreaComida
onready var area_arrastre = $AreaArrastre
onready var mensaje = $Mensaje
onready var animated_sprite = $AnimatedSprite
onready var animated_sprite_espuma = $AnimatedSpriteEspuma

func _ready():
	area_comida.connect("area_entered", self, "_on_area_comida_entered")
	area_comida.connect("area_exited", self, "_on_area_comida_exited")
	
	area_arrastre.connect("input_event", self, "_on_area_arrastre_input_event")
	area_arrastre.connect("area_entered", self, "_on_area_arrastre_area_entered")
	area_arrastre.connect("area_exited", self, "_on_area_arrastre_area_exited")
	
	animated_sprite.connect("animation_finished", self, "_on_animation_finished")
	
	animated_sprite.play("idle")
	animated_sprite_espuma.play("sin_espuma")

func _on_area_arrastre_input_event(viewport, event, shape_idx):
	if habitacion_actual != 2:
		return
	
	if not puede_arrastrarse:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				arrastrando = true
				posicion_anterior = global_position
				offset_arrastre = global_position - get_global_mouse_position()
			else:
				arrastrando = false
				
				if sobre_cama:
					global_position = posicion_cama
					quedarse_en_cama()
				else:
					global_position = posicion_anterior

func quedarse_en_cama():
	puede_arrastrarse = false
	animated_sprite.play("acostado")
	emit_signal("termino_de_acostarse")

func _on_area_arrastre_area_entered(area):
	print("ENTRO A UN AREA: ", area.name)
	
	if habitacion_actual != 2:
		return
	
	if area.name == "AreaCama":
		print("ENCONTRO LA CAMA")
		sobre_cama = true
		posicion_cama = area.get_parent().get_node("PosicionPinguCama").global_position

func _on_area_arrastre_area_exited(area):
	print("SALIO DE UN AREA: ", area.name)
	
	if area.name == "AreaCama":
		sobre_cama = false
		
func _on_area_comida_entered(area):
	print("Comida entro en pingu")

func _on_area_comida_exited(area):
	print("Comida salio de pingu")

func _process(delta):
	if arrastrando:
		global_position = get_global_mouse_position() + offset_arrastre
	
	if mensaje_tiempo > 0:
		mensaje_tiempo -= delta
		
		if mensaje_tiempo <= 0:
			mensaje.hide()

func _on_animation_finished():
	if animated_sprite.animation == "comer":
		animated_sprite.play("idle")
	
	elif animated_sprite.animation == "acostarse":
		print("Animación acostarse terminó")
		emit_signal("termino_de_acostarse")
	
	elif animated_sprite.animation == "cerrar_ojos":
		print("Animación cerrar_ojos terminó → durmiendo")
		animated_sprite.play("durmiendo")
	
	elif animated_sprite.animation == "abrir_ojos":
		print("Animación abrir_ojos terminó → acostado")
		animated_sprite.play("acostado")
		emit_signal("termino_de_despertar")

func mostrar_mensaje(texto):
	mensaje.text = texto
	mensaje.show()
	mensaje_tiempo = 2.0

func actualizar_espuma(nivel):
	match nivel:
		0: animated_sprite_espuma.play("sin_espuma")
		1: animated_sprite_espuma.play("espuma_1")
		2: animated_sprite_espuma.play("espuma_2")
		3: animated_sprite_espuma.play("espuma_3")
		4: animated_sprite_espuma.play("espuma_4")

func acostarse():
	animated_sprite.play("acostarse")

func dormirse():
	animated_sprite.play("cerrar_ojos")

func despertar():
	animated_sprite.play("abrir_ojos")

func salir_de_la_cama():
	puede_arrastrarse = true
	animated_sprite.play("idle")
