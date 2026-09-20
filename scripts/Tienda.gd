extends Control

onready var boton_cerrar = $PanelTienda/BotonCerrar
onready var lista_productos = $PanelTienda/ScrollContainer/ListaProductos

var productos = [
	{"nombre": "Pescado", "precio": 10, "id": "pescado"},
	{"nombre": "Dona", "precio": 20, "id": "dona"},
	{"nombre": "Pizza", "precio": 25, "id": "pizza"},
	{"nombre": "Sushi", "precio": 40, "id": "sushi"},
	{"nombre": "Torta", "precio": 20, "id": "torta"},
	{"nombre": "Completo", "precio": 22, "id": "completo"}]

func _ready():
	boton_cerrar.connect("pressed", self, "_on_BotonCerrar_pressed")
	cargar_productos()

func cargar_productos():
	var escena_producto = load("res://tscn/ProductoTienda.tscn")
	
	for producto in productos:
		var nuevo_producto = escena_producto.instance()
		
		lista_productos.add_child(nuevo_producto)
		
		nuevo_producto.configurar_producto(
			producto["nombre"],
			producto["precio"],
			producto["id"])

func _on_BotonCerrar_pressed():
	queue_free()
