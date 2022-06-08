extends GridContainer

var _formas=[]
var _indice=0

#Se mezcla el repertorio de piezas, y se toma una mediante un index,
#y cuando se acaban las piezas, se mezclan todas de nuevo, para ello
#usamos un index para ver cuantas piezas quedan. Arrancando desde el 
#indice mas alto al menor
func obtener_forma() -> FormasInfo:
	if _indice==0:
		_formas.shuffle()
		_indice=_formas.size()
	_indice-=1
	var f=FormasInfo.new()
	#una vez que se obtuvo una pieza, se copia las propiedades de esa 
	#y se las agrega al array con el que haremos las mezclas
	f.name=_formas[_indice].name
	f.color=_formas[_indice].color
	f.coordenadas=_formas[_indice].coordenadas
	f.grilla=_formas[_indice].grilla
	return f

func _ready():
	for forma in get_children():
		var figura=FormasInfo.new()
		figura.name = forma.name
		figura.color = forma.modulate
		
		var tamanio = forma.columns
		var f2= tamanio/2
		figura.coordenadas=range(-f2,f2+1)
		
		#Quitar la coordenada 0 para las grillas de cualquier tamaño
		if tamanio % 2 == 0:
			figura.coordenadas.remove(f2)
			#aplicamos la funcion para aplicar todas las propiedades de la figura
			#cada vez que esta es llamada se pretende obtener una figura distinta
			figura.grilla=_obtener_grilla(tamanio,figura.get_children())
			_formas.append(figura)

func _obtener_grilla(n,celdas):
	var grilla = []
	var fila = []
	var i = 0
	for cell in celdas:
		fila.append(cell.modulate.a > 0.1)
		#esto devuelve un valor T o F dependiendo si la celda esta llena o no
		i+=1
		if i==n:
			grilla.append(fila)
			i=0
			fila=[]
	return grilla
