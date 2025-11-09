extends Node2D


func buy_ship() -> void:
	if (GlobalResource.get_resource("gold") >= 1 and GlobalResource.get_resource("spice") >= 2):
		GlobalResource.modify_resource("gold", -1)
		GlobalResource.modify_resource("spice", -2)
		Global.ShipCount += 1

func buy_turret() -> void:
	if (GlobalResource.get_resource("crystal") >= 2 and GlobalResource.get_resource("aether") >= 1):
		GlobalResource.modify_resource("crystal", -2)
		GlobalResource.modify_resource("aether", -1)
		Global.increment_turret_count()

func buy_HP() -> void:
	if (GlobalResource.get_resource("Spice") >= 1):
		GlobalResource.modify_resource("Spice", -1)
		Global.HP += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Attempt to buy a ship when the button is pressed
func _on_buy_ship_button_pressed() -> void:
	buy_ship()

# Attempt to buy a turret when the button is pressed
func _on_buy_turret_button_pressed() -> void:
	buy_turret()

func _on_buy_hp_button_pressed() -> void:
	buy_HP()
