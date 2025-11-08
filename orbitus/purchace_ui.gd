extends Node2D

@onready var BuyShip1Button = $MarginContainer/PurchaseButtonContainer
@onready var BuyGun1Button = $MarginContainer/PurchaseButtonContainer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load icons with error handling
	var ShipToBuy: Texture2D = _load_icon("res://Assets/cargo empty.png")
	var GunToBuy: Texture2D = _load_icon("res://Assets/gunC_still.png")
	
	# Set the image for the purchased item
	BuyShip1Button.set_purchase_image(ShipToBuy)
	BuyGun1Button.set_purchase_image(GunToBuy)

	# Set the PriceText to the appropriate value
	BuyShip1Button.set_price_text(1, 1)
	BuyGun1Button.set_price_text(2, 1)


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
func _process(delta: float) -> void:
	pass
