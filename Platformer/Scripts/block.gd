extends KinematicBody2D

var time = 0

var speed = Vector2()

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	time += delta
	speed.y = 128*cos(2*PI*time/float(2)*2)
	
	position += speed*delta
	#move_and_slide(speed)
	#position.y += speed.y*delta
	pass
