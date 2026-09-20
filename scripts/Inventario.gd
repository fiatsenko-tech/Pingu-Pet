extends Node

const RUTA_GUARDADO = "user://save_data.json"

var food = {
	"pescado": 5,
	"dona": 5,
	"pizza": 0,
	"sushi": 0,
	"torta": 0,
	"completo": 0
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
			
		if datos["food"].has("dona"):
			food["dona"] = int(datos["food"]["dona"])
	
		if datos["food"].has("pizza"):
			food["pizza"] = int(datos["food"]["pizza"])
	
		if datos["food"].has("sushi"):
			food["sushi"] = int(datos["food"]["sushi"])
	
		if datos["food"].has("torta"):
			food["torta"] = int(datos["food"]["torta"])
	
		if datos["food"].has("completo"):
			food["completo"] = int(datos["food"]["completo"])
