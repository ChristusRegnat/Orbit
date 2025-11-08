extends Path2D
@export var target_object: Node2D = null # Assign your object in the Inspector
var point_index_to_move: int = 0         # Index of the point you want to move (0 is the first point)

func _ready():
	if target_object == null:
		print("Error: Target object not assigned!")
		set_process(false) # Stop the script if no target
		return

	# Ensure there is at least one point to move
	if curve.get_point_count() == 0:
		print("Error: Curve has no points! Add a point in the editor first.")
		set_process(false)
		return

func _process(delta):
	# Get the target's position relative to the Path2D's parent (global position works best)
	var new_position: Vector2 = target_object.global_position
	
	# Update the position of the specified point in the curve resource
	# Note: curve.set_point_position uses local coordinates relative to the Path2D node
	curve.set_point_position(point_index_to_move, to_local(new_position))
