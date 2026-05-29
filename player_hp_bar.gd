extends TextureProgressBar

var player_hp: float = 100

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = player_hp

func take_damage(amount: float):
	player_hp -= amount
	player_hp = max(player_hp, 0)
	value = player_hp
	print("HP: ", player_hp)
	if player_hp <= 0:
		die()

func heal(amount):
	player_hp += amount
	
	# Clamp HP between 0 and max_value
	player_hp = clamp(player_hp, 0, max_value)
	
	# Update the visible bar immediately
	value = player_hp
	
signal player_died

var is_dead = false

func die():
	if is_dead:
		return
	is_dead = true
	print("die() called!")
	print("Player node: ", get_parent().get_node("Player"))
	get_parent().get_node("Player")._on_death()
