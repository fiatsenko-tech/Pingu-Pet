extends Control

onready var circulo_hambre = $Contenedor/IndicadorHambre/Circulo
onready var circulo_higiene = $Contenedor/IndicadorHigiene/Circulo
onready var circulo_energia = $Contenedor/IndicadorEnergia/Circulo
onready var circulo_diversion = $Contenedor/IndicadorDiversion/Circulo

onready var porcentaje_hambre = $Contenedor/IndicadorHambre/Porcentaje
onready var porcentaje_higiene = $Contenedor/IndicadorHigiene/Porcentaje
onready var porcentaje_energia = $Contenedor/IndicadorEnergia/Porcentaje
onready var porcentaje_diversion = $Contenedor/IndicadorDiversion/Porcentaje

func _process(delta):
	actualizar_indicadores()


func actualizar_indicadores():
	circulo_hambre.modulate = obtener_color(Necesidades.hambre)
	circulo_higiene.modulate = obtener_color(Necesidades.higiene)
	circulo_energia.modulate = obtener_color(Necesidades.energia)
	circulo_diversion.modulate = obtener_color(Necesidades.diversion)
	
	
	porcentaje_hambre.text = str(round(Necesidades.hambre)) + "%"
	porcentaje_higiene.text = str(round(Necesidades.higiene)) + "%"
	porcentaje_energia.text = str(round(Necesidades.energia)) + "%"
	porcentaje_diversion.text = str(round(Necesidades.diversion)) + "%"

func obtener_color(valor):
	if valor > 70:
		return Color(0.2, 0.8, 0.3)
	elif valor > 40:
		return Color(1.0, 0.85, 0.2)
	elif valor > 30:
		return Color(1.0, 0.55, 0.1)
	else:
		return Color(0.9, 0.15, 0.15)
