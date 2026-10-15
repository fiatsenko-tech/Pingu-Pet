extends Control

var monedas_ganadas = 0

const TIEMPO_RECOMPENSA = 60
var tiempo_reclamo = 0

onready var titulo = $Panel/Titulo
onready var boton_accept = $Panel/BotonAccept
onready var label_recompensa = $Panel/LabelRecompensa
onready var boton_claim = $Panel/BotonClaim
onready var label_tiempo = $Panel/LabelTiempo
onready var boton_cerrar = $Panel/BotonCerrar

onready var label_horas = $Panel/LabelHoras
onready var boton_disminuir = $Panel/BotonDisminuir
onready var boton_aumentar = $Panel/BotonAumentar
onready var espacio_label = $Panel/Espacio

onready var cadenas = $Panel/Cadenas
onready var reloj = $Panel/Reloj
onready var tiempo_espera = $Panel/TiempoRestante

var horas_estudiadas = 1

func _ready():
	label_horas.text = str(horas_estudiadas)

	boton_disminuir.connect("pressed", self, "_on_BotonDisminuir_pressed")
	boton_aumentar.connect("pressed", self, "_on_BotonAumentar_pressed")

	label_recompensa.hide()
	boton_claim.hide()
	label_tiempo.hide()
	
	cadenas.hide()
	reloj.hide()
	reloj.stop()
	tiempo_espera.hide()

	boton_accept.connect("pressed", self, "_on_BotonAccept_pressed")
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_claim.connect("pressed", self, "_on_BotonClaim_pressed")

	cargar_estado()
	actualizar_estado()

func _process(delta):
	actualizar_estado()

func _on_BotonDisminuir_pressed():
	if horas_estudiadas > 1:
		horas_estudiadas -= 1
		actualizar_label_horas()

func _on_BotonAumentar_pressed():
	if horas_estudiadas < 8:
		horas_estudiadas += 1
		actualizar_label_horas()

func actualizar_label_horas():
	label_horas.text = str(horas_estudiadas)

func _on_BotonAccept_pressed():
	monedas_ganadas = horas_estudiadas * 250

	label_horas.hide()
	boton_disminuir.hide()
	boton_aumentar.hide()
	boton_accept.hide()
	espacio_label.hide()

	label_recompensa.text = "¡Has ganado \n" + str(monedas_ganadas) + " monedas!"
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
		cadenas.hide()
		reloj.hide()
		reloj.stop()
		return

	var tiempo_actual = OS.get_unix_time()
	var tiempo_pasado = tiempo_actual - tiempo_reclamo
	var tiempo_restante = int(TIEMPO_RECOMPENSA - tiempo_pasado)

	if tiempo_restante <= 0:
		tiempo_reclamo = 0

		titulo.show()
		label_horas.show()
		boton_disminuir.show()
		boton_aumentar.show()
		boton_accept.show()
		espacio_label.show()
		
		boton_disminuir.disabled = false
		boton_aumentar.disabled = false
		boton_accept.disabled = false
		
		label_recompensa.hide()
		boton_claim.hide()
		label_tiempo.hide()
		
		cadenas.hide()
		reloj.hide()
		reloj.stop()
		tiempo_espera.hide()

		return

	var horas_restantes = int(tiempo_restante / 3600)
	var minutos_restantes = int((tiempo_restante % 3600) / 60)

	
	label_tiempo.show()

	titulo.show()
	label_horas.show()
	boton_disminuir.show()
	boton_aumentar.show()
	boton_accept.show()
	espacio_label.show()
	
	boton_aumentar.disabled = true
	boton_disminuir.disabled = true
	boton_accept.disabled = true
	
	label_recompensa.hide()
	boton_claim.hide()
	
	cadenas.show()
	reloj.show()
	tiempo_espera.show()
	
	if not reloj.is_playing():
		reloj.play()
		
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
