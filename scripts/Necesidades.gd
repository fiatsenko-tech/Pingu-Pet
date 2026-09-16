extends Node

const RUTA_GUARDADO = "user://save_data.json"

var hambre = 50
var higiene = 100
var energia = 50
var diversion = 100

var pingu_durmiendo = false

func _ready():
	cargar_necesidades()

func modificar_hambre(cantidad):
	hambre = clamp(hambre + cantidad, 0, 100)

func modificar_higiene(cantidad):
	higiene = clamp(higiene + cantidad, 0, 100)

func modificar_energia(cantidad):
	energia = clamp(energia + cantidad, 0, 100)

func modificar_diversion(cantidad):
	diversion = clamp(diversion + cantidad, 0, 100)

func pasar_tiempo(segundos):
	var minutos = int(segundos / 60)

	if minutos > 0:
		modificar_hambre(-minutos)
		modificar_higiene(-minutos)
		modificar_diversion(-minutos)
		
		if pingu_durmiendo:
			modificar_energia(minutos)
			print("Energía después de dormir: ", energia)

func cargar_necesidades():
	var archivo = File.new()

	if not archivo.file_exists(RUTA_GUARDADO):
		return

	var error = archivo.open(RUTA_GUARDADO, File.READ)

	if error != OK:
		return

	var contenido = archivo.get_as_text()
	archivo.close()

	var datos = parse_json(contenido)

	if datos == null:
		return

	if not datos.has("needs"):
		return

	var necesidades = datos["needs"]

	if necesidades.has("hambre"):
		hambre = int(necesidades["hambre"])

	if necesidades.has("higiene"):
		higiene = int(necesidades["higiene"])

	if necesidades.has("energia"):
		energia = int(necesidades["energia"])

	if necesidades.has("diversion"):
		diversion = int(necesidades["diversion"])
