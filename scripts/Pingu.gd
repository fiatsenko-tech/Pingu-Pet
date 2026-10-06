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

var estado_visual_necesidad = ""

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

	area_arrastre.connect("area_entered", self, "_on_area_arrastre_area_entered")
	area_arrastre.connect("area_exited", self, "_on_area_arrastre_area_exited")
	
	animated_sprite.connect("animation_finished", self, "_on_animation_finished")
	
	Necesidades.connect("necesidades_cambiaron", self, "_on_necesidades_cambiaron")
	
	actualizar_estado_visual()
	animated_sprite_espuma.play("sin_espuma")
	
	

func _on_necesidades_cambiaron():
	actualizar_estado_visual()

func actualizar_estado_visual():
	if Necesidades.higiene < 30:
		estado_visual_necesidad = "Pingu Sucio"
	
	elif Necesidades.hambre < 30:
		estado_visual_necesidad = "Pingu Hambreado"
	
	elif Necesidades.energia < 30:
		estado_visual_necesidad = "Pingu Cansado"
	
	elif Necesidades.diversion < 30:
		estado_visual_necesidad = "Pingu Aburrido"
	
	else:
		estado_visual_necesidad = "idle"
	
	if animated_sprite.animation == "idle" or \
	   animated_sprite.animation == "Pingu Sucio" or \
	   animated_sprite.animation == "Pingu Hambreado" or \
	   animated_sprite.animation == "Pingu Cansado" or \
	   animated_sprite.animation == "Pingu Aburrido" or \
	   animated_sprite.animation == "siendo_arrastrado":
		
		animated_sprite.play(estado_visual_necesidad)

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
		actualizar_estado_visual()
	
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
		0:
			animated_sprite_espuma.play("sin_espuma")
			animated_sprite_espuma.hide()
		1:
			animated_sprite_espuma.play("espuma_1")
			animated_sprite_espuma.show()
		2:
			animated_sprite_espuma.play("espuma_2")
			animated_sprite_espuma.show()
		3:
			animated_sprite_espuma.play("espuma_3")
			animated_sprite_espuma.show()
		4:
			animated_sprite_espuma.play("espuma_4")
			animated_sprite_espuma.show()

func acostarse():
	animated_sprite.play("acostarse")

func dormirse():
	animated_sprite.play("cerrar_ojos")

func despertar():
	animated_sprite.play("abrir_ojos")

func salir_de_la_cama():
	puede_arrastrarse = true
	actualizar_estado_visual()

func ocultar_espuma():
	animated_sprite_espuma.hide()

func mostrar_espuma():
	if nivel_espuma > 0:
		animated_sprite_espuma.show()


func _on_TextureButtonArrastre_gui_input(event):
	if habitacion_actual != 2:
		return
	
	if not puede_arrastrarse:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				arrastrando = true
				animated_sprite.play("siendo_arrastrado")
				posicion_anterior = global_position
				offset_arrastre = global_position - get_global_mouse_position()
			else:
				arrastrando = false
				
				if sobre_cama:
					global_position = posicion_cama
					quedarse_en_cama()
				else:
					global_position = posicion_anterior
					actualizar_estado_visual()
