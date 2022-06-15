extends CenterContainer

## Explicacion estados
## DETENIDO -> Estado inicial del juego (en menu, todavia no inicia)
## INICIADO -> Cuando se toca nuevo juego, se esta jugando (fichas bajan, etc).
## PAUSADO -> Indicar que el juego esta en pausa (se toco boton pausa)
## INICIAR -> Se usa para iniciar la musica
## PAUSAR -> Se usa para pausar la musica
enum { DETENIDO, INICIADO, PAUSADO, INICIAR, PAUSAR}
enum { ROTAR_DERECHA, ROTAR_IZQUIERDA}



#Constantes de configuracion jugabilidad
const DESHABILITADO = true
const HABILITADO = false
const MAXIMO_NIVEL = 100
const POS_INICIAL = 5
const POS_FINAL =  25
const VELOCIDAD_DE_CAIDA = 1.0
const MULTIPLICADOR_DE_VEL = 10
const TIEMPO_DE_ESPERA = 0.15
const DELAY = 0.05

var interfaz
var estado = DETENIDO #se setea el estado inicial como detenido
var posicion_cancion = 0 
var grilla = [] #array que representa cada celda de la grilla
var cantColumnas

var forma : FormasInfo #contiene la forma actual que controlara el jugador
var siguiente_forma : FormasInfo
var posicion = 0 #posicion de la forma dentro de la grilla
var cuenta =0
var prima = 0

func _ready():
	interfaz = $Interfaz
	interfaz.connect("button_pressed", self, "_button_pressed")
	cantColumnas = interfaz.grilla.get_columns()
	interfaz.setear_estados_de_botones(HABILITADO) #TODO: refactor
	interfaz.reset_estad()
	
	randomize()

func iniciar_partida():
	print("A jugar...")
	estado = INICIADO
	posicion_cancion = 0.0
	if _musica_esta_encendido():
		_musica(INICIAR)
	limpiar_grilla()
	interfaz.reset_estad(interfaz.puntaje_mas_alto)
	nueva_forma()

func nueva_forma():
	if siguiente_forma:
		forma = siguiente_forma
	else:
		forma = Formas.obtener_forma()
	siguiente_forma = Formas.obtener_forma()
	interfaz.configurar_siguiente_figura(siguiente_forma)
	posicion = POS_INICIAL
	agregar_forma_grilla()
	bajada_normal()
	subir_nivel()

func limpiar_grilla():
	grilla.clear()
	grilla.resize(interfaz.grilla.get_child_count()) #obtenemos la cantidad de celdas de la grilla
	for i in grilla.size():
		grilla[i] = false #seteamos cada celda como "vacia"
	interfaz.limpiar_todas_las_celdas()
	
#Funcion para mover las formas
func mover_forma(nueva_posicion, dir= null):
	elim_forma_de_grilla()
	# Rota la forma
	dir = rotar(dir)
	# coloca la pieza si es posible, sino deshace la rotacion
	var ok = posicionar_figura(nueva_posicion)
	if ok:
		posicion = nueva_posicion
	else:
		rotar(dir)
	agregar_forma_grilla()
	return ok

#Rotar las formas
func rotar(dir):
	match dir:
		ROTAR_IZQUIERDA:
			forma.rotar_izq() #TODO: REFACTOR
			dir = ROTAR_DERECHA
		ROTAR_DERECHA:
			forma.rotar_der() #TODO: REFACTOR
			dir= ROTAR_IZQUIERDA
	return dir


func agregar_forma_grilla():
	posicionar_figura(posicion, true, false, forma.color)
	
#Funcion para eliminar formas de la cuadricula
func elim_forma_de_grilla():
	posicionar_figura(posicion,true)

#Bloquear las formas en su posicion
func bloc_forma_en_grilla():
	posicionar_figura(posicion, false, true)

#funcion para indicar donde poner o quitar una figura
func posicionar_figura(indice, agregar_forma=false, poner=false, color=Color(0)):
	var correcto=true
	var tamanio=forma.coordenadas.size()
	var distanciaOrigen=forma.coordenadas[0]
	var y=0
	#usaremos valores de x e y para analizar la grilla y ver si podemos situar una figura
	
	while y < tamanio and correcto:
		for x in tamanio:
			#si se detecta una posicion invalida, se saldra de los bucles
			#y se devolvera un valor de falso
			if forma.grilla[y][x]:
				#esta variable se usa para establecer la posicion de la celda en la grilla donde queramos
				#poner o quitar una figura
				var posicion_en_grilla = indice + (y+distanciaOrigen) * cantColumnas + x + distanciaOrigen
				#si se quiere poner una figura se usara poner como ture
				if poner:
					grilla[posicion_en_grilla]=true
				else:
					var posicion_columna = indice % cantColumnas + x + distanciaOrigen
					#comprobamos que la posicion a donde queremos poner la forma
					#este contenida dentro de la grilla, y no fuera de la misma
					if posicion_columna < 0 or posicion_columna >= cantColumnas or posicion_en_grilla >= grilla.size() or posicion_en_grilla >= 0 and grilla[posicion_en_grilla]:		   
						#si esa posicion esta ocupada o no existe se retorna el valor de correcto como falso y se usa break para salir del bucle
						correcto = !correcto
						break
						#en el caso de que todo salga bien y sea posible poner la figura, entonces se agrega la figura a la grilla
					if agregar_forma and posicion_en_grilla >= 0:
						interfaz.grilla.get_child(posicion_en_grilla).modulate=color
		y+=1
	return correcto

func _button_pressed(nombre_boton):
	match nombre_boton:
		"Nuevo Juego":
			print("JUEGO NUEVO TOCADO")
			interfaz.setear_estados_de_botones(DESHABILITADO)
			iniciar_partida()
			
		"Pausa":
			print("PAUSA TOCADO")
			if estado==INICIADO:
				interfaz.set_button_text("Pausa", "Continuar") #TODO: refactor
				estado = PAUSADO
				pausa()
				if _musica_esta_encendido():
					_musica(PAUSAR)
			else:
				interfaz.set_button_text("Pausa", "Pausa") #TODO: refactor
				estado=INICIADO
				pausa(false) #despauso el juego
				if _musica_esta_encendido():
					_musica(INICIAR)
				
		"Salir":
			print("SALIR TOCADO")
		
		"ApagarEncenderMusica":
			print("MUSICA TOCADO")
			if !_musica_esta_encendido():
				_musica(INICIAR)
			else:
				_musica(PAUSAR)

# configuracion para las teclas de input, asi poder mover la figura en el juego
func _input(accion):
	pass
	if estado == INICIADO:
		if accion.is_action_pressed("ui_page_up"):
			incrementar_nivel()
		if accion.is_action_released("ui_down"):
			prima = 0
			bajada_normal()
		if accion.is_action_pressed("ui_down"):
			prima = 2
			caida_suave()
		if accion.is_action_pressed("ui_accept"):
			caida_fuerte()
		if accion.is_action_pressed("ui_left"):
			mover_izq()
			$TickerIzquierdo.start(TIEMPO_DE_ESPERA)
		if accion.is_action_released("ui_left"):
			$TickerIzquierdo.stop()
		if accion.is_action_pressed("ui_right"):
			mover_der()
			$TickerDerecho.start(TIEMPO_DE_ESPERA)
		if accion.is_action_released("ui_right"):
			$TickerDerecho.stop()
		if accion.is_action_pressed("ui_up"):
			if accion.shift:
				mover_forma(posicion, ROTAR_DERECHA)
			else:
				mover_forma(posicion, ROTAR_IZQUIERDA)
		if accion.is_action_pressed("ui_cancel"):
			_terminar_partida()
		if accion is InputEventKey:
			get_tree().set_input_as_handled()

#Subir de nivel
func subir_nivel():
	cuenta += 1
	if cuenta % 10 ==0:
		incrementar_nivel()

func incrementar_nivel():
	if interfaz.nivel < MAXIMO_NIVEL:
		interfaz.nivel += 1
		$Timer.set_wait_time(VELOCIDAD_DE_CAIDA / interfaz.nivel)

#Funciones controles de musica
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
func _musica_esta_encendido():
	return $ReproductorMusica.volume_db == -18
	
#Actualizacion del puntaje a medida que se va jugando
func agregar_puntaje(filas):
	interfaz.lineas += filas
	var puntaje = 100 * int(pow(2, filas -1))
	interfaz.puntaje += puntaje
	actualiz_punt_alto()

#Actualizacion del puntaje mas alto en caso de que se supere
func actualiz_punt_alto():
	if interfaz.puntaje > interfaz.puntaje_mas_alto:
		interfaz.puntaje_mas_alto = interfaz.puntaje

#Velocidad de desplazamiento de la figura
func bajada_normal():
	$Timer.start(VELOCIDAD_DE_CAIDA / interfaz.nivel)

#Velocidades de caida
func caida_suave():
	$Timer.stop()
	$Timer.start(VELOCIDAD_DE_CAIDA / interfaz.nivel / MULTIPLICADOR_DE_VEL)
func caida_fuerte():
	$Timer.stop()
	$Timer.start(VELOCIDAD_DE_CAIDA / MAXIMO_NIVEL)
	
func _terminar_partida():
	print("SE ACABO EL JUEGO")

	$Timer.stop()
	$TickerIzquierdo.stop()
	$TickerDerecho.stop()
	interfaz.set_button_states(HABILITADO)
	if _musica_esta_encendido():
		_musica(PAUSAR)
	estado=DETENIDO

#funcion para determinar despues de que cantidad de ticks se suelta otra figura
func Tiempo():
	var nueva_pos = posicion + cantColumnas
	if mover_forma(nueva_pos):
		interfaz.puntaje += prima
		actualiz_punt_alto()
	else:
		if nueva_pos <= POS_FINAL:
			_terminar_partida()
		else:
			bloc_forma_en_grilla()
			chequear_filas()
			nueva_forma()

#chequear si las filas o columnas estan completas
func chequear_filas():
	var i = grilla.size() - 1
	var x = 0
	var nfilas = grilla.size() / cantColumnas-1
	var filas = []
	while i >= 0:
		if grilla[i]:
			x += 1
			i -= 1
			if x == cantColumnas:
				filas.append(nfilas)
				x=0
				nfilas-=1
		else:
			i += x
			x = 0 
			i-=cantColumnas
			nfilas-=1
	if filas.empty()==false:
		remover_filas(filas)

#funcion para remover filas
func remover_filas( filas):
	var filas_corridas=0
	agregar_puntaje(filas.size())
	pausa()

	#TODO: Refactor sonido

	yield(get_tree().create_timer(0,3), "timeout")
	pausa(false)
	elim_forma_de_grilla()
	for nfilas in filas.size():	
		for n in cantColumnas:
			interfaz.grilla.get_child((filas[nfilas]+filas_corridas)*cantColumnas+n).modulate=Color(0)
		var hacia=(filas[nfilas]+filas_corridas)*cantColumnas+cantColumnas-1
		var desde=hacia-cantColumnas
		while desde>=0:
			grilla[hacia]=grilla[desde]
			interfaz.grilla.get_child(hacia).modulate=interfaz.grilla.get_child(desde).modulate
			if desde == 0 :
				grilla[desde]=false
				interfaz.grilla.get_child(desde).modulate=Color(0)
			desde-=1
			hacia-=1
		filas_corridas+=1
	agregar_forma_grilla()

#Funciones movimiento figuras
func mover_izq():
	if posicion % cantColumnas < cantColumnas -1:
		mover_forma(posicion + 1)
func mover_der():
	if posicion % cantColumnas > 0:
		mover_forma(posicion - 1)

#predefinidas de godot
func _on_TickerIzquierdo_timeout():
	$TickerIzquierdo.wait_time = DELAY
	mover_izq()

func _on_TickerDerecho_timeout():
	$TickerDerecho.wait_time = DELAY
	mover_der()

func pausa(valor = true):
	get_tree().paused = valor
