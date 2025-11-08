extends CharacterBody2D
@export var speed : float = 100
var collided : bool = false

func _ready():
	look_at(get_parent().get_node("Earth").position)


func _physics_process(delta):
	if not collided:
		velocity += transform.x * speed * delta
		var collision = move_and_collide(velocity * delta)
		if collision:
			collided = true
			queue_free()
			
