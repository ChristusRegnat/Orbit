extends Area2D

@export var fire_rate: float = 1.0  # Shots per second
@export var range_distance: float = 500.0
@export var damage: int = 1
@export var debug_mode: bool = true  # Turn on to see debug messages

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var tracer_line: Line2D = $Line2D
@onready var fire_timer: Timer = $FireTimer

var current_target: Node2D = null
var can_fire: bool = true

func _ready() -> void:
	if debug_mode:
		print("Gun initialized - RayCast enabled: ", ray_cast.enabled if ray_cast else "NO RAYCAST")
	
	# Set up fire rate timer
	if fire_timer:
		fire_timer.wait_time = 1.0 / fire_rate
		fire_timer.timeout.connect(_on_fire_timer_timeout)
		fire_timer.start()
	else:
		if debug_mode:
			print("ERROR: No FireTimer found!")
	
	# Set raycast range
	if ray_cast:
		ray_cast.target_position = Vector2(0, -range_distance)
		ray_cast.enabled = true
		ray_cast.collide_with_areas = true
		ray_cast.collide_with_bodies = true
	else:
		if debug_mode:
			print("ERROR: No RayCast2D found!")

func _process(_delta: float) -> void:
	# Find and track targets
	if not current_target or not is_instance_valid(current_target):
		find_target()
	
	if current_target and is_instance_valid(current_target):
		track_target()
		
		# Auto-fire when target is acquired
		if can_fire and is_target_in_range():
			if debug_mode:
				print("Firing at target!")
			shoot()
		elif debug_mode:
			if not can_fire:
				print("Cannot fire: cooling down")
			if not is_target_in_range() and current_target:
				var distance = global_position.distance_to(current_target.global_position)
				print("Target out of range: ", distance, " > ", range_distance)

func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	if debug_mode:
		print("Looking for enemies. Found: ", enemies.size())
	
	var closest_enemy = null
	var closest_distance = range_distance
	
	for enemy in enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if debug_mode:
				print("Enemy found at distance: ", distance)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
	
	current_target = closest_enemy
	
	if debug_mode and current_target:
		print("Target acquired: ", current_target.name, " at distance: ", closest_distance)

func track_target():
	if current_target and is_instance_valid(current_target):
		# Calculate angle to target
		var direction = (current_target.global_position - global_position).normalized()
		var angle = atan2(direction.y, direction.x)
		
		# Rotate the gun (adjust offset if needed)
		global_rotation = angle + PI/2  # +PI/2 if your gun sprite faces up
		
		if debug_mode:
			print("Tracking target - Rotation: ", global_rotation)

func is_target_in_range() -> bool:
	if not current_target:
		if debug_mode:
			print("No target to check range")
		return false
	
	var distance = global_position.distance_to(current_target.global_position)
	var in_range = distance <= range_distance
	
	if debug_mode:
		print("Target range check: ", distance, " <= ", range_distance, " = ", in_range)
	
	return in_range

func shoot():
	if not current_target:
		if debug_mode:
			print("No target to shoot at!")
		return
	
	can_fire = false
	
	if fire_timer:
		fire_timer.start()
	else:
		if debug_mode:
			print("ERROR: No fire timer!")
	
	# Update raycast to current rotation
	if ray_cast:
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding():
			var collision_point: Vector2 = ray_cast.get_collision_point()
			var collider = ray_cast.get_collider()
			
			if debug_mode:
				print("RayCast hit: ", collider.name if collider else "Unknown")
			
			# Draw tracer line
			if tracer_line:
				var start_point: Vector2 = ray_cast.global_position
				var end_point: Vector2 = collision_point
				tracer_line.points = [tracer_line.to_local(start_point), tracer_line.to_local(end_point)]
			
			# Damage the enemy
			if collider and collider.is_in_group("enemies"):
				if debug_mode:
					print("Damaging enemy!")
				collider.take_damage(damage)
			else:
				if debug_mode:
					print("Collider is not an enemy or not in group 'enemies'")
			
			# Start timer to clear tracer
			if has_node("TracerTimer"):
				get_node("TracerTimer").start(0.1)
		else:
			if debug_mode:
				print("RayCast did not collide with anything")
			# If no collision, show full range line
			if tracer_line:
				tracer_line.points = [Vector2.ZERO, ray_cast.target_position]
			if has_node("TracerTimer"):
				get_node("TracerTimer").start(0.1)
	else:
		if debug_mode:
			print("ERROR: No raycast to shoot with!")

func _on_fire_timer_timeout():
	can_fire = true
	if debug_mode:
		print("Fire cooldown complete - ready to fire again")

func _on_tracer_timer_timeout():
	if tracer_line:
		tracer_line.clear_points()
