extends TextureProgressBar

@export var energy_speed: float = 10
var energy: float = 0.0

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = energy

func _process(delta: float) -> void:
	energy += energy_speed * delta
	energy = clamp(energy, min_value, max_value)
	value = energy
	
func has_enough(amount: float) -> bool:
	return energy >= amount

func consume(amount: float) -> void:
	if energy >= amount:
		energy -= amount
