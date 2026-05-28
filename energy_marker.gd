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
	
	# Use the texture size instead of node size
	var bar_texture = energy_bar.texture_under
	if bar_texture == null:
		return
	
	var bar_width = bar_texture.get_width()
	var bar_height = bar_texture.get_height()
	var ratio = cost / energy_bar.max_value
	
	global_position.x = energy_bar.global_position.x + (bar_width * ratio)
	global_position.y = energy_bar.global_position.y + (bar_height / 2.0)
