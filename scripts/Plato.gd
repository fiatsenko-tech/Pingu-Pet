extends Node2D

var alimentos_en_plato = {}
var alimento_actual = ""
var indice_actual = 0

var arrastrando = false
var offset_arrastre = Vector2()
var posicion_original = Vector2()

var pingu = null
var area_comida_pingu = null
var collision_area_pingu = null

func configurar_pingu(pingu_referencia):
	pingu = pingu_referencia
	area_comida_pingu = pingu.get_node("AreaComida")
	collision_area_pingu = area_comida_pingu.get_node("CollisionShape2D")


var texturas_alimentos = {
	"pescado": preload("res://assets/Comidas/ChatGPT Image 12 sept 2026, 10_59_41 p.m..png"),
	"completo": preload("res://assets/Comidas/completo.jpeg"),
	"dona": preload("res://assets/Comidas/Dona.jpeg"),
	"pizza": preload("res://assets/Comidas/pizza.jpeg"),
	"torta": preload("res://assets/Comidas/RedVelvet.jpeg"),
	"sushi": preload("res://assets/Comidas/RedVelvet.jpeg"),
}


onready var imagen_alimento = $TextureButtonAlimento
onready var label = $Label
onready var boton_izquierdo = $BotonIzquierda
onready var boton_derecho = $BotonDerecha


func _ready():
	imagen_alimento.hide()
	label.hide()
	boton_derecho.hide()
	boton_izquierdo.hide()

	boton_derecho.connect("pressed", self, "_on_BotonDerecha_pressed")
	boton_izquierdo.connect("pressed", self, "_on_BotonIzquierda_pressed")
	imagen_alimento.connect("gui_input", self, "_on_ImagenAlimento_gui_input")


func agregar_alimento(nombre_alimento):
	if not texturas_alimentos.has(nombre_alimento):
		print("ERROR: No existe la textura de: ", nombre_alimento)
		return

	if not alimentos_en_plato.has(nombre_alimento):
		alimentos_en_plato[nombre_alimento] = 0

	alimentos_en_plato[nombre_alimento] += 1

	if alimento_actual == "":
		alimento_actual = nombre_alimento
		indice_actual = 0

	actualizar_visual()


func actualizar_visual():
	if alimento_actual == "":
		imagen_alimento.hide()
		label.hide()
		actualizar_botones()
		return

	if not alimentos_en_plato.has(alimento_actual):
		return

	if alimentos_en_plato[alimento_actual] <= 0:
		imagen_alimento.hide()
		label.hide()
		actualizar_botones()
		return

	imagen_alimento.texture_normal = texturas_alimentos[alimento_actual]

	imagen_alimento.expand = true
	imagen_alimento.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	imagen_alimento.rect_size = Vector2(200, 200)
	imagen_alimento.rect_scale = Vector2(1, 1)

	label.text = "x " + str(alimentos_en_plato[alimento_actual])

	imagen_alimento.show()
	label.show()

	actualizar_botones()


func actualizar_botones():
	if alimentos_en_plato.size() > 1:
		boton_izquierdo.show()
		boton_derecho.show()
	else:
		boton_izquierdo.hide()
		boton_derecho.hide()


func _on_BotonIzquierda_pressed():
	if alimentos_en_plato.size() <= 1:
		return

	var alimentos = alimentos_en_plato.keys()

	indice_actual -= 1

	if indice_actual < 0:
		indice_actual = alimentos.size() - 1

	alimento_actual = alimentos[indice_actual]

	actualizar_visual()


func _on_BotonDerecha_pressed():
	if alimentos_en_plato.size() <= 1:
		return

	var alimentos = alimentos_en_plato.keys()

	indice_actual += 1

	if indice_actual >= alimentos.size():
		indice_actual = 0

	alimento_actual = alimentos[indice_actual]

	actualizar_visual()


func _on_ImagenAlimento_gui_input(event):
	if event is InputEventMouseButton:

		if event.button_index == BUTTON_LEFT:

			if event.pressed:
				arrastrando = true

				posicion_original = imagen_alimento.rect_global_position
				offset_arrastre = imagen_alimento.rect_global_position - event.global_position

			else:
				arrastrando = false

				print("comida soltada")

				if comida_dentro_de_pingu():
					print("¡COMIDA DENTRO DEL AREA DE PINGU!")

					comer_alimento()
				else:
					print("comida fuera del AreaComida")

				imagen_alimento.rect_global_position = posicion_original


func _process(delta):
	if arrastrando:
		imagen_alimento.rect_global_position = get_global_mouse_position() + offset_arrastre


func comida_dentro_de_pingu():
	if collision_area_pingu == null:
		return false

	var rect_global = imagen_alimento.get_global_rect()
	var centro_comida = rect_global.position + rect_global.size / 2
	var posicion_pingu = collision_area_pingu.global_position

	var distancia = centro_comida.distance_to(posicion_pingu)

	print("CENTRO COMIDA REAL: ", centro_comida)
	print("AREA PINGU: ", posicion_pingu)
	print("DISTANCIA: ", distancia)

	return distancia < 150


func comer_alimento():
	if Necesidades.hambre >= 100:
		print("Pingu está lleno")
		pingu.mostrar_mensaje("Estoy lleno u.u")
		return

	pingu.animated_sprite.stop()
	pingu.animated_sprite.frame = 0
	pingu.animated_sprite.play("comer")

	alimentos_en_plato[alimento_actual] -= 1

	Necesidades.modificar_hambre(17)

	print("Pingu comió ", alimento_actual)
	print("Hambre actual: ", Necesidades.hambre)

	if alimentos_en_plato[alimento_actual] <= 0:
		alimentos_en_plato.erase(alimento_actual)

		if alimentos_en_plato.size() > 0:
			var alimentos = alimentos_en_plato.keys()
			indice_actual = 0
			alimento_actual = alimentos[0]
		else:
			alimento_actual = ""
			indice_actual = 0

	actualizar_visual()
