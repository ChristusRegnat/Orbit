extends Area2D

# Laser properties
@export var max_range: float = 2000.0
@export var damage: int = 10
@export var speed: float = 600.0
@export var pierce_count: int = 0  # How many enemies it can go through

# Node references
@onready var line = $Line2D
@onready var collision_shape = $CollisionShape2D
@onready var despawn_timer = $DespawnTimer
# @onready var hit_particles = $HitParticles  # Optional

# Internal state
var direction: Vector2 = Vector2.RIGHT
var distance_traveled: float = 0.0
var has_hit: bool = false
var hit_position: Vector2 = Vector2.ZERO

func _ready():
	# Connect signals
	despawn_timer.timeout.connect(_on_despawn_timeout)
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Cast the laser immediately
	_cast_laser()

func _cast_laser():
	# Create a raycast to check for collisions
	var space_state = get_world_2d().direct_space_state
	var start_position = global_position
	var end_position = start_position + direction * max_range
	
	# Set up physics query
	var query = PhysicsRayQueryParameters2D.create(start_position, end_position)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self]  # Don't collide with self
	
	# Perform the raycast
	var result = space_state.intersect_ray(query)
	
	if result:
		# We hit something
		hit_position = result.position
		distance_traveled = start_position.distance_to(hit_position)
		has_hit = true
		
		# Handle the hit
		_handle_hit(result.collider)
	else:
		# No hit, use max range
		hit_position = end_position
		distance_traveled = max_range
	
	# Update the laser visual
	_update_laser_visual()
	
	# Start despawn timer
	despawn_timer.start()

func _update_laser_visual():
	# Update the Line2D to show the laser beam
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	if has_hit:
		# Laser stops at hit point
		var local_hit = to_local(hit_position)
		line.add_point(local_hit)
	else:
		# Laser goes to max range
		line.add_point(Vector2(distance_traveled, 0))
	
	# Update collision shape (for the Area2D)
	if collision_shape:
		var shape = collision_shape.shape as RectangleShape2D
		if shape:
			shape.size = Vector2(distance_traveled, line.width)
			collision_shape.position = Vector2(distance_traveled / 2, 0)

func _handle_hit(collider):
	# Check what we hit
	if collider.has_method("take_damage"):
		collider.take_damage(damage)
		print("Laser hit: ", collider.name, " for ", damage, " damage!")
	
	# Check if it's a planet (should stop the laser)
	if collider.is_in_group("planets"):
		# Planets stop the laser completely
		has_hit = true
	elif pierce_count > 0:
		# Can pierce through some objects
		pierce_count -= 1
	else:
		# Stop at this object
		has_hit = true
	
	# Optional: Spawn hit particles


func _on_area_entered(area):
	# Handle Area2D collisions (like shields, force fields)
	if not has_hit:
		_handle_hit(area)

func _on_body_entered(body):
	# Handle PhysicsBody2D collisions (like ships, planets)
	if not has_hit:
		_handle_hit(body)

func _on_despawn_timeout():
	queue_free()

# Public function to initialize the laser
func setup(laser_direction: Vector2, laser_speed: float, laser_damage: int):
	direction = laser_direction
	speed = laser_speed
	damage = laser_damage
