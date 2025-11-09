extends Node2D

@onready var spawn_timer: Timer = $EnemySpawner/SpawnTimer

func _ready():
	# Connect the spawn timer if not already connected
	if not spawn_timer.is_connected("timeout", _on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy = CharacterBody2D.new()
	enemy.script = load("res://Scripts/enemy.gd")
	enemy.add_to_group("enemies")
	
	# Add sprite
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/mefl_eb.png")
	sprite.scale = Vector2(0.3, 0.3)
	enemy.add_child(sprite)
	
	# Add collision
	var collision = CollisionShape2D.new()
	var shape = CapsuleShape2D.new()
	collision.shape = shape
	collision.scale = Vector2(2.775, 0.745)
	enemy.add_child(collision)
	
	
	add_child(enemy)
