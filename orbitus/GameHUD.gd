extends Control

# We'll use a preload to make sure Godot knows about WaveManager
const WaveManager = preload("res://WaveManager.gd")

# References to our wave system components
@onready var wave_timer_display = $WaveTimerDisplay
@onready var wave_notification = $WaveNotification
@onready var skip_wave_button = $SkipWaveButton

# Reference to the WaveManager (we'll create this in _ready)
var wave_manager: Node

func _ready():
	# Create the WaveManager instance
	wave_manager = WaveManager.new()
	add_child(wave_manager)
	
	# Connect wave manager signals
	if wave_manager.has_signal("timer_updated"):
		wave_manager.timer_updated.connect(_on_timer_updated)
	if wave_manager.has_signal("wave_started"):
		wave_manager.wave_started.connect(_on_wave_started)
	if wave_manager.has_signal("boss_wave_started"):
		wave_manager.boss_wave_started.connect(_on_boss_wave_started)
	if wave_manager.has_signal("wave_ended"):
		wave_manager.wave_ended.connect(_on_wave_ended)
	
	# Connect the skip button
	skip_wave_button.pressed.connect(_on_skip_wave_pressed)
	
	# Initial display update
	update_display()
	
	print("Wave system initialized!")

func _on_timer_updated(seconds_remaining: float):
	if wave_timer_display:
		wave_timer_display.update_timer_display(seconds_remaining)

func _on_wave_started(wave_number: int):
	if wave_timer_display:
		wave_timer_display.update_wave_display(wave_number)
	if wave_notification:
		wave_notification.show_wave_notification(wave_number, false)
	
	# You could also trigger enemy spawns, enable spawners, etc. here
	spawn_wave_enemies(wave_number)

func _on_boss_wave_started():
	var current_wave = wave_manager.get_current_wave()
	if wave_notification:
		wave_notification.show_wave_notification(current_wave, true)
	
	# Trigger boss-specific logic
	spawn_boss()

func _on_wave_ended(wave_number: int):
	print("Wave %d cleanup" % wave_number)
	# Clean up enemies, award resources, etc.

func _on_skip_wave_pressed():
	if wave_manager:
		wave_manager.skip_to_next_wave()

func update_display():
	# Update display with current state
	if wave_manager and wave_timer_display:
		wave_timer_display.update_wave_display(wave_manager.get_current_wave())
		wave_timer_display.update_timer_display(wave_manager.get_time_remaining())

# Example functions that would trigger from other parts of your game
func spawn_wave_enemies(wave_number: int):
	print("Spawning enemies for wave ", wave_number)
	# This is where you'd actually spawn enemies
	# For now, just print a message

func spawn_boss():
	print("SPAWNING BOSS ENEMY!")
	# Boss spawning logic here

# Public function to get wave manager reference
func get_wave_manager() -> Node:
	return wave_manager
