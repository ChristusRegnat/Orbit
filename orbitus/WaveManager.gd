extends Node

# Wave signals - other parts of the game can listen to these
signal wave_started(wave_number)
signal wave_ended(wave_number)
signal timer_updated(seconds_remaining)
signal boss_wave_started()

# Wave settings
var current_wave: int = 1
var time_between_waves: float = 10.0  # Start with 10 seconds for testing
var timer: Timer
var is_wave_active: bool = false

# Wave progression - each wave gets shorter preparation time until boss
var wave_times = [20.0, 25, 30, 35, 40, 50, 4.0, 3.0, 2.0, 1.0]
var boss_wave_number: int = 10

func _ready():
	# Create and configure the timer
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	# Start the first wave countdown
	start_wave_countdown()

func start_wave_countdown():
	is_wave_active = false
	
	# Get the appropriate time for this wave
	var wave_index = min(current_wave - 1, wave_times.size() - 1)
	time_between_waves = wave_times[wave_index]
	
	# Start the timer
	timer.start(time_between_waves)
	
	# Update any displays
	timer_updated.emit(time_between_waves)
	
	print("Wave %d countdown started: %.1f seconds" % [current_wave, time_between_waves])

func _on_timer_timeout():
	# Time's up - start the wave!
	start_wave()

func start_wave():
	is_wave_active = true
	print("WAVE %d STARTED!" % current_wave)
	
	# Check if this is a boss wave
	if current_wave == boss_wave_number:
		boss_wave_started.emit()
		print("BOSS WAVE! PREPARE FOR BATTLE!")
	
	# Emit signal for other parts of the game
	wave_started.emit(current_wave)
	
	# In a real game, you'd spawn enemies here
	# For now, we'll just simulate a wave duration
	simulate_wave_duration()

func simulate_wave_duration():
	# Simulate wave lasting 5 seconds, then end
	await get_tree().create_timer(5.0).timeout
	end_wave()

func end_wave():
	if current_wave < 5:
		print("Wave %d completed!" % current_wave)
		wave_ended.emit(current_wave)
	
		# Move to next wave
		current_wave += 1
	
		# Start countdown for next wave
		start_wave_countdown()
	else:
		win_screen()

func _process(delta):
	if timer and not is_wave_active:
		# Update timer display continuously
		timer_updated.emit(timer.time_left)

# Public API - functions other scripts can use
func get_time_remaining() -> float:
	if timer:
		return timer.time_left
	return 0.0

func get_current_wave() -> int:
	return current_wave

func is_wave_in_progress() -> bool:
	return is_wave_active

# For debugging - skip to next wave
func skip_to_next_wave():
	if timer:
		timer.stop()
		start_wave()

# win screen go brrrrrrr
func win_screen():
	get_tree().change_scene_to_file("res://Scenes/WinGameScreen.tscn")
