extends Area2D

signal area_left_clicked

func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("Function called by signal!")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("signal time")
		emit_signal("area_left_clicked")
		
