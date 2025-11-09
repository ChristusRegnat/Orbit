extends Area2D

@export var fire_rate: float = 5.0  # Shots per second
@export var range_distance: float = 2000.0
@export var damage: int = 3
@export var debug_mode: bool = true  # Turn on to see debug messages

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var tracer_line: Line2D = $Line2D
@onready var fire_timer: Timer = $FireTimer

var current_target: Node2D = null
var can_fire: bool = true

func _ready() -> void:
	if debug_mode:
		pass
	
	# Set up fire rate timer
	if fire_timer:
		fire_timer.wait_time = 1 / fire_rate  # Adjust fire rate dynamically based on fire_rate variable
		fire_timer.timeout.connect(_on_fire_timer_timeout)
		fire_timer.start()
	else:
		if debug_mode:
			pass
	
	# Set raycast range
	if ray_cast:
		ray_cast.target_position = Vector2(0, -range_distance)
		ray_cast.enabled = true
		ray_cast.collide_with_areas = true
		ray_cast.collide_with_bodies = true
	else:
		if debug_mode:
			pass

func _process(_delta: float) -> void:
	# Find and track targets
	if not current_target or not is_instance_valid(current_target):
		find_target()
	
	if current_target and is_instance_valid(current_target):
		track_target()
		
		# Auto-fire when target is acquired
		if can_fire and is_target_in_range():
			if debug_mode:
				pass
			shoot()
		elif debug_mode:
			if not can_fire:
				pass
			if not is_target_in_range() and current_target:
				var distance = global_position.distance_to(current_target.global_position)
				pass



func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	if debug_mode:
		pass
	
	# Filter out enemies that are already targeted
	var available_enemies = []
	
	for enemy in enemies:
		if is_instance_valid(enemy) and not enemy.is_being_targeted():
			available_enemies.append(enemy)
	
	if available_enemies.size() > 0:
		# Select a random enemy from the available ones
		current_target = available_enemies[randi() % available_enemies.size()]
	
	if debug_mode and current_target:
		pass

func track_target():
	if current_target and is_instance_valid(current_target):
		# Calculate angle to target
		var direction = (current_target.global_position - global_position).normalized()
		var angle = atan2(direction.y, direction.x)
		
		# Rotate the gun (adjust offset if needed)
		global_rotation = angle + PI/2  # +PI/2 if your gun sprite faces up
		
		if debug_mode:
			pass

func is_target_in_range() -> bool:
	if not current_target:
		if debug_mode:
			pass
		return false
	
	var distance = global_position.distance_to(current_target.global_position)
	var in_range = distance <= range_distance
	
	if debug_mode:
		pass
	
	return in_range

func shoot():
	if not current_target:
		if debug_mode:
			pass
		return
	
	can_fire = false
	
	if fire_timer:
		fire_timer.start()
	else:
		if debug_mode:
			pass
	
	# Update raycast to current rotation
	if ray_cast:
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding():
			var collision_point: Vector2 = ray_cast.get_collision_point()
			var collider = ray_cast.get_collider()
			
			if debug_mode:
				pass
			
			# Draw tracer line
			if tracer_line:
				var start_point: Vector2 = ray_cast.global_position
				var end_point: Vector2 = collision_point
				tracer_line.points = [tracer_line.to_local(start_point), tracer_line.to_local(end_point)]
			
			# Damage the enemy
			if collider and collider.is_in_group("enemies"):
				if debug_mode:
					pass
				collider.take_damage(damage)
			else:
				if debug_mode:
					pass
			
			# Start timer to clear tracer
			if has_node("TracerTimer"):
				get_node("TracerTimer").start(0.1)
		else:
			if debug_mode:
				pass
			# If no collision, show full range line
			if tracer_line:
				tracer_line.points = [Vector2.ZERO, ray_cast.target_position]
			if has_node("TracerTimer"):
				get_node("TracerTimer").start(0.1)
	else:
		if debug_mode:
			pass

func _on_fire_timer_timeout():
	can_fire = true
	if debug_mode:
		pass

func _on_tracer_timer_timeout():
	if tracer_line:
		tracer_line.clear_points()
