extends Node

# Signals for resource changes
signal resource_changed(resource_name, new_amount)
signal resources_updated(resources_dict)

# Initial resource values
var resources = {
	"gold": 0,
	"crystal": 0, 
	"spice": 0,
	"aether": 0
}

func _ready():
	print("GlobalResource autoload initialized")
	print("Starting resources: ", resources)

# === PUBLIC API ===
# These functions can be called from anywhere in your game

# Get the current amount of a resource
func get_resource(resource_name: String) -> int:
	return resources.get(resource_name.to_lower(), 0)

# Set a resource to a specific amount
func set_resource(resource_name: String, amount: int):
	var resource_key = resource_name.to_lower()
	if resources.has(resource_key):
		resources[resource_key] = max(0, amount)  # Prevent negative
		# Notify everyone that resources changed
		resource_changed.emit(resource_key, resources[resource_key])
		resources_updated.emit(resources)
		print("Resource set: ", resource_key, " = ", resources[resource_key])

# Add or subtract from a resource
func modify_resource(resource_name: String, change: int):
	var resource_key = resource_name.to_lower()
	if resources.has(resource_key):
		resources[resource_key] = max(0, resources[resource_key] + change)
		# Notify everyone that resources changed
		resource_changed.emit(resource_key, resources[resource_key])
		resources_updated.emit(resources)
		print("Resource modified: ", resource_key, " changed by ", change, " = ", resources[resource_key])

# Check if player has enough resources
func has_resources(required_resources: Dictionary) -> bool:
	for resource_type in required_resources:
		if get_resource(resource_type) < required_resources[resource_type]:
			return false
	return true

# Spend resources if player has enough
func spend_resources(cost: Dictionary) -> bool:
	if not has_resources(cost):
		print("Cannot afford: ", cost)
		return false
	
	for resource_type in cost:
		modify_resource(resource_type, -cost[resource_type])
	
	print("Successfully spent: ", cost)
	return true

# Add multiple resources at once
func add_resources(reward: Dictionary):
	for resource_type in reward:
		modify_resource(resource_type, reward[resource_type])
	
	print("Resources added: ", reward)

# Get all resources (useful for saving game)
func get_all_resources() -> Dictionary:
	return resources.duplicate()

# === DEBUG FUNCTIONS ===
# Useful for testing
func print_resources():
	print("Current resources: ", resources)

func reset_resources():
	resources = {
		"gold": 100,
		"crystal": 50,
		"spice": 25, 
		"aether": 10
	}
	resources_updated.emit(resources)
	print("Resources reset to default")
