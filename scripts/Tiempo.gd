extends Node

const RUTA_GUARDADO = "user://save_data.json"

var tiempo_anterior = 0
var segundos_acumulados = 0
var segundos_desde_guardado = 0

func _ready():
	tiempo_anterior = OS.get_unix_time()
	aplicar_tiempo_offline()

func _process(delta):
	actualizar()

	segundos_desde_guardado += delta

	if segundos_desde_guardado >= 10:
		guardar_estado()
		segundos_desde_guardado = 0


func actualizar():
	var tiempo_actual = OS.get_unix_time()
	var segundos_pasados = tiempo_actual - tiempo_anterior

	if segundos_pasados > 0:
		segundos_acumulados += segundos_pasados
		
		if segundos_acumulados >= 60:
			var minutos = int(segundos_acumulados / 60)
			Necesidades.pasar_tiempo(minutos * 60)
			segundos_acumulados = segundos_acumulados % 60
		tiempo_anterior = tiempo_actual

func aplicar_tiempo_offline():
	var datos = cargar_datos()

	if datos.empty():
		return

	if not datos.has("last_time"):
		return

	var tiempo_actual = OS.get_unix_time()
	var ultimo_tiempo = int(datos["last_time"])
	var segundos_pasados = tiempo_actual - ultimo_tiempo

	if segundos_pasados <= 0:
		return

	print("Tiempo fuera del juego: ", segundos_pasados, " segundos")

	Necesidades.pasar_tiempo(segundos_pasados)

	print("Necesidades después del tiempo offline:")
	print("Hambre: ", Necesidades.hambre)
	print("Higiene: ", Necesidades.higiene)
	print("Energía: ", Necesidades.energia)
	print("Diversión: ", Necesidades.diversion)

	guardar_estado()

func guardar_estado():
	var datos = cargar_datos()

	if datos.empty():
		return

	datos["last_time"] = OS.get_unix_time()

	datos["needs"] = {
		"hambre": Necesidades.hambre,
		"higiene": Necesidades.higiene,
		"energia": Necesidades.energia,
		"diversion": Necesidades.diversion,
		"pingu_durmiendo": Necesidades.pingu_durmiendo
	}
	datos ["food"] = {
		"pescado": Inventario.food["pescado"]
	}

	var archivo = File.new()
	var error = archivo.open(RUTA_GUARDADO, File.WRITE)

	if error != OK:
		print("Error al guardar el estado.")
		return

	archivo.store_string(to_json(datos))
	archivo.close()

	print("Estado guardado.")


func cargar_datos():
	var archivo = File.new()

	if not archivo.file_exists(RUTA_GUARDADO):
		return {}

	var error = archivo.open(RUTA_GUARDADO, File.READ)

	if error != OK:
		return {}

	var contenido = archivo.get_as_text()
	archivo.close()

	var datos = parse_json(contenido)

	if datos == null:
		return {}

	return datos

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		guardar_estado()
		get_tree().quit()
