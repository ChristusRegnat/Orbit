extends Path2D

#@export var item_scene: PackedScene = preload("res://gun_orbit_follow_object.tscn")
var item_scene = load("res://gun_orbit_follow_object.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path := "res://gun_orbit_follow_object.tscn"
	var ps = load(path)
	print("Path exists?", ResourceLoader.exists(path))
	print("Loaded resource:", ps)
	print("Is PackedScene?", ps is PackedScene)

	
	var turret_count: int = Global.TurretCount
	for i in range(turret_count):
		var turret_instance = item_scene.instantiate()
		add_child(turret_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
