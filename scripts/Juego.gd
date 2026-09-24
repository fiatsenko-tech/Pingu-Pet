extends Control

var habitacion_actual = 2
var habitacion_actual_nodo = null
var pingu_llego_al_destino = false
var pingu_en_cama = false

var habitaciones = [
	"res://tscn/Comedor.tscn",
	"res://tscn/Bano.tscn",
	"res://tscn/Dormitorio.tscn",
	"res://tscn/Patio.tscn"
]

onready var contenedor = $HabitacionActual
onready var pingu = $Pingu
onready var boton_izquierdo = $UI/BotonIzquierdo
onready var boton_derecho = $UI/BotonDerecho
onready var label_monedas = $UI/LabelMonedas
onready var boton_tienda = $UI/BotonTienda

func _ready():
	boton_izquierdo.connect("pressed", self, "_on_BotonIzquierdo_pressed")
	boton_derecho.connect("pressed", self, "_on_BotonDerecho_pressed")
	boton_tienda.connect("pressed", self, "_on_BotonTienda_pressed")
	
	pingu.connect("llego_al_destino", self, "_on_Pingu_llego_al_destino")
	pingu.connect("termino_de_acostarse", self, "_on_Pingu_termino_de_acostarse")
	pingu.connect("termino_de_despertar", self, "_on_Pingu_termino_de_despertar")
	
	label_monedas.text = str(Dinero.monedas)
	
	actualizar_monedas()
	Dinero.connect("monedas_cambiaron", self, "_on_monedas_cambiaron")
	
	cargar_habitacion()
	pingu.global_position = pingu.posicion_destino

	print("Hambre: ", Necesidades.hambre)
	print("Higiene: ", Necesidades.higiene)
	print("Energía: ", Necesidades.energia)
	print("Diversión: ", Necesidades.diversion)
	print("monedas iniciales: ", Dinero.monedas)

func _on_monedas_cambiaron():
	actualizar_monedas()

func cargar_habitacion():
	for hijo in contenedor.get_children():
		hijo.queue_free()

	var escena = load(habitaciones[habitacion_actual])
	var habitacion = escena.instance()

	contenedor.add_child(habitacion)
	habitacion_actual_nodo = habitacion
	
	var posicion_pingu = habitacion.get_node("PosicionPingu")
	
	pingu.posicion_destino = posicion_pingu.global_position
	pingu_llego_al_destino = false

	if habitacion.has_node("Plato"):
		var plato = habitacion.get_node("Plato")
		plato.configurar_pingu(pingu)

	boton_izquierdo.raise()
	boton_derecho.raise()


func _on_BotonIzquierdo_pressed():
	if habitacion_actual > 0:
		habitacion_actual -= 1
		cargar_habitacion()
		pingu.entrar_desde_derecha()


func _on_BotonDerecho_pressed():
	if habitacion_actual < habitaciones.size() - 1:
		habitacion_actual += 1
		cargar_habitacion()
		pingu.entrar_desde_izquierda()

func _on_Pingu_llego_al_destino():
	if habitacion_actual == 2:
		habitacion_actual_nodo.pingu_llego_a_la_cama()

func _on_Pingu_termino_de_acostarse():
	if habitacion_actual == 2:
		habitacion_actual_nodo.pingu_termino_de_acostarse()

func _on_Pingu_termino_de_despertar():
	if habitacion_actual == 2:
		habitacion_actual_nodo.pingu_termino_de_despertar()

func actualizar_monedas():
	label_monedas.text = str(Dinero.monedas)

func _on_BotonTienda_pressed():
	var escena_tienda = load("res://tscn/Tienda.tscn")
	var tienda = escena_tienda.instance()
	add_child(tienda)
