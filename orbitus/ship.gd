extends CharacterBody2D
@export var speed : float = 100
@export var acceleration : float = 100
@export var deceleration : float = 50
@export var reverse_speed : float = 100
@export var reverse_acceleration : float = 50
@export var turn_speed : float = 50

func _physics_process(delta):
	# Determine what "forward" is
	var direction: Vector2 = Vector2.UP.rotated(rotation)
	
	var direction_input = Input.get_axis("Forward","Back")
	print(direction)
	# Turn Ship Right
	if Input.is_action_pressed("Right"):
		rotation +=  turn_speed * delta
	# Turn Ship Left
	if Input.is_action_pressed("Left"):
		rotation -= turn_speed * delta
	# Move Ship Forward or Back
		velocity = direction * direction_input * speed
	move_and_slide()
	
		
