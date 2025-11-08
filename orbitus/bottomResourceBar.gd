extends Control

# References to our resource displays
@onready var gold_display = $PanelContainer/HBoxContainer/ResourceDisplay
@onready var steel_display = $PanelContainer/HBoxContainer/ResourceDisplay2
@onready var spice_display = $PanelContainer/HBoxContainer/ResourceDisplay3  
@onready var aether_display = $PanelContainer/HBoxContainer/ResourceDisplay4

# Dictionary to track all resources
var resources = {}

# Signals to communicate with the rest of the game
signal resource_updated(resource_name, new_amount)
signal resources_changed(resources_dict)

func _ready():
	# Load icons with error handling
	var gold_icon = _load_icon("res://Assets/Resources/gold.png")
	var steel_icon = _load_icon("res://Assets/Resources/kyber.png")  # Note: using kyber.png for steel
	var spice_icon = _load_icon("res://Assets/Resources/spice_resized.png")
	var aether_icon = _load_icon("res://Assets/Resources/aether_resized.png")
	
	# Debug: Print what we loaded
	print("Loaded icons:")
	print(" - Gold: ", gold_icon)
	print(" - Steel: ", steel_icon)
	print(" - Spice: ", spice_icon)
	print(" - Aether: ", aether_icon)
	
	# Set up each resource display with initial values
	gold_display.set_resource("Gold", 10, gold_icon)
	steel_display.set_resource("Steel", 50, steel_icon)
	spice_display.set_resource("Spice", 25, spice_icon)
	aether_display.set_resource("Aether", 10, aether_icon)
	
	# Connect signals from each display
	gold_display.resource_changed.connect(_on_gold_changed)
	steel_display.resource_changed.connect(_on_steel_changed)
	spice_display.resource_changed.connect(_on_spice_changed)
	aether_display.resource_changed.connect(_on_aether_changed)
	
	# Initialize the resources dictionary
	update_resources_dict()

# Helper function to load icons with error handling
func _load_icon(path: String) -> Texture2D:
	var texture = load(path)
	if texture == null:
		print("ERROR: Could not load icon from path: ", path)
		# Create a placeholder texture for missing icons
		var placeholder = ImageTexture.create_from_image(Image.create(32, 32, false, Image.FORMAT_RGBA8))
		return placeholder
	return texture

func _on_gold_changed(new_amount: int):
	_on_resource_changed("gold", new_amount)

func _on_steel_changed(new_amount: int):
	_on_resource_changed("steel", new_amount)

func _on_spice_changed(new_amount: int):
	_on_resource_changed("spice", new_amount)

func _on_aether_changed(new_amount: int):
	_on_resource_changed("aether", new_amount)

func _on_resource_changed(resource_name: String, new_amount: int):
	# Update our internal tracking
	resources[resource_name] = new_amount
	
	# Emit signals for the rest of the game
	resource_updated.emit(resource_name, new_amount)
	resources_changed.emit(resources)
	
	print("Resource updated: ", resource_name, " = ", new_amount)

func update_resources_dict():
	# Initialize the dictionary with current values
	resources = {
		"gold": gold_display.get_amount(),
		"steel": steel_display.get_amount(), 
		"spice": spice_display.get_amount(),
		"aether": aether_display.get_amount()
	}

# Public API - Functions other scripts can use to interact with resources

# Get the current amount of a specific resource
func get_resource(resource_name: String) -> int:
	return resources.get(resource_name.to_lower(), 0)

# Set a specific resource to an exact amount
func set_resource(resource_name: String, amount: int):
	var display = _get_display_for_resource(resource_name)
	if display:
		display.current_amount = max(0, amount)
		display.update_display()
		resources[resource_name.to_lower()] = display.current_amount
		resource_updated.emit(resource_name.to_lower(), display.current_amount)

# Modify a resource by a certain amount (positive or negative)
func modify_resource(resource_name: String, change: int):
	var display = _get_display_for_resource(resource_name)
	if display:
		display.current_amount = max(0, display.current_amount + change)
		display.update_display()
		resources[resource_name.to_lower()] = display.current_amount
		resource_updated.emit(resource_name.to_lower(), display.current_amount)

# Check if the player has enough of specific resources
func has_resources(required_resources: Dictionary) -> bool:
	for resource_type in required_resources:
		if get_resource(resource_type) < required_resources[resource_type]:
			return false
	return true

# Spend resources if the player has enough
func spend_resources(cost: Dictionary) -> bool:
	if not has_resources(cost):
		return false
	
	for resource_type in cost:
		modify_resource(resource_type, -cost[resource_type])
	return true

# Helper function to get the display for a specific resource
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

# Function to show/hide the resource bar
func toggle_visibility():
	visible = !visible

# Get all resources as a dictionary
func get_all_resources() -> Dictionary:
	return resources.duplicate()
