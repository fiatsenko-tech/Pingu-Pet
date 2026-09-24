extends Node

signal monedas_cambiaron

var monedas = 250

func sumar_monedas(cantidad):
	if cantidad <= 0:
		return
	
	monedas += cantidad
	emit_signal("monedas_cambiaron")

func restar_monedas(cantidad):
	if cantidad <= 0:
		return
	
	if cantidad > monedas:
		return
	
	monedas -= cantidad
	emit_signal("monedas_cambiaron")

func puede_pagar(cantidad):
	return monedas >= cantidad
