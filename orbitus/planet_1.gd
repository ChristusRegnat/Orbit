extends Area2D

# When planet collides, set parent alive variable to false
func _on_body_entered(body: Node2D) -> void:
	get_parent().is_alive = false
	print("bam")


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	get_parent().is_alive = false
	print("bam")
