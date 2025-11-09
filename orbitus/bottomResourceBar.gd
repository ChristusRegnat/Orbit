# bottomResourceBar.gd
extends Control

# References to our resource displays
@onready var gold_display = $PanelContainer/HBoxContainer/ResourceDisplay
@onready var crystal_display = $PanelContainer/HBoxContainer/ResourceDisplay2
@onready var spice_display = $PanelContainer/HBoxContainer/ResourceDisplay3  
@onready var aether_display = $PanelContainer/HBoxContainer/ResourceDisplay4

func _ready():
	print("=== BottomResourceBar._ready() started ===")
	
	# Test if GlobalResource exists
	if GlobalResource:
		print("GlobalResource reference is valid")
		print("GlobalResource node: ", GlobalResource)
		print("GlobalResource resources: ", GlobalResource.resources)
	else:
		print("ERROR: GlobalResource is null!")
		return
	
	# Load icons
	var gold_icon = _load_icon("res://Assets/Resources/gold.png")
	var crystal_icon = _load_icon("res://Assets/Resources/kyber_2.png") 
	var spice_icon = _load_icon("res://Assets/Resources/spice_resized.png")
	var aether_icon = _load_icon("res://Assets/Resources/aether_resized.png")
	
	print("Setting up resource displays...")
	
	# Set up each resource display with initial values FROM GLOBALRESOURCE
	gold_display.set_resource("Gold", GlobalResource.get_resource("gold"), gold_icon)
	crystal_display.set_resource("Crystal", GlobalResource.get_resource("crystal"), crystal_icon)
	spice_display.set_resource("Spice", GlobalResource.get_resource("spice"), spice_icon)
	aether_display.set_resource("Aether", GlobalResource.get_resource("aether"), aether_icon)
	
	print("Connecting signals...")
	
	# Connect signals from each display
	gold_display.resource_changed.connect(_on_gold_changed)
	crystal_display.resource_changed.connect(_on_crystal_changed)
	spice_display.resource_changed.connect(_on_spice_changed)
	aether_display.resource_changed.connect(_on_aether_changed)
	
	print("Connecting to GlobalResource signals...")
	
	# Listen to global resource changes to update display
	if GlobalResource.resource_changed.is_connected(_on_global_resource_changed):
		print("resource_changed was already connected, disconnecting first...")
		GlobalResource.resource_changed.disconnect(_on_global_resource_changed)
	
	GlobalResource.resource_changed.connect(_on_global_resource_changed)
	print("Signal connected: ", GlobalResource.resource_changed.is_connected(_on_global_resource_changed))
	
	# Test the connection by manually modifying a resource
	print("=== Testing GlobalResource connection ===")
	GlobalResource.modify_resource("gold", 1)
	
	print("=== BottomResourceBar initialization complete ===")

# Helper function to load icons with error handling
func _load_icon(path: String) -> Texture2D:
	var texture = load(path)
	if texture == null:
		print("ERROR: Could not load icon from path: ", path)
		var placeholder = ImageTexture.create_from_image(Image.create(32, 32, false, Image.FORMAT_RGBA8))
		return placeholder
	return texture

# When buttons are pressed in resource displays, call GlobalResource
func _on_gold_changed(new_amount: int):
	print("BottomResourceBar: _on_gold_changed called with amount: ", new_amount)
	GlobalResource.modify_resource("gold", new_amount)

func _on_crystal_changed(new_amount: int):
	print("BottomResourceBar: _on_crystal_changed called with amount: ", new_amount)
	GlobalResource.set_resource("crystal", new_amount)

func _on_spice_changed(new_amount: int):
	print("BottomResourceBar: _on_spice_changed called with amount: ", new_amount)
	GlobalResource.set_resource("spice", new_amount)

func _on_aether_changed(new_amount: int):
	print("BottomResourceBar: _on_aether_changed called with amount: ", new_amount)
	GlobalResource.set_resource("aether", new_amount)

# When GlobalResource resources change (from anywhere in the game), update the display
func _on_global_resource_changed(resource_name: String, new_amount: int):
	print("BottomResourceBar: _on_global_resource_changed - ", resource_name, " = ", new_amount)
	
	match resource_name:
		"gold":
			print("Updating gold display to: ", new_amount)
			gold_display.current_amount = new_amount
			gold_display.update_display()
		"crystal":
			print("Updating crystal display to: ", new_amount)
			crystal_display.current_amount = new_amount
			crystal_display.update_display()
		"spice":
			print("Updating spice display to: ", new_amount)
			spice_display.current_amount = new_amount
			spice_display.update_display()
		"aether":
			print("Updating aether display to: ", new_amount)
			aether_display.current_amount = new_amount
			aether_display.update_display()

# Function to show/hide the resource bar
func toggle_visibility():
	visible = !visible
