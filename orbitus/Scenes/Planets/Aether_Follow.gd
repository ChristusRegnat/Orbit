extends PathFollow2D
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Planets/Aether_Ship.tscn")
@export var speed : float = 0.5
var Cargo_Active : bool = false


func _ready():
	self.progress_ratio = 0
	
func _process(delta):
	if progress_ratio < 1:
		move(delta)
	else:
		GlobalResource.modify_resource("Aether", 1)
		print(GlobalResource.get_resource("Aether"))
		queue_free()

func move(delta):
	progress_ratio += speed * delta
	
