extends PathFollow2D

@export var speed: float = 100.0 # Pixels per second
@export var is_alive: bool = true # Whether or not planet has been destroyed


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if is_alive == true:
		move(delta)
	else:
		pass
		

#Function that tells the planet to move around the orbit 
func move(delta:float) -> void:
	progress += speed * delta

func set_offset(offset: float) -> void:
	print(offset)
	progress_ratio = offset
