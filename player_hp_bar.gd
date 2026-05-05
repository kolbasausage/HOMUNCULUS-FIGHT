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

func die():
	print("Your homunculus died!")
	
