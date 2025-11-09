extends PathFollow2D
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Cargo_Ship.tscn")
@export var speed : float = 5
var Cargo_Active : bool = false

func _ready():
	pass
	
func spawn_cargo_ship():
	var spawn_cargo = Cargo_Ship_Scene.instantiate()
	# **CHANGE 1: Add the instance as a child of this PathFollow2D node.**
	add_child(spawn_cargo) 
	self.progress_ratio = 0.0 # Reset movement progress
	# Removed the 'return spawn_cargo' line as it's no longer needed.


func _process(delta):
	if Cargo_Active == true:
		if progress_ratio < 1:
			move(delta)
		else:
			Cargo_Active = false
	else:
		if Input.is_action_just_pressed("1"):
			spawn_cargo_ship()
			Cargo_Active = true

func move(delta):
	progress_ratio += speed * delta
	
