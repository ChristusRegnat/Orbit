extends Node2D
const Enemy_Ship_Scene: PackedScene = preload("res://Scenes/enemy_L.tscn")
const Bottom_Resource_Bar: PackedScene = preload("res://BottomResourceBar.tscn")
var counter = 0
var rand_x = 0
var rand_y = 0

func _ready():
	randomize()
	# Summon Bottom Resource Bar
	var resource_bar = Bottom_Resource_Bar.instantiate()
	add_child(resource_bar)
	
func enemy_spawns():
		# Generate rand_x
		var x_range = [[-676, -576], [576, 676]]
		var index = randi_range(0, x_range.size() -1)
		rand_x = randi_range(x_range[index][0],x_range[index][1])
		# Generate rand_y
		var y_range = [[-324, -424], [324, 424]]
		index = randi_range(0, y_range.size() -1)
		rand_y = randi_range(y_range[index][0],y_range[index][1])
	
func spawn_enemy():
	while counter != 6:
		var enemy = Enemy_Ship_Scene.instantiate()
		enemy_spawns()
		enemy.position = Vector2(rand_x,rand_y)
		add_child(enemy)
		counter += 1
	if counter == 6:
		counter = 0
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		spawn_enemy()
	
