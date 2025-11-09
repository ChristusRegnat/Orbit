extends Node2D

@onready var BuyShip1Button = $MarginContainer/PurchaseButtonContainer
@onready var BuyGun1Button = $MarginContainer/PurchaseButtonContainer2
@onready var container = $MarginContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load icons with error handling
	var ShipToBuy: Texture2D = _load_icon("res://Assets/cargo empty.png")
	var GunToBuy: Texture2D = _load_icon("res://Assets/gunC_still.png")
	var gold_icon = _load_icon("res://Assets/Resources/gold.png")
	var crystal_icon = _load_icon("res://Assets/Resources/kyber_2.png")
	var spice_icon = _load_icon("res://Assets/Resources/spice_resized.png")
	var aether_icon = _load_icon("res://Assets/Resources/aether_resized.png")
	
	# Set the image for the purchased item
	BuyShip1Button.set_purchase_image(ShipToBuy)
	BuyGun1Button.set_purchase_image(GunToBuy)

	# Set the PriceText to the appropriate value
	BuyShip1Button.set_price_text("1", "2")
	BuyGun1Button.set_price_text("2", "1")

	# Set the currencies for the prices
	BuyShip1Button.set_currencies(gold_icon, spice_icon)
	BuyGun1Button.set_currencies(crystal_icon, aether_icon)
	
	for item in container.get_children():
		if item.has_signal("item_button_pressed"):
			item.item_button_pressed.connect(Callable(self, "_on_item_button_pressed"))


# Helper function to load icons with error handling
func _load_icon(path: String) -> Texture2D:
	var texture = load(path)
	if texture == null:
		print("ERROR: Could not load icon from path: ", path)
		# Create a placeholder texture for missing icons
		var placeholder = ImageTexture.create_from_image(Image.create(32, 32, false, Image.FORMAT_RGBA8))
		return placeholder
	return texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Indicate which UI button was pressed
func _on_item_button_pressed(item_instance: Node) -> void:
	match item_instance:
		BuyShip1Button:
			print("Buy ship")
		BuyGun1Button:
			print("Buy gun")
