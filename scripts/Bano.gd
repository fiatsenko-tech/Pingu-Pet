extends Control

var enjabonado = false
var aporte_jabon = 0

onready var jabon = $Jabon
onready var pingu = get_tree().get_root().find_node("Pingu", true, false)

func _ready():
	jabon.area.connect("area_entered", self, "_on_jabon_area_entered")

func _on_jabon_area_entered(area_entrante):
	if area_entrante.name == "AreaBano":
		if enjabonado: 
			return
		
		var higiene_actual = Necesidades.higiene
		var puntos_faltantes = 100 - higiene_actual
		
		aporte_jabon = int(puntos_faltantes / 2.0)
		
		Necesidades.higiene = clamp(
			higiene_actual + aporte_jabon,
			0,
			100
		)
		enjabonado = true
		
		print("Jabon aplicado")
		print("higiene antes: ", higiene_actual)
		print("aporte jabon:", aporte_jabon)
		print("higiene despues", Necesidades.higiene)
		print("enjabonado", enjabonado)
