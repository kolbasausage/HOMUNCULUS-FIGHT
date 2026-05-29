extends TextureProgressBar

var player_hp: float = 100

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = player_hp

func take_damage(amount: float):
	player_hp -= amount
	player_hp = max(player_hp, 0) # prevent negative HP
	value = player_hp

	
	if player_hp <= 0:
		die()

func heal(amount):
	player_hp += amount
	
	# Clamp HP between 0 and max_value
	player_hp = clamp(player_hp, 0, max_value)
	
	# Update the visible bar immediately
	value = player_hp
	
signal player_died

func die():
	emit_signal("player_died")
