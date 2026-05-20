extends Sprite2D


@export var energy_cost: float = 90.0

@export var max_energy: float = 100.0

@export var bar_height: float = 400.0

func _ready():
	var ratio = energy_cost / max_energy


	var y = bar_height * (1.0 - ratio)

	position.y = y + (texture.get_height() * scale.y / 2.0)
