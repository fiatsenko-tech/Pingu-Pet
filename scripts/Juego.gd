extends Control

var habitacion_actual = 2

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
onready var boton_comida = $UI/BotonComida
onready var boton_dormir = $UI/BotonDormir
onready var boton_higiene = $UI/BotonHigiene
onready var boton_diversion = $UI/BotonDiversion


func _ready():
	boton_izquierdo.connect("pressed", self, "_on_BotonIzquierdo_pressed")
	boton_derecho.connect("pressed", self, "_on_BotonDerecho_pressed")
	boton_comida.connect("pressed", self, "_on_BotonComida_pressed")
	boton_dormir.connect("pressed", self, "_on_BotonDormir_pressed")
	boton_higiene.connect("pressed", self, "_on_BotonHigiene_pressed")
	boton_diversion.connect("pressed", self, "_on_BotonDiversion_pressed")
	
	cargar_habitacion()

	pingu.quedarse_en_centro()

	print("Hambre: ", Necesidades.hambre)
	print("Higiene: ", Necesidades.higiene)
	print("Energía: ", Necesidades.energia)
	print("Diversión: ", Necesidades.diversion)


func cargar_habitacion():
	for hijo in contenedor.get_children():
		hijo.queue_free()

	var escena = load(habitaciones[habitacion_actual])
	var habitacion = escena.instance()

	contenedor.add_child(habitacion)

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

func _on_BotonComida_pressed():
	Necesidades.modificar_hambre(20)

	print("Hambre después de comer: ", Necesidades.hambre)

func _on_BotonDormir_pressed():
	Necesidades.modificar_energia(20)

	print("Energía despues de dormir: ", Necesidades.energia)

func _on_BotonHigiene_pressed():
	Necesidades.modificar_higiene(20)

	print("Limpieza luego del baño: ", Necesidades.higiene)

func _on_BotonDiversion_pressed():
	Necesidades.modificar_diversion(20)

	print("Diversion luego de divertirse: ", Necesidades.diversion)
