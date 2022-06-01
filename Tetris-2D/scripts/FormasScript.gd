extends Control

class_name FormasInformacion

var color: Color
var grilla: Array
var coordenadas: Array
var celdas:GridContainer

	#No se puede rotar un grid, pero como su padre 
	#es un objeto 2d entonces es posible rotarlo
func rotar_izq():
	celdas.get_parent().rotate(-PI/2)
	_rotar_grilla(1,-1)

func rotar_der():
	celdas.get_parent().rotate(PI/2)

func _rotar_grilla(sign_of_x,sing_of_y):
	var grilla_rotada=grilla.duplicate(true)
	for x in coordenadas:
		for y in coordenadas:
			#Trasformo x e y en indices de una matriz de rotacion
			var x1=coordenadas.find(x)
			var y1=coordenadas.find(y)
			var x2=coordenadas.find(sing_of_y*y)
			var y2=coordenadas.find(sign_of_x*x)
			grilla_rotada[y1][x1]=grilla[y2][x2]
	grilla=grilla_rotada
