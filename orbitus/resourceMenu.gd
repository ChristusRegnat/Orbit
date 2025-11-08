extends Control

# References to our resource displays
@onready var gold_display = $MarginContainer/VBoxContainer/ResourceDisplay
@onready var steel_display = $MarginContainer/VBoxContainer/ResourceDisplay2
@onready var spice_display = $MarginContainer/VBoxContainer/ResourceDisplay3  
@onready var aether_display = $MarginContainer/VBoxContainer/ResourceDisplay4

# Dictionary to track all resources
var resources = {}

func _ready():
	# Set up each resource display
	gold_display.set_resource("Gold", 100)
	steel_display.set_resource("Steel", 50)
	spice_display.set_resource("Spice", 25)
	aether_display.set_resource("Aether", 10)
	
	# Connect signals from each display
	gold_display.resource_changed.connect(_on_resource_changed)
	steel_display.resource_changed.connect(_on_resource_changed)
	spice_display.resource_changed.connect(_on_resource_changed)
	aether_display.resource_changed.connect(_on_resource_changed)
	
	# Initialize the resources dictionary
	update_resources_dict()

func _on_resource_changed(resource_name: String, new_amount: int):
	# Update our internal tracking
	resources[resource_name.to_lower()] = new_amount
	print("Resource changed: ", resource_name, " = ", new_amount)
	
	# You can add visual/audio feedback here
	# Or call functions in your main game

func update_resources_dict():
	# Initialize the dictionary with current values
	resources = {
		"gold": gold_display.current_amount,
		"steel": steel_display.current_amount, 
		"spice": spice_display.current_amount,
		"aether": aether_display.current_amount
	}

# Public functions to interact with the menu from other scripts
func get_resource_amount(resource_name: String) -> int:
	return resources.get(resource_name.to_lower(), 0)

func set_resource_amount(resource_name: String, amount: int):
	var display = _get_display_for_resource(resource_name)
	if display:
		display.current_amount = max(0, amount)
		display.update_display()
		resources[resource_name.to_lower()] = display.current_amount

func modify_resource(resource_name: String, change: int):
	var display = _get_display_for_resource(resource_name)
	if display:
		display.current_amount = max(0, display.current_amount + change)
		display.update_display()
		resources[resource_name.to_lower()] = display.current_amount

func _get_display_for_resource(resource_name: String):
	match resource_name.to_lower():
		"gold":
			return gold_display
		"steel":
			return steel_display
		"spice":
			return spice_display
		"aether":
			return aether_display
	return null

# Function to show/hide the menu
func toggle_visibility():
	visible = !visible
	
#Utilized DeepSeek for GodotScript programming assistance
