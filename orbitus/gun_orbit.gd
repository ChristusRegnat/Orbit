extends Path2D

var item_scene: PackedScene = load("res://gun_orbit_follow_object.tscn")

func _ready() -> void:
	if item_scene == null:
		push_error("Failed to load turret scene! Check path: res://gun_orbit_follow_object.tscn")
		return

	# Connect to global signal to react to turret count changes
	if not Global.turret_count_changed.is_connected(_on_turret_count_changed):
		Global.turret_count_changed.connect(_on_turret_count_changed)

	# Initial spawn
	_spawn_turrets(Global.TurretCount)


# Called when the global turret count changes
func _on_turret_count_changed(new_value: int) -> void:
	_spawn_turrets(new_value)


# Spawns the correct number of turret instances and sets angular offsets
func _spawn_turrets(turret_count: int) -> void:
	# Remove any existing children first
	for child in get_children():
		child.queue_free()

	if turret_count <= 0:
		return

	for i in range(turret_count):
		var turret_instance = item_scene.instantiate()
		add_child(turret_instance)

		# Compute angular offset (evenly spaced)
		var offset: float = (1.0 / turret_count) * i

		# Apply the offset
		print(offset)
		turret_instance.set_offset(offset)
