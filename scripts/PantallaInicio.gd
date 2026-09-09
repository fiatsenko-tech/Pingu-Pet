extends Control

const RUTA_GUARDADO = "user://save_data.json"

onready var campo_nombre = $CampoNombre
onready var boton_comenzar = $BotonComenzar
onready var panel_mensaje = $PanelMensaje
onready var texto_mensaje = $PanelMensaje/TextoMensaje
onready var boton_entrar = $PanelMensaje/BotonEntrar
onready var titulo_inicio = $Titulo


func _ready():
	panel_mensaje.hide()

	boton_comenzar.connect("pressed", self, "_on_BotonComenzar_pressed")
	boton_entrar.connect("pressed", self, "_on_BotonEntrar_pressed")

	if existe_partida():
		var datos = cargar_datos()
		var nombre = datos["player"]["name"]

		titulo_inicio.hide()
		campo_nombre.hide()
		boton_comenzar.hide()

		if datos.has("tutorial_completed") and datos["tutorial_completed"] == true:
			get_tree().change_scene("res://tscn/Juego.tscn")
		else:
			mostrar_bienvenida(nombre, true)


func _on_BotonComenzar_pressed():
	var nombre = campo_nombre.text.strip_edges()

	if nombre == "":
		campo_nombre.placeholder_text = "Please enter your name!"
		return

	var datos = {
		"player": {
			"name": nombre
		},
		"tutorial_completed": false,
		"last_time": OS.get_unix_time(),
		"needs": {
			"hambre": 100,
			"higiene": 100,
			"energia": 100,
			"diversion": 100
		}
	}

	guardar_datos(datos)
	mostrar_bienvenida(nombre, false)


func _on_BotonEntrar_pressed():

	var datos = cargar_datos()

	if datos.has("tutorial_completed"):
		if datos["tutorial_completed"] == true:
			get_tree().change_scene("res://tscn/Juego.tscn")
		else:
			get_tree().change_scene("res://tscn/Tutorial.tscn")
	else:

		datos["tutorial_completed"] = false
		guardar_datos(datos)

		get_tree().change_scene("res://tscn/Tutorial.tscn")


func mostrar_bienvenida(nombre: String, ya_existia: bool):
	if ya_existia:
		texto_mensaje.text = "WelcomeS back, " + nombre + "!\n\nPingu missed you. 🐧"
	else:
		texto_mensaje.text = "Welcome, " + nombre + "!\n\n" \
			+ "I made this little world especially for you.\n\n" \
			+ "Take good care of Pingu!\n\n" \
			+ "Noot Noot! 🐧"

	panel_mensaje.show()


func guardar_datos(datos):
	var archivo = File.new()
	var error = archivo.open(RUTA_GUARDADO, File.WRITE)

	if error != OK:
		print("Error al abrir el archivo para guardar.")
		return

	archivo.store_string(to_json(datos))
	archivo.close()

	print("Partida guardada correctamente.")


func cargar_datos():
	var archivo = File.new()
	var error = archivo.open(RUTA_GUARDADO, File.READ)

	if error != OK:
		print("No se pudo cargar la partida.")
		return {}

	var contenido = archivo.get_as_text()
	archivo.close()

	var datos = parse_json(contenido)

	if datos == null:
		print("El archivo de guardado está vacío o corrupto.")
		return {}

	return datos


func existe_partida() -> bool:
	var archivo = File.new()
	return archivo.file_exists(RUTA_GUARDADO)
