extends Label
func _ready() -> void:
	self.text = str(Global.HP)

func _process(delta: float) -> void:
	self.text = str(Global.HP)
