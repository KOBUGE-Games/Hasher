extends KinematicBody2D

const SPEED = 300				# moving speed
const GRAVITY = 2000				# falling gravity
var vel = Vector2(0, 0) # Stores movement for one physics step


func _ready():
	set_physics_process(true)
	set_process_input(true)


func _physics_process(delta):
	
	# Handle movement inputs
	vel.x = 0
	if Input.is_action_pressed("move_left"):
		vel.x -= SPEED
	if Input.is_action_pressed("move_right"):
		vel.x += SPEED
	
	# Handle jumping
	if (is_on_floor() || $GroundRay.is_colliding()) && Input.is_action_pressed("jump"):
		vel.y = -GRAVITY*0.35
	
	# Handle falling, stop on the floor
	if(!is_on_floor() && !$GroundRay.is_colliding()):
		vel.y += delta*GRAVITY
	elif(vel.y > 0):
		vel.y = 0
	
	# Perform the actual movement. Floor normal is into negative y direction.
	# No infinite inertia, stop on slopes.
	move_and_slide(vel, Vector2(0,-1), false, false, 4)


func _input(event):
	if event.is_action_pressed("hack") and not get_node("hacking/hack_anim").is_playing():
		hack()


func hack():
	get_node("hacking/hack_anim").play("hack")
	for body in get_node("hacking").get_overlapping_bodies():
		if body.is_in_group("hackable"):
			print("taking control of "+body.get_name())