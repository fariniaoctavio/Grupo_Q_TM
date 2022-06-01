extends CenterContainer

var grilla
var SIGUIENTE

const CELDA_FONDO1=Color(1,1,1)
const CELDA_FONDO2=Color(5,5,48)
signal button_pressed(nombre_boton)
func _ready():
#busca el nodo correspondiente
	grilla = find_node("Grilla")
	SIGUIENTE=find_node("SiguienteForma")
	add_cells(grilla,200)
	clear_cells(grilla,CELDA_FONDO1)
	clear_cells(SIGUIENTE,CELDA_FONDO2)
func add_cells(node,n):
	var numero_de_celdas=node.get_child_count()
	#Mientras que el numero de celdas sea menor que n (numero de celdas de la escena)
	#Se agregan nuevas celdas, es decir hasta 200
	while numero_de_celdas < n:
		node.add_child(node.get_child(0).duplicate())
		numero_de_celdas+=1
#esta funcion le da el color a las celdas
func clear_cells(node,color):
	for cell in node.get_children():
		cell.modulate=color
		


func _on_Salir_button_down():
	$Salida.popup_centered()
	emit_signal("button_pressed","Salir")
	
func _on_Nuevo_Juego_button_down():
	emit_signal("button_pressed","Nuevo Juego")
func _on_Pausa_button_down():
	emit_signal("button_pressed","Pausa")
func _on_ApagarEncenderMusica_button_down():
	emit_signal("button_pressed","ApagarEncenderMusica")

#Con esto el c
func _on_Salida_confirmed():
	get_tree().quit()
