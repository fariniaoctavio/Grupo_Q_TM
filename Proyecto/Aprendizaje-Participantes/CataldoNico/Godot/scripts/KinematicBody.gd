extends KinematicBody
const speed = 6
var velocidad = Vector3(0,0,0)

func _ready():
	pass 

func _physics_process(delta):
	velocidad.y=0
	if Input.is_action_pressed("ui_right"):
		velocidad.x = speed
	elif Input.is_action_pressed("ui_left"):
		velocidad.x = -speed
	else:
		velocidad.x = 0
		
	if Input.is_action_pressed("ui_up"):
		velocidad.z= -speed
	elif Input.is_action_pressed("ui_down"):
		velocidad.z = speed
	else:
		velocidad.z = 0
	if Input.is_action_pressed("ui_accept"):
		velocidad.y= 2*-speed
	move_and_slide(velocidad)
