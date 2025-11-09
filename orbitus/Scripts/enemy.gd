extends CharacterBody2D

@export var speed : float = 100
@export var health : int = 3
var collided : bool = false

func _ready():
	look_at(Vector2(0,0))
	add_to_group("enemies")
	
	# Make sure collision is enabled
	if $CollisionShape2D:
		$CollisionShape2D.disabled = false
		
		
func take_damage(amount: int = 3):
	health -= amount
	if health <= 0:
		destroy()

func destroy():
	queue_free()

func _physics_process(delta):
	if not collided:
		velocity += transform.x * speed * delta
		var collision = move_and_collide(velocity * delta)
		if collision:
			collided = true
			queue_free()
