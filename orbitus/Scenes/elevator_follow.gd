extends PathFollow2D
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Cargo_Ship.tscn")
@export var speed : float = 100

func _ready():
	spawn_cargo_ship()
	
func spawn_cargo_ship():
	var spawn_cargo = Cargo_Ship_Scene.instantiate()
	return spawn_cargo

func move(delta:float) -> void:
	progress += speed * delta

func _on_planet_1_area_left_clicked(delta) -> void:
	print("click")
	add_child(spawn_cargo_ship())
	move(delta)
