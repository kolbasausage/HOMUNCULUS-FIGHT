extends TextureProgressBar

var enemy_hp: float = 100

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = enemy_hp

func take_damage(amount: float):
	enemy_hp -= amount
	enemy_hp = max(enemy_hp, 0) # prevent negative HP
	value = enemy_hp
	
	if enemy_hp <= 0:
		die()

func die():
	print("Enemy died!")
