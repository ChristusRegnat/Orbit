extends Area2D


# 1. Define and preload your sound resource
# IMPORTANT: Replace the path with your actual sound file path (e.g., a .ogg file)
const DEATH_SOUND = preload("res://Sounds/earth_explosion (mp3cut.net).mp3")

@export var HP : int = 5
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var is_dead : bool = false

func _ready():
	animated_sprite.play("100")

# === HELPER FUNCTION: Defines the sound playing logic ===
func _play_death_sound():
	# Create a temporary AudioStreamPlayer
	var temp_player = AudioStreamPlayer.new()
	temp_player.stream = DEATH_SOUND
	
	# Add it to the scene tree
	add_child(temp_player)
	
	# Ensure the player cleans itself up when done (crucial for memory)
	temp_player.finished.connect(Callable(temp_player, "queue_free"))
	
	temp_player.play()
# =======================================================

func die():
	# 1. Start the death animation
	animated_sprite.play("explosion")
	_play_death_sound()
	# 2. Wait for the animation to finish
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

	
