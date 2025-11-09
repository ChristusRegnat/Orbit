extends CharacterBody2D

# Preload the laser beam scene
const LaserBeam = preload("res://Player/LaserBeam.tscn")

# Ship movement properties
@export var max_speed: float = 300.0
@export var acceleration: float = 800.0
@export var rotation_speed: float = 3.0
@export var drag: float = 0.95

# Shooting properties
@export var bullet_speed: float = 600.0
@export var gun_cooldown: float = 0.2

# Node references
@onready var turret_pivot = $TurretPivot
@onready var muzzle = $TurretPivot/Turret/Muzzle
@onready var gun_cooldown_timer = $GunCooldownTimer
@onready var ship_sprite = $Sprite2D

# Input state
var move_direction: Vector2 = Vector2.ZERO
var rotation_direction: float = 0.0
var can_shoot: bool = true

func _ready():
	print("Ship script loaded")
	gun_cooldown_timer.wait_time = gun_cooldown
	gun_cooldown_timer.timeout.connect(_on_gun_cooldown_timeout)

func _physics_process(delta):
	# Get input
	_get_input()
	
	# Apply rotation
	rotation += rotation_direction * rotation_speed * delta
	
	# Apply movement
	if move_direction.length() > 0:
		velocity += move_direction.rotated(rotation) * acceleration * delta
		velocity = velocity.limit_length(max_speed)
	else:
		# Apply drag when not accelerating
		velocity *= drag
	
	# Move the ship
	move_and_slide()
	
	# Update turret to aim at mouse
	_aim_turret()

func _get_input():
	# Reset input
	move_direction = Vector2.ZERO
	rotation_direction = 0.0
	
	# Movement (WASD)
	if Input.is_action_pressed("Forward"):
		move_direction = Vector2.UP
		print("W pressed - moving forward")
	if Input.is_action_pressed("Back"):
		move_direction = Vector2.DOWN
		print("S pressed - moving backward")
	if Input.is_action_pressed("Left"):
		rotation_direction = -1.0
		print("A pressed - rotating left")
	if Input.is_action_pressed("Right"):
		rotation_direction = 1.0
		print("D pressed - rotating right")
	
	# Shooting (Space)
	if Input.is_action_just_pressed("Shoot"):
		print("SPACE pressed - checking if can shoot")
		if can_shoot:
			print("Can shoot - calling _shoot()")
			_shoot()
		else:
			print("Can't shoot - gun on cooldown")

func _aim_turret():
	# Get mouse position in global coordinates
	var mouse_pos = get_global_mouse_position()
	
	# Calculate angle to mouse
	var direction = (mouse_pos - turret_pivot.global_position).normalized()
	var target_angle = direction.angle()
	
	# Set turret rotation
	turret_pivot.rotation = target_angle - rotation

func _shoot():
	print("_shoot() function called")
	
	# Create a laser beam using the preloaded scene
	var laser = LaserBeam.instantiate()
	get_parent().add_child(laser)
	
	# Set laser position and rotation
	laser.global_position = muzzle.global_position
	laser.global_rotation = turret_pivot.global_rotation
	
	print("Laser created at position: ", muzzle.global_position)
	
	# Start cooldown
	can_shoot = false
	gun_cooldown_timer.start()
	
	print("Gun cooldown started")

func _on_gun_cooldown_timeout():
	print("Gun cooldown finished - can shoot again")
	can_shoot = true

# Public function to handle damage
func take_damage(amount: int):
	# Implement damage logic here
	print("Ship took ", amount, " damage!")
