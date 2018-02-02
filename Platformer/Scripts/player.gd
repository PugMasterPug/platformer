extends KinematicBody2D

var spd = 400
var acc = 10
var dec = 12

var jmpSpd = 400
var jmpTime = 0.5
var max_jumps = 2

const GRAVITY = 1100

var speed = Vector2()
var jumping = false
var jmpTemp = jmpTime
var jumps = max_jumps
var canJump = false

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			jumping = true
			canJump = false
		elif canJump and jumps >= 2:
			speed.y = -jmpSpd
			jumps -= 1
	if Input.is_action_pressed("ui_up"):
		if jumping:
			if jmpTemp > 0:
				speed.y = -jmpSpd*jmpTemp/float(jmpTime)
				jmpTemp -= delta
			elif !canJump:
				canJump = true
				jumping = false
	if Input.is_action_just_released("ui_up"):
		if jmpTemp > 0:
			if speed.y < -jmpSpd/2:
				speed.y = -jmpSpd/2
			jmpTemp = 0
			canJump = true
	
	var desiredSpd = 0
	if Input.is_action_pressed("ui_right"):
		desiredSpd = spd
	if Input.is_action_pressed("ui_left"):
		desiredSpd -= spd
	if desiredSpd == 0:
		speed.x += (desiredSpd - speed.x)*dec*delta
	else:
		speed.x += (desiredSpd - speed.x)*acc*delta
	
	speed.y += GRAVITY*delta
	
	#position += speed*delta
	
	speed = move_and_slide(speed, Vector2(0, -1))
	#speed += get_floor_velocity()
	
	for i in range(0, get_slide_count()):
		var collider = get_slide_collision(i)
		var normal = collider.normal
		
		if collider.collider.is_in_group("Moving"):
			speed.y = get_floor_velocity().y
			#speed += get_floor_velocity()
	
	if is_on_floor():
		jumps = max_jumps
		jmpTemp = jmpTime
		canJump = true
		jumping = false
	pass