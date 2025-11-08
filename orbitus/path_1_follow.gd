extends PathFollow2D

@export var speed: float = 100.0 # Pixels per second

func _process(delta: float) -> void:
	progress += speed * delta
