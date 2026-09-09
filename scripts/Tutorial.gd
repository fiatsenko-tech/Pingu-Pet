extends Control

const RUTA_GUARDADO = "user://save_data.json"

onready var texto_tutorial = $TextoTutorial
onready var boton_ok = $BotonOK


func _ready():
	boton_ok.connect("pressed", self, "_on_BotonOK_pressed")

	texto_tutorial.text = "Este juego lo hice para ti.\n\n" \
		+ "Es básicamente como jugar Pou, pero con Pingu. 🐧\n\n" \
		+ "Espero que te guste <3"


func _on_BotonOK_pressed():
	marcar_tutorial_completado()

	get_tree().change_scene("res://tscn/Juego.tscn")

func marcar_tutorial_completado():
	var archivo = File.new()

	if archivo.open(RUTA_GUARDADO, File.READ) != OK:
		print("No se pudo abrir la partida.")
		return

	var datos = parse_json(archivo.get_as_text())
	archivo.close()

	if datos == null:
		print("La partida está corrupta.")
		return

	datos["tutorial_completed"] = true

	if archivo.open(RUTA_GUARDADO, File.WRITE) != OK:
		print("No se pudo guardar la partida.")
		return

	archivo.store_string(to_json(datos))
	archivo.close()

	print("Tutorial completado.")
