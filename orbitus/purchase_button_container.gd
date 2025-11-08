extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Set the Texture Button texture to the provided image
func set_purchase_image(new_texture: Texture2D) -> void:
	$MarginContainer/PurchaseButton.texture_normal = new_texture

# Set the PriceText to the provided values
func set_price_text(first_price: String, second_price: String) -> void:
	$MarginContainer/PriceText.text = first_price + "x     " + second_price + "x"
