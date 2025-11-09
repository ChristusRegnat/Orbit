extends Area2D

const GUN_SOUND_RESOURCE = preload("res://Sounds/GunC sound-[AudioTrimmer.com].mp3")

@onready var ray_cast: RayCast2D = $Gun1Raycast
@onready var tracer_line: Line2D = $Gun1Raycast/Gun1BulletTrace
@onready var tracer_timer: Timer = $Gun1TracerTimer # Reference to a Timer node

var shoot_sound: AudioStreamPlayer2D = null 

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
	if GUN_SOUND_RESOURCE is AudioStream:
		# Create a new AudioStreamPlayer2D node
		var temp_sound = AudioStreamPlayer2D.new()
		
		# Set its audio stream resource (using the preloaded file)
		temp_sound.stream = GUN_SOUND_RESOURCE
		
		# Set its position to the gun's position (for 2D sound spatialization)
		temp_sound.global_position = global_position
		
		# Add it to the scene tree
		get_tree().current_scene.add_child(temp_sound)
		
		# Connect the 'finished' signal to automatically delete the node
		temp_sound.connect("finished", Callable(temp_sound, "queue_free")) 
		
		# Play the sound!
		temp_sound.play()
		
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
