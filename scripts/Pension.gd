extends Node2D

onready var boton_cerrar = $PanelPension/TextureButton2
onready var boton_reclamar = $PanelPension/TextureButton

func _ready():
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	boton_reclamar.connect("pressed", self, "_on_BotonReclamar_pressed")

func _on_BotonReclamar_pressed():
	Dinero.sumar_monedas(500)

func _on_BotonCerrar_pressed():
		queue_free()
