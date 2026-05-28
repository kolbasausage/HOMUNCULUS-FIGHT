extends Sprite2D

@export var energy_bar: TextureProgressBar
@export var cost: float = 25.0

func _ready():
	_update_position()

func _process(_delta):
	_update_position()

func _update_position():
	if energy_bar == null:
		return
	var ratio = 1.0 - (cost / energy_bar.max_value)
	global_position.x = 173.0 + 37.0  # bar x + half of 75px width
	global_position.y = 104.0 + (450.0 * ratio)
