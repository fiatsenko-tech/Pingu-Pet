extends Node

signal monedas_cambiaron

var monedas = 250

func sumar_monedas(cantidad):
	if cantidad <= 0:
		return
	
	monedas += cantidad
	print("Monedas: ", monedas)
	emit_signal("monedas_cambiaron")

func restar_monedas(cantidad):
	if cantidad <= 0:
		return
	
	if cantidad > monedas:
		print("No hay suficientes monedas.")
		return
	
	monedas -= cantidad
	print("Monedas: ", monedas)
	print("EMITIENDO SEÑAL")
	emit_signal("monedas_cambiaron")

func puede_pagar(cantidad):
	return monedas >= cantidad
