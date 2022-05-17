extends KinematicBody
const speed = 120
var velocidad = Vector3(0,0,0)
var speed2 = 6
var mov =0
func _ready():
	pass 

func _physics_process(delta):
	if(mov== 0):
		velocidad.y= -speed2
		if Input.is_action_just_pressed("ui_right"):
			velocidad.x = speed
		elif Input.is_action_just_pressed("ui_left"):
			velocidad.x = -speed
		else:
			velocidad.x = 0
		
		if Input.is_action_just_pressed("ui_up"):
			velocidad.z= -speed
		elif Input.is_action_just_pressed("ui_down"):
			velocidad.z = speed
		else:
			velocidad.z =0
		if Input.is_action_just_pressed("ui_accept"):
			rotate_z(deg2rad(90))
		move_and_slide(velocidad)



func _on_Area_body_entered(body):
	mov = 1
