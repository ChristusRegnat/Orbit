extends PathFollow2D
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Cargo_Ship.tscn")
@export var speed : float = 100
var Cargo_Active : bool = false

func _ready():
	spawn_cargo_ship()
	
func spawn_cargo_ship():
	var spawn_cargo = Cargo_Ship_Scene.instantiate()
	return spawn_cargo


func _physics_process(delta):
	if Cargo_Active == true:
		if progress < 100:
			progress += speed * delta
			print(progress)
		else:
			Cargo_Active = false
	else:
		if Input.is_action_just_pressed("1"):
			add_child(spawn_cargo_ship())
			Cargo_Active = true
	
