extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Start game when the play button is pressed.
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

# Show options when the options button is pressed.
func _on_options_button_pressed() -> void:
	pass # Replace with function body.

# Close the window when the quit button is pressed.
func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
