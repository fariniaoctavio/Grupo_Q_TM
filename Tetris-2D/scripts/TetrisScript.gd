extends CenterContainer

enum { DETENIDO, INICIADO, PAUSADO, DETENER, INICIAR, PAUSAR}
enum {Der, Izq}

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
	
#Funcion para mover las formas
func mover_formas(new_pos, dir= null):
	elim_forma_de_grilla()
	dir = rotar(dir)
	var ok = lugar_forma(new_pos)
	if ok:
		posicion = new_pos
	else:
		rotar(dir)
	agregar_forma_grilla()
	return ok

#Rotal las formas
func rotar(dir):
	match dir:
		Izq:
			forma.rotatel_left()
			dir = Der
		Der:
			forma.rotate_right()
			dir= Izq
	return dir

func agregar_forma_grilla():
	lugar_forma(posicion, true, false,forma.color)
	
#Funcion para eliminar formas de la cuadricula
func elim_forma_de_grilla():
	lugar_forma(posicion,true)
#Bloquear las formas en su posicion
func bloc_forma_en_grilla():
	lugar_forma(posicion, false, true)
	
func lugar_forma(indice, agregar_color= false, bloqueo= false,color= Color(0)):
	var ok = true
	var tamanio = forma.coordenadas.size(0)
	var despl = forma.coordenadas[0]
	var y =0
	while y < tamanio and  ok:
		for x in tamanio:
			if forma.grilla[y][x]:
				var grilla_pos = indice + (y + despl) * cantColumnas + x + despl
				print(grilla_pos)
				if bloqueo: 
					grilla[grilla_pos]= true
				elif grilla_pos >= 0:
					var gx= indice % cantColumnas + x + despl
					if gx < 0 or gx>= cantColumnas or grilla_pos >= grilla.size() or grilla[grilla_pos]:
						ok = !ok
						break
					if agregar_color:
						interfaz.grilla.get_child(grilla_pos).modulate = color
		y += 1
	return ok
					

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
