extends Control

@onready var notification_label = $NotificationLabel

func show_wave_notification(wave_number: int, is_boss: bool = false):
	if is_boss:
		notification_label.text = "BOSS WAVE %d!" % wave_number
		notification_label.add_theme_color_override("font_color", Color.PURPLE)
		
		# Add special boss effects
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(notification_label, "scale", Vector2(1.5, 1.5), 0.5)
		tween.tween_property(notification_label, "modulate", Color.GOLD, 0.5)
	else:
		notification_label.text = "WAVE %d STARTED!" % wave_number
		notification_label.add_theme_color_override("font_color", Color.RED)
	
	# Show and animate the notification
	visible = true
	
	var show_tween = create_tween()
	show_tween.tween_property(self, "modulate:a", 1.0, 0.3)
	show_tween.tween_interval(2.0)  # Show for 2 seconds
	show_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	show_tween.tween_callback(hide)

func _ready():
	# Start hidden
	modulate.a = 0.0
	visible = false
