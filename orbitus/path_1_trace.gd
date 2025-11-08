extends Line2D

@onready var path_2d = get_parent() # Assuming Line2D is a child of Path2D

func _ready():
	# Set Line2D properties (color, width)
	default_color = Color(0.0, 0.171, 1.0, 1.0) # White, opaque
	width = 5 # Adjust as needed

		# Add points from the Path2D's curve
	if path_2d and path_2d.curve:
		for point in path_2d.curve.get_baked_points():
			add_point(point) # Add points in local space
