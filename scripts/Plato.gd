extends Node2D

var alimentos_en_plato = {}
var alimento_actual = ""
var indice_actual = 0

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


func _on_BotonIzquierdo_pressed():
	if alimentos_en_plato.size() <= 1:
		return
	
	var alimentos = alimentos_en_plato.keys()
	
	indice_actual -= 1
	
	if indice_actual < 0:
		indice_actual = alimentos.size() - 1
	
	alimento_actual = alimentos[indice_actual]
	
	actualizar_visual()


func _on_BotonDerecho_pressed():
	if alimentos_en_plato.size() <= 1:
		return
	
	var alimentos = alimentos_en_plato.keys()
	
	indice_actual += 1
	
	if indice_actual >= alimentos.size():
		indice_actual = 0
	
	alimento_actual = alimentos[indice_actual]
	
	actualizar_visual()
