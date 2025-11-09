extends CharacterBody2D

@export var speed : float = 50
@export var health : int = 3
var collided : bool = false
var being_targeted: bool = false  # Track if the enemy is being targeted by a turret

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
		
# This function checks if the enemy is being targeted
func is_being_targeted() -> bool:
	return being_targeted

# This function allows a turret to mark the enemy as targeted
func set_targeted(state: bool) -> void:
	being_targeted = state
func destroy():
	queue_free()

func _physics_process(delta):
	if not collided:
		velocity += transform.x * speed * delta
		var collision = move_and_collide(velocity * delta)
		if collision:
			collided = true
			queue_free()
