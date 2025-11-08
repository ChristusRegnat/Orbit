extends PanelContainer

@onready var timer_label = $VBoxContainer/TimerLabel
@onready var wave_label = $VBoxContainer/WaveLabel

func update_timer_display(seconds: float):
	# Format time as M:SS
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	timer_label.text = "%d:%02d" % [minutes, secs]
	
	# Change color when time is running out
	if seconds <= 5:
		timer_label.modulate = Color.RED
	elif seconds <= 10:
		timer_label.modulate = Color.YELLOW
	else:
		timer_label.modulate = Color.WHITE

func update_wave_display(wave_number: int):
	wave_label.text = "Wave: %d" % wave_number
	
	# Visual feedback for new wave
	var tween = create_tween()
	tween.tween_property(wave_label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(wave_label, "scale", Vector2(1.0, 1.0), 0.3)
