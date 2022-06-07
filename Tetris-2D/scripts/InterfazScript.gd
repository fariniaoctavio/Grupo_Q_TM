extends CenterContainer

var grilla
var SIGUIENTE
var Nivel = 1 setget nivel_del_juego
var Puntaje = 0 setget puntaje_juego
var Puntaje_mas_alto = 0 setget puntuacion_alta
var Lineas = 0 setget Cant_Lineas
#const CELDA_FONDO1=Color(1,1,1)
#const CELDA_FONDO2=Color(5,5,48)
signal button_pressed(nombre_boton)
#Funciones para conteo de puntos, lineas, puntuacion mas alta y nivel del juego
func nivel_del_juego(valor):
	find_node("Nivel").text =str(valor)
	Nivel = valor
	
func puntaje_juego(valor):
	find_node("Puntaje").text = str(valor)
	Puntaje = valor

func puntuacion_alta(valor):
	find_node("Puntaje Mas Alto").text = "%@8d" % valor
	Puntaje_mas_alto = valor

func Cant_Lineas(valor):
	find_node("Lineas").text =str(valor)
	Lineas = valor

#Resetear las estadisticas

func reset_estad(_puntaje_Alto=0, _puntos=0, _lineas=0, _nivel=1):
	self.Puntaje_mas_alto = _puntaje_Alto
	self.puntaje_juego = _puntos
	self.lineas = _lineas
	self.nivel_del_juego = _nivel

func opciones(datos):
	self.Puntaje_mas_alto = datos.Puntaje_mas_alto
	
func _ready():
#busca el nodo correspondiente
	grilla = find_node("Grilla")
	SIGUIENTE=find_node("SiguienteForma")
	agregar_celdas(grilla,200)
	limpiar_celdas(grilla)
	limpiar_celdas(SIGUIENTE)

func sig_forma(forma: FormasInfo):
	limpiar_celdas(SIGUIENTE)
	var i = 0 
	for col  in FormasInfo.coordenadas.size():
		for filas in [0,1]:
			if FormasInfo.grilla[filas][col]:
				SIGUIENTE.get_child(i).modulate = FormasInfo.color
				i += 1


func agregar_celdas(node,n):
	var numero_de_celdas=node.get_child_count()
	#Mientras que el numero de celdas sea menor que n (numero de celdas de la escena)
	#Se agregan nuevas celdas, es decir hasta 200
	while numero_de_celdas < n:
		node.add_child(node.get_child(0).duplicate())
		numero_de_celdas+=1

#esta funcion le da el color a las celdas
func limpiar_celdas(node):
	for cell in node.get_children():
		cell.modulate= Color(0)

func limpiar_todas_las_celdas():
	grilla = find_node("Grilla")
	SIGUIENTE=find_node("SiguienteForma")
	limpiar_celdas(grilla)
	limpiar_celdas(SIGUIENTE)

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
