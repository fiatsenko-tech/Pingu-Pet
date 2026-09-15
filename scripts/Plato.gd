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

#andjkashfjawh me volveré locooo lolxdlmao

func _on_ImagenAlimento_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				arrastrando = true
				
				posicion_original = imagen_alimento.rect_global_position
				offset_arrastre = imagen_alimento.rect_global_position - event.global_position
				
				print("arrastrando: ", alimento_actual)
				print("POSICION EVENTO MOUSE: ", event.global_position)
				print("POSICION PINGU GLOBAL: ", pingu.global_position)
				print("POSICION PINGU CANVAS: ", pingu.get_global_transform_with_canvas().origin)
				print("POSICION AREA: ", collision_area_pingu.global_position)
				
				print("===== COORDENADAS COMIDA =====")
				print("Mouse event.global_position: ", event.global_position)
				print("Mouse get_global_mouse_position(): ", get_global_mouse_position())
				print("Imagen rect_position: ", imagen_alimento.rect_position)
				print("Imagen rect_global_position: ", imagen_alimento.rect_global_position)
				print("Imagen rect_size: ", imagen_alimento.rect_size)
				print("Imagen global_rect: ", imagen_alimento.get_global_rect())
				print("==============================")
				
			else:
				arrastrando = false
	
				print("comida soltada")
	
				if comida_dentro_de_pingu():
					print("¡COMIDA DENTRO DEL AREA DE PINGU!")
				else:
					print("comida fuera del AreaComida")
	
				imagen_alimento.rect_global_position = posicion_original

# warning-ignore:unused_argument
func _process(delta):
	if arrastrando:
		imagen_alimento.rect_global_position = get_global_mouse_position() + offset_arrastre
		print("MOUSE EN PROCESS: ", get_global_mouse_position())
		print("COMIDA RECT GLOBAL: ", imagen_alimento.rect_global_position)

func comida_dentro_de_pingu():
	if collision_area_pingu == null:
		return false
	
	var centro_local = imagen_alimento.rect_position + (imagen_alimento.rect_size / 2)
	var centro_comida = to_global(centro_local)
	
	print("CENTRO COMIDA: ", centro_comida)
	print("AREA PINGU: ", collision_area_pingu.global_position)
	
	return false
