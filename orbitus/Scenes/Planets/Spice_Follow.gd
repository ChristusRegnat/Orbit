extends PathFollow2D
const Cargo_Ship_Scene: PackedScene = preload("res://Scenes/Planets/Spice_Ship.tscn")
@export var speed : float = 0.5
var Cargo_Active : bool = false

# Sound Preload (RENAMED to SyS)
const SyS = preload("res://Sounds/spice sound-[AudioTrimmer.com].mp3")

# Flag to ensure the sound only plays once
var halfway_sound_played: bool = false 

# === HELPER FUNCTION: Defines the sound playing logic ===
func _play_ship_sound():
	# Now checking against SyS
	if SyS == null:
		print("ERROR: SyS sound resource failed to load! Check file path.")
		return
		
	# Create a temporary AudioStreamPlayer
	var temp_player = AudioStreamPlayer.new()
	temp_player.stream = SyS
	
	# Add it to the scene tree
	add_child(temp_player)
	
	# Ensure the player cleans itself up when done (crucial for memory)
	temp_player.finished.connect(Callable(temp_player, "queue_free"))
	
	temp_player.play()
# =======================================================

func _ready():
	self.progress_ratio = 0
	Global.ShipCount -= 1
		
	
func _process(delta):
	if progress_ratio < 1:
		move(delta)
	else:
		# Runs when the ship reaches the end (progress_ratio is 1 or more)
		GlobalResource.modify_resource("Crystal", 1)
		print(GlobalResource.get_resource("Crystal"))
		Global.ShipCount += 1
		queue_free()

func move(delta):
	progress_ratio += speed * delta
	
	# === THE ADDED TRIGGER LOGIC ===
	# This checks if the ship hit the halfway mark AND if the sound hasn't played.
	if progress_ratio >= 0.5 and not halfway_sound_played:
		_play_ship_sound() 
		halfway_sound_played = true
