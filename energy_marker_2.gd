extends Sprite2D

# Energy cost where the marker should appear.
# Example: 20 = marker appears at 20% of the bar.
@export var energy_cost: float = 50.0

# Maximum energy in your game.
@export var max_energy: float = 100.0

# Height of the energy bar in pixels.
# Measure your bar image and type the height here.
@export var bar_height: float = 400.0

func _ready():
	# Convert energy cost (0-100) into a percentage.
	var ratio = energy_cost / max_energy
	var y = bar_height * ratio
	position.y = y
