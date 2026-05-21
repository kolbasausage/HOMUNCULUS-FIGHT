extends Sprite2D

# Energy cost where the marker should appear.
# Example: 20 = marker appears at 20% of the bar.
@export var energy_cost: float = 20.0

# Maximum energy in your game.
@export var max_energy: float = 100.0

# Height of the energy bar in pixels.
# Measure your bar image and type the height here.
@export var bar_height: float = 400.0

func _ready():
	# Convert energy cost (0-100) into a percentage.
	var ratio = energy_cost / max_energy

	# 0 energy = bottom of the bar
	# 100 energy = top of the bar
	var y = bar_height * (1.0 - ratio)

	# Move the sprite vertically to that exact position.
	position.y = y + (texture.get_height() * scale.y / 2.0)
