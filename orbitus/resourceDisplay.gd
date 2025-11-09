# resourceDisplay.gd
extends PanelContainer

# Resource data
var resource_name = ""
var current_amount = 0
var resource_icon: Texture2D

# Signal to communicate with parent menu
signal resource_changed(resource_name, new_amount)

func _ready():
	# Set up the display
	$HBoxContainer/NameLabel.text = resource_name
	update_display()
	
	# Set the icon if we have one
	if resource_icon:
		$HBoxContainer/Icon.texture = resource_icon
	
	# Connect button signals
	$HBoxContainer/DecreaseButton.pressed.connect(_on_decrease_pressed)
	$HBoxContainer/IncreaseButton.pressed.connect(_on_increase_pressed)
	
	# Apply styling
	apply_styling()

func apply_styling():
	# Create a style box for the panel
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.1, 0.8)
	style_box.border_width_left = 2
	style_box.border_width_top = 2
	style_box.border_width_right = 2
	style_box.border_width_bottom = 2
	style_box.border_color = Color(0.3, 0.3, 0.3)
	style_box.corner_radius_top_left = 5
	style_box.corner_radius_top_right = 5
	style_box.corner_radius_bottom_right = 5
	style_box.corner_radius_bottom_left = 5
	
	# Apply the style
	add_theme_stylebox_override("panel", style_box)
	
	# Style the labels
	$HBoxContainer/NameLabel.add_theme_color_override("font_color", Color.WHITE)
	$HBoxContainer/AmountLabel.add_theme_color_override("font_color", Color.YELLOW)
	
	# Style the buttons
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(0.2, 0.2, 0.2)
	button_style.corner_radius_top_left = 3
	button_style.corner_radius_top_right = 3
	button_style.corner_radius_bottom_right = 3
	button_style.corner_radius_bottom_left = 3
	
	$HBoxContainer/DecreaseButton.add_theme_stylebox_override("normal", button_style)
	$HBoxContainer/IncreaseButton.add_theme_stylebox_override("normal", button_style)
	
	# Ensure the Icon TextureRect is visible and properly sized
	$HBoxContainer/Icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	$HBoxContainer/Icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	$HBoxContainer/Icon.custom_minimum_size = Vector2(32, 32)

func update_display():
	$HBoxContainer/AmountLabel.text = str(current_amount)

func _on_decrease_pressed():
	current_amount = max(0, current_amount - 1)
	update_display()
	print("ResourceDisplay: Decrease pressed - ", resource_name, " = ", current_amount)
	resource_changed.emit(resource_name, current_amount)
	GlobalResource.set_resource(resource_name, current_amount)
	print("Global ", GlobalResource.get_resource(resource_name))

func _on_increase_pressed():
	current_amount += 1
	update_display()
	print("ResourceDisplay: Increase pressed - ", resource_name, " = ", current_amount)
	resource_changed.emit(resource_name, current_amount)
	GlobalResource.set_resource(resource_name, current_amount)
	print("Global ", GlobalResource.get_resource(resource_name))

# Function to set the resource from outside
func set_resource(name: String, amount: int, icon: Texture2D = null):
	resource_name = name
	current_amount = amount
	resource_icon = icon
	
	if $HBoxContainer/NameLabel:
		$HBoxContainer/NameLabel.text = resource_name
		update_display()
	
	if icon and $HBoxContainer/Icon:
		$HBoxContainer/Icon.texture = icon

# Getter function for other scripts to access the current amount
func get_amount() -> int:
	return current_amount
