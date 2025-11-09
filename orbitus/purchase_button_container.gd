extends Node2D

@onready var button: TextureButton = $PurchaceButtonMargin/PurchaseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Set the Texture Button texture to the provided textures
func set_purchase_image(new_texture: Texture2D) -> void:
	$PurchaceButtonMargin/PurchaseButton.texture_normal = new_texture

# Set the PriceText to the provided values
func set_price_text(first_price: String, second_price: String) -> void:
	$PriceButtonMargin/PriceText.text = " " + first_price + "x    " + second_price + "x"

# Set the currency textures to the provided textures
func set_currencies(new_texture_1: Texture2D, new_texture_2: Texture2D) -> void:
	$PriceButtonMargin/Currency1.texture = new_texture_1
	$PriceButtonMargin/Currency2.texture = new_texture_2

# Purchase the appropriate item when the button is pressed.
signal item_button_pressed(item_instance: Node)

func _on_button_pressed() -> void:
	emit_signal("item_button_pressed", self)
