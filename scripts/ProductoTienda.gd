extends Control

var nombre_producto = ""
var precio_producto = 0
var id_producto = ""

onready var label_nombre = $Nombre
onready var label_precio = $Precio
onready var boton_comprar = $BotonComprar

func configurar_producto(nombre, precio, id):
	nombre_producto = nombre
	precio_producto = precio
	id_producto = id
	
	label_nombre.text = nombre_producto
	label_precio.text = str(precio_producto)

func _ready():
	boton_comprar.connect("pressed", self, "_on_BotonComprar_pressed")

func _on_BotonComprar_pressed():
	if Dinero.puede_pagar(precio_producto):
		Dinero.restar_monedas(precio_producto)
		print("Compra realizada: ", nombre_producto)
	else:
		print("no tienes suficiente plata")
