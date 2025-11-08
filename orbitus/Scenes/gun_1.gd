extends Area2D

@onready var ray_cast: RayCast2D = $Gun1Raycast
@onready var tracer_line: Line2D = $Gun1Raycast/Gun1BulletTrace
@onready var tracer_timer: Timer = $Gun1TracerTimer # Reference to a Timer node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_shape_entered() -> void:
	pass

func _on_body_entered() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			shoot()

# Shoot gun
func shoot():
	# Force update if necessary (if shooting multiple times per physics frame)
	# ray_cast.force_raycast_update() 

	if ray_cast.is_colliding():
		var collision_point: Vector2 = ray_cast.get_collision_point()
		
		# Convert global collision point to the Line2D's local space
		var start_point: Vector2 = ray_cast.global_position
		var end_point: Vector2 = collision_point
		
		# Set the line points
		tracer_line.points = [tracer_line.to_local(start_point), tracer_line.to_local(end_point)]
		
		# Start the timer to clear the line
		tracer_timer.start(0.1)
		
		# ... (handle damage, impact effects, etc.)
	else:
		# If no collision, the line goes to the raycast's target position
		tracer_line.points = [Vector2.ZERO, ray_cast.target_position]
		tracer_timer.start(0.1)


func _on_gun_1_tracer_timer_timeout() -> void:
	# Clear the points to make the line disappear
	tracer_line.clear_points()
