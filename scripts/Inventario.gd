extends Node

const RUTA_GUARDADO = "user://save_data.json"

var food = {
	"pescado": 5,
	"dona": 5
}


func _ready():
	cargar_inventario()


func cargar_inventario():
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

	if datos.has("food"):
		if datos["food"].has("pescado"):
			food["pescado"] = int(datos["food"]["pescado"])
