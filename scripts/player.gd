extends KinematicBody2D

const SPEED = 600				# moving speed
const JUMP_SPEED = 1500			# jumping speed
const GRAVITY = 150				# falling gravity
onready var SIZE = get_node("CollisionShape2D").shape.extents		# shape size


var vel = Vector2(0, 0)
var on_floor = true


onready var left_ray = [get_node("raycast/left/RayCast2D"), get_node("raycast/left/RayCast2D2")]
onready var right_ray = [get_node("raycast/right/RayCast2D"), get_node("raycast/right/RayCast2D2")]
onready var down_ray = [get_node("raycast/down/RayCast2D"), get_node("raycast/down/RayCast2D2")]


func _ready():
	for group in [left_ray, right_ray, down_ray]:
		for ray in group:
			ray.add_exception(self)
	set_physics_process(true)


func _physics_process(delta):
	var dir = 0
	
	if Input.is_action_pressed("move_left"):	# Inputs
		dir -= 1
	if Input.is_action_pressed("move_right"):
		dir += 1
	
	
	for group in [left_ray, right_ray]: 		# Checking side collisions and setting pos if colliding
		for ray in group:
			if ray.is_colliding() and sign(ray.get_cast_to().x) == dir:
				var c = ray.get_collider()
				var sh = ray.get_collider_shape()
				
				position.x = c.position.x  +  sh.shape.extents.x*(-dir)  +  SIZE.x*(-dir)
				dir = 0
				break
				break
	
	
	vel.x = SPEED*dir				# Adding X vel
	
	
	var i = 0
	for ray in down_ray:			# For now this won't work cause there are no objects around
		i += 1
		if ray.is_colliding():
			var c = ray.get_collider()
			var sh = ray.get_collider_shape()
			
			position.y = c.position.y  -  sh.shape.extents.y  -  SIZE.y
			
			vel.y = 0
			on_floor = true
			break
		if i == 2:
			pass
#			on_floor = false		# Used when there will be blocks
	
	
	if Input.is_action_pressed("jump"): # Jumping?
		if on_floor:
			vel.y = -JUMP_SPEED
			on_floor = false	# To be disable afterwards
	
	
	move_and_slide(vel)
	
	
	if position.y >= 600:		# Stop without blocks, debug
		position.y = 600		# To be disable afterwards
		on_floor = true
		return
	
	vel.y += GRAVITY