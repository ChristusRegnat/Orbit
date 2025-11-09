extends Node2D
const Enemy_Ship_Scene: PackedScene = preload("res://Scenes/enemy_L.tscn")
var counter = 0

func _ready():
	pass
	
func spawn_enemy():
	while counter != 6:
		var enemy = Enemy_Ship_Scene.instantiate()
		enemy.position = Vector2(200,200)
		add_child(enemy)
		counter += 1
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		spawn_enemy()
