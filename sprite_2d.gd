extends Sprite2D

@export var energy_bar: TextureProgressBar
var bar_top: float = 120.0
var bar_bottom: float = 750.0

func _ready():
	_update_position()

func _process(_delta):
	if get_parent().get_parent().battle_busy:
		return
	_update_position()

func _update_position():
	if energy_bar == null:
		return
	var ratio = 1.0 - (energy_bar.energy / energy_bar.max_value)
	global_position.y = bar_top + ((bar_bottom - bar_top) * ratio)
