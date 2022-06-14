extends CenterContainer

var grilla
var siguiente

var nivel = 1 setget Nivel_del_juego
var puntaje = 0 setget Puntaje_juego
var puntaje_mas_alto = 0 setget Puntuacion_alta
var lineas = 0 setget Cant_Lineas

signal button_pressed(nombre_boton)

#Funciones para conteo de puntos, lineas, puntuacion mas alta y nivel del juego
func Nivel_del_juego(valor):
	find_node("Nivel").text =str(valor)
	nivel = valor
	
func Puntaje_juego(valor):
	find_node("Puntaje").text = str(valor)
	puntaje = valor

func Puntuacion_alta(valor):
	find_node("PuntajeM").text = "%08d" % valor
	puntaje_mas_alto = valor

func Cant_Lineas(valor):
	find_node("Lineas").text = str(valor)
	lineas = valor

#Resetear las estadisticas
func reset_estad(_puntaje_Alto=0, _puntos=0, _lineas=0, _nivel=1):
	self.puntaje_mas_alto = _puntaje_Alto
	self.puntaje = _puntos
	self.lineas = _lineas
	self.nivel = _nivel

func opciones(datos):
	self.puntaje_mas_alto = datos.puntaje_mas_alto
	#find_node("Musica").value = datos.music TODO: Agregar nodo musica
	#find_node("Sonido").value = datos.sound TODO: Agregar nodo sonido

func _ready():
	grilla = find_node("Grilla")
	siguiente = find_node("SiguienteForma")
	#TODO: refactor sonido
	agregar_celdas(grilla,200)
	limpiar_todas_las_celdas()

func configurar_siguiente_figura(forma: FormasInfo):
	limpiar_celdas(siguiente)
	var index=0
	for columnas in forma.coordenadas.size():
		for fila in [0,1]:
			if forma.grilla[fila][columnas]:
				siguiente.get_child(index).modulate=forma.color
			index+=1

func agregar_celdas(nodo,n):
	var numero_de_celdas=nodo.get_child_count()
	#Mientras que el numero de celdas sea menor que n (numero de celdas de la escena)
	#Se agregan nuevas celdas, es decir hasta 200
	while numero_de_celdas < n:
		nodo.add_child(nodo.get_child(0).duplicate())
		numero_de_celdas+=1

func limpiar_todas_las_celdas():
	limpiar_celdas(grilla)
	limpiar_celdas(siguiente)

func limpiar_celdas(nodo):
	for celda in nodo.get_children():
		celda.modulate= Color(0)

func _on_Salir_button_down():
	$Salida.popup_centered()
	emit_signal("button_pressed","Salir")
	
func _on_Nuevo_Juego_button_down():
	emit_signal("button_pressed","Nuevo Juego")
func _on_Pausa_button_down():
	emit_signal("button_pressed","Pausa")
func _on_ApagarEncenderMusica_button_down():
	emit_signal("button_pressed","ApagarEncenderMusica")

func set_button_state(boton, estado):
	find_node(boton).set_disabled(estado)
func set_button_text(boton, texto):
	find_node(boton).set_text(texto)

func setear_estados_de_botones(reproduciendo):
	set_button_state("Nuevo Juego", reproduciendo)
	set_button_state("Pausa", !reproduciendo)

#Con esto el juego se cierra al confirmar en la ventana pop-up
func _on_Salida_confirmed():
	get_tree().quit()
func ponerle_texto_abtn(btn,texto):
	find_node(btn).set_text(texto)
func asignar_estado_abtn(btn,estado):
	find_node(btn).set_disabled(estado)

# TODO: agregar metodos control volumen musica y sonido
