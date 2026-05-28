extends Sprite2D

@export var energy_bar: TextureProgressBar
@export var energy_cost: float = 25.0

func _ready():

	var ratio = energy_cost / energy_bar.max_value

	var bar_height = energy_bar.size.y

	position.y = energy_bar.position.y + (bar_height * (1.0 - ratio))
