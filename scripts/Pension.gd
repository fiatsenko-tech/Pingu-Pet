extends Node2D

const TIEMPO_PENSION = 3 * 24 * 60 * 60

onready var boton_cerrar = $PanelPension/TextureButton2
onready var boton_reclamar = $PanelPension/TextureButton
onready var label_tiempo = $PanelPension/LabelTiempo
onready var label_disponible = $PanelPension/LabelDisponible

func _ready():
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_reclamar.connect("pressed", self, "_on_BotonReclamar_pressed")
	
	actualizar_estado()

func _on_BotonReclamar_pressed():
	if not puede_reclamar():
		return
	
	Dinero.sumar_monedas(500)
	
	Tiempo.ultimo_claim = OS.get_unix_time()
	Tiempo.guardar_estado()
	
	actualizar_estado()

func puede_reclamar():
	if Tiempo.ultimo_claim == 0:
		return true
	
	var tiempo_actual = OS.get_unix_time()
	var tiempo_pasado = tiempo_actual - Tiempo.ultimo_claim
	
	return tiempo_pasado >= TIEMPO_PENSION

func _process(delta):
	actualizar_estado()

func actualizar_estado():
	if puede_reclamar():
		boton_reclamar.disabled = false
		label_tiempo.hide()
		label_disponible.show()
		return
	
	boton_reclamar.disabled = true
	label_tiempo.show()
	label_disponible.hide()
	
	var tiempo_actual = OS.get_unix_time()
	var tiempo_pasado = tiempo_actual - Tiempo.ultimo_claim
	var tiempo_restante = TIEMPO_PENSION - tiempo_pasado
	
	var dias = int(tiempo_restante / 86400)
	tiempo_restante = tiempo_restante % 86400
	
	var horas = int(tiempo_restante / 3600)
	tiempo_restante = tiempo_restante % 3600
	
	var minutos = int(tiempo_restante / 60)
	
	label_tiempo.text = str(dias) + " días, " + str(horas) + " horas, " + str(minutos) + " minutos"

func _on_BotonCerrar_pressed():
		queue_free()
