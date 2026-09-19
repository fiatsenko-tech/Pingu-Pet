extends Node

var monedas = 250

func sumar_monedas(cantidad):
	if cantidad <= 0:
		return
	
	monedas += cantidad
	print("Monedas: ", monedas)

func restar_monedas(cantidad):
	if cantidad <= 0:
		return false
	
	if cantidad > monedas:
		print("No hay suficientes monedas.")
		return false
	
	monedas -= cantidad
	print("Monedas: ", monedas)
	return true

func puede_pagar(cantidad):
	return monedas >= cantidad
