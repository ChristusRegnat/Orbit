extends CharacterBody2D
@export var speed : float = 100
@export var acceleration : float = 100
@export var deceleration : float = 50
@export var reverse_speed : float = 100
@export var reverse_acceleration : float = 50
@export var turn_speed : float = 50


func _physics_process(delta):
	# Turn Ship Right
	if Input.is_action_pressed("Right"):
		rotation +=  turn_speed * delta
	# Turn Ship Left
	if Input.is_action_pressed("Left"):
		rotation -= turn_speed * delta
	# Move Forward or back
	velocity += transform.x * Input.get_axis("Forward","Back") * speed * delta
	move_and_slide()
