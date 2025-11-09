extends Area2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var is_dead : bool = false

func _ready():
	animated_sprite.play("100")

func die():
	animated_sprite.play("explosion")
	await animated_sprite.animation_finished
	print("played")
	WaveManager.current_wave = 1
	get_tree().change_scene_to_file("res://Scenes/end_game_screen.tscn")
		
func _on_body_entered(_body: Node2D) -> void:
	Global.HP -= 1
	if Global.HP > 0:
		pass
	else:
		if is_dead == false:
			is_dead = true
			die()
		else:
			pass

	
