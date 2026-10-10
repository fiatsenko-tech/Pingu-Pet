extends Control

var monedas_ganadas = 0

const TIEMPO_RECOMPENSA = 60
var tiempo_reclamo = 0

onready var titulo = $Panel/Titulo
onready var horas = $Panel/SpinBoxHoras
onready var boton_accept = $Panel/BotonAccept
onready var label_recompensa = $Panel/LabelRecompensa
onready var boton_claim = $Panel/BotonClaim
onready var label_tiempo = $Panel/LabelTiempo
onready var boton_cerrar = $Panel/BotonCerrar

func _ready():
	horas.min_value = 1
	horas.max_value = 8
	horas.step = 1
	horas.value = 1

	label_recompensa.hide()
	boton_claim.hide()
	label_tiempo.hide()

	boton_accept.connect("pressed", self, "_on_BotonAccept_pressed")
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_claim.connect("pressed", self, "_on_BotonClaim_pressed")
	
	cargar_estado()
	actualizar_estado()

func _process(delta):
	actualizar_estado()

func _on_BotonAccept_pressed():
	var horas_estudiadas = int(horas.value)
	monedas_ganadas = horas_estudiadas * 250

	titulo.hide()
	horas.hide()
	boton_accept.hide()

	label_recompensa.text = "¡Has ganado \n\n" \
							+ str(monedas_ganadas) \
							+ " monedas!"
	label_recompensa.show()
	boton_claim.show()

func _on_BotonCerrar_pressed():
	queue_free()

func _on_BotonClaim_pressed():
	Dinero.sumar_monedas(monedas_ganadas)
	
	tiempo_reclamo = OS.get_unix_time()
	
	guardar_estado()
	actualizar_estado()

func guardar_estado():
	var datos = {}

	var archivo = File.new()

	if archivo.file_exists("user://save_data.json"):
		archivo.open("user://save_data.json", File.READ)
		datos = parse_json(archivo.get_as_text())
		archivo.close()

	if not datos.has("recompensa_estudio"):
		datos["recompensa_estudio"] = {}

	datos["recompensa_estudio"]["tiempo_reclamo"] = tiempo_reclamo

	archivo.open("user://save_data.json", File.WRITE)
	archivo.store_string(to_json(datos))
	archivo.close()

func actualizar_estado():
	if tiempo_reclamo == 0:
		return

	var tiempo_actual = OS.get_unix_time()
	var tiempo_pasado = tiempo_actual - tiempo_reclamo
	var tiempo_restante = int(TIEMPO_RECOMPENSA - tiempo_pasado)

	if tiempo_restante <= 0:
		tiempo_reclamo = 0

		titulo.show()
		horas.show()
		boton_accept.show()

		label_recompensa.hide()
		boton_claim.hide()
		label_tiempo.hide()

		return

	var horas_restantes = int(tiempo_restante / 3600)
	var minutos_restantes = int((tiempo_restante % 3600) / 60)

	label_tiempo.text = "Vuelve dentro de: \n\n" + str(horas_restantes) + " horas, " + str(minutos_restantes) + " minutos"
	label_tiempo.show()

	horas.hide()
	boton_accept.hide()
	label_recompensa.hide()
	boton_claim.hide()
	
func cargar_estado():
	var archivo = File.new()

	if not archivo.file_exists("user://save_data.json"):
		return

	archivo.open("user://save_data.json", File.READ)

	var datos = parse_json(archivo.get_as_text())

	archivo.close()

	if datos.has("recompensa_estudio"):
		if datos["recompensa_estudio"].has("tiempo_reclamo"):
			tiempo_reclamo = datos["recompensa_estudio"]["tiempo_reclamo"]
