extends Node2D
const Enemy_Ship_Scene: PackedScene = preload("res://Scenes/enemy.tscn")

func _ready():
	spawn_enemy()
	
func spawn_enemy():
	var enemy = Enemy_Ship_Scene.instantiate()
	enemy.position = Vector2(200,200)
	add_child(enemy)
	enemy = Enemy_Ship_Scene.instantiate()
	enemy.position = Vector2(-200,-200)
	add_child(enemy)
	enemy = Enemy_Ship_Scene.instantiate()
	enemy.position = Vector2(-200,200)
	add_child(enemy)
	enemy = Enemy_Ship_Scene.instantiate()
	enemy.position = Vector2(200,-200)
	add_child(enemy)
	enemy = Enemy_Ship_Scene.instantiate()
	enemy.position = Vector2(100,275)
	add_child(enemy)
	enemy = Enemy_Ship_Scene.instantiate()
	enemy.position = Vector2(5,250)
	add_child(enemy)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		spawn_enemy()
