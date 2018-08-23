extends KinematicBody2D

const SPEED = 200				# moving speed
const JUMP_SPEED = 150			# jumping speed
const GRAVITY = 350				# falling gravity

var vel = Vector2(0, 0) # Stores movement for one physics step

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	
	# Handle movement inputs
	if Input.is_action_pressed("move_left"):
		vel.x = -SPEED
	elif Input.is_action_pressed("move_right"):
		vel.x = SPEED
	else:
		vel.x = 0
	
	#Handle jumping
	if is_on_floor() && Input.is_action_pressed("jump"):
		vel.y = -GRAVITY*0.5
	
	#Handle falling, stop on the floor
	if(!is_on_floor()):
		vel.y += delta*GRAVITY
	elif(vel.y > 0):
		vel.y = 0
	
	#Perform the actual movement. Floor normal is into negative y direction.
	#No infinite inertia, stop on slopes.
	move_and_slide(vel, Vector2(0,-1), false, true)
	