extends CenterContainer

enum { DETENIDO, INICIADO, PAUSADO, DETENER, INICIAR, PAUSAR}

var interfaz
var estado = DETENIDO
var posicion_cancion = 0
var cantColumnas

var forma = FormasInfo #contiene la forma actual que controlara el jugador
var grilla = [] #array que representa cada celda de la grilla
var posicion = 0 #posicion de la forma dentro de la grilla

func _ready():
	interfaz = $Interfaz
	interfaz.connect("button_pressed", self, "_button_pressed")
	limpiar_grilla()

func limpiar_grilla():
	grilla.clear()
	grilla.resize(interfaz.find_node("Grilla").get_child_count()) #obtenemos la cantidad de celdas de la grilla
	for i in grilla.size():
		grilla[i] = false #seteamos cada celda como "vacia"
	interfaz.limpiar_todas_las_celdas()

func _button_pressed(nombre_boton):
	match nombre_boton:
		"Nuevo Juego":
			print("JUEGO NUEVO TOCADO")
		"Pausa":
			print("PAUSA TOCADO")
		"Salir":
			print("SALIR TOCADO")
		"ApagarEncenderMusica":
			print("MUSICA TOCADO")
			if !_musica_is_on():
				_musica(INICIAR)
			else:
				_musica(PAUSAR)

func _musica(accion):
	if accion == INICIAR:
		$ReproductorMusica.volume_db = -18
		if !$ReproductorMusica.is_playing():
			$ReproductorMusica.play(posicion_cancion)
		print("Musica Iniciada")
	else:
		posicion_cancion = $ReproductorMusica.get_playback_position()
		$ReproductorMusica.volume_db = 0
		$ReproductorMusica.stop()
		print("Musica Pausada")

func _musica_is_on():
	return $ReproductorMusica.volume_db == -18
	
func posicionar_figura(indice, agregar_forma=false, poner=false, color=Color(0)):
	var correcto=true
	var tamanio=forma.coordenadas.size()
	var distanciaOrigen=forma.coordenadas[0]
	var y=0
	#usaremos valores de x e y para analizar la grilla y ver si podemos situar una figura
	
	while y < tamanio && correcto:
		for x in tamanio:
			#si se detecta una posicion invalida, se saldra de los bucles
			#y se devolvera un valor de falso
			if forma.grilla[y][x]:
				#esta variable se usa para establecer la posicion de la celda en la grilla donde queramos
				#poner o quitar una figura
				var posicion_en_grilla=indice+[y-distanciaOrigen]*cantColumnas+x+distanciaOrigen
				#si se quiere poner una figura se usara poner como ture
				if poner:
					grilla[posicion_en_grilla]=true
				elif posicion_en_grilla>=0:
					var posicion_columna=indice%cantColumnas+x+distanciaOrigen
					#comprobamos que la posicion a donde queremos poner la forma
					#este contenida dentro de la grilla, y no fuera de la misma
					if posicion_columna<0 or posicion_columna>=cantColumnas or posicion_en_grilla>=grilla.size() or grilla[posicion_en_grilla]:
						#si esa posicion esta ocupada o no existe se retorna el valor de correcto como falso y se usa break para salir del bucle
						correcto=!correcto
						break
						#en el caso de que todo salga bien y sea posible poner la figura, entonces se agrega la figura a la grilla
					if agregar_forma:
						interfaz.grilla.get_child(posicion_en_grilla).modulate=color
		y+=1
	return correcto
	
func agregar_figura_a_grilla():
	#true para posicionar la figura y false para que no se coloque automaticamente
	posicionar_figura(posicion,true,false,forma.color)
func quitar_figura_de_grilla():
	posicionar_figura(posicion,false,true)
	
