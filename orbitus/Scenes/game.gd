extends Node2D
const Enemy_Ship_Scene: PackedScene = preload("res://Scenes/enemy_L.tscn")
const Bottom_Resource_Bar: PackedScene = preload("res://BottomResourceBar.tscn")
const Game_HUD: PackedScene = preload("res://GameHUD.tscn")
var counter = 0
var rand_x = 0
var rand_y = 0

func _ready():
	Global.ShipCount = 3
	randomize()
	# Summon Bottom Resource Bar
	var resource_bar = Bottom_Resource_Bar.instantiate()
	resource_bar.position = Vector2(-576,-324)
	resource_bar.scale = Vector2(0.8, 0.8)
	add_child(resource_bar)
	# Summon HUD
	var GameHUD = Game_HUD.instantiate()
	GameHUD.position = Vector2(-630,210)
	add_child(GameHUD)
	WaveManager.current_wave = 1
	
	
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
	var enemy = Enemy_Ship_Scene.instantiate()
	enemy_spawns()
	enemy.position = Vector2(rand_x,rand_y)
	add_child(enemy)
	
	
	
	
func Summon_Wave():
	if WaveManager.get_current_wave() == 2:
		#OS.delay_msec(5000)
		while counter != 5:
			spawn_enemy()
			counter += 1
	elif WaveManager.get_current_wave() == 3:
		#OS.delay_msec(6000)
		while counter != 25:
			spawn_enemy()
			counter += 1
	elif WaveManager.get_current_wave() == 4:
		#OS.delay_msec(8000)
		while counter != 55:
			spawn_enemy()
			counter += 1
	elif WaveManager.get_current_wave() == 5:
		#OS.delay_msec(10000)
		while counter != 155:
			spawn_enemy()
			counter += 1
			
func _process(delta: float) -> void:
	if WaveManager.wave_started:
		Summon_Wave()
