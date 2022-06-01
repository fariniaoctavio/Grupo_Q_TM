extends GridContainer

var formas=[]

func obtener_forma()->FormasScript:
	var f=FormasScript.new()
	return f

func _ready():
	for forma in get_children():
		var figura=FormasScript.new()
		figura.name=forma.name
		figura.color=forma.modulate
		
		var tamanio = forma.columns
		var f2= tamanio/2
		figura.coordenadas=range(-f2,f2+1)
