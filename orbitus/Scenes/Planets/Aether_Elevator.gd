extends Path2D
@export var target_object: Node2D = null # Assign your object in the Inspector
var point_index_to_move: int = 1         # Index of the point you want to move (0 is the first point)
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Planets/Aether_Ship.tscn")

func _process(delta):
	# Get the target's position relative to the Path2D's parent (global position works best)
	var new_position: Vector2 = target_object.global_position
	
	# Update the position of the specified point in the curve resource
	# Note: curve.set_point_position uses local coordinates relative to the Path2D node
	self.curve.set_point_position(point_index_to_move, to_local(new_position))
	
func Summon_Ship():
	if Global.ShipCount < 1:
		pass
	else:
		var Cargo = Cargo_Ship_Scene.instantiate()
		Cargo.scale = Vector2(1 / 3.015, 1 / 3.015)
		add_child(Cargo)


func _on_aether_button_pressed() -> void:
	Summon_Ship()
