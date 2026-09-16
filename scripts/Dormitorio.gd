extends Control

var pingu_acostado = false
var pingu_durmiendo = false

func _ready():
	pass # Replace with function body.

func pingu_llego_a_la_cama():
	pingu_acostado = true
	print("Pingu está acostado: ", pingu_acostado)
