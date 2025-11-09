extends PathFollow2D
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Cargo_Ship.tscn")
@export var speed : float = 5
var Cargo_Active : bool = false

func _ready():
	spawn_cargo_ship()
	
func spawn_cargo_ship():
	var spawn_cargo = Cargo_Ship_Scene.instantiate()
	return spawn_cargo


func _process(delta):
	if Cargo_Active == true:
		if progress_ratio < 1:
			move(delta)
		else:
			Cargo_Active = false
	else:
		if Input.is_action_just_pressed("1"):
			add_child(spawn_cargo_ship())
			Cargo_Active = true

func move(delta):
	progress_ratio += speed * delta
	
