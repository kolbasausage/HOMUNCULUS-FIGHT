extends BaseEnemy


func decide_attack():
	var enemy_hp = get_parent().get_node("EnemyHPBar").enemy_hp
	var max_hp = get_parent().get_node("EnemyHPBar").max_value
	var hp_percent = enemy_hp / max_hp

	var shield_chance = 0.3
	if hp_percent < 0.5:
		shield_chance = 0.6
	if hp_percent < 0.25:
		shield_chance = 0.9

	if shield_hp <= 0 and energy_bar.has_enough(enemy_data.shield_cost):
		if randf() < shield_chance:
			activate_shield()
			energy_bar.energy -= enemy_data.shield_cost
			return

	if energy_bar.has_enough(enemy_data.heavy_attack_cost):
		heavy_attack()
		energy_bar.energy -= enemy_data.heavy_attack_cost
		return

	if energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost

@onready var shield_icon = $ShieldIcon

func activate_shield():
	is_attacking = true
	shield_hp = 30.0
	shield_icon.visible = true
	print("BinLad shields!")
	is_attacking = false

func take_hit(amount: float):
	super.take_hit(amount)
	if shield_hp <= 0:
		shield_icon.visible = false

func attack():
	is_attacking = true
	play_attack_sound()
	print("Enemy attacks!")
	player_hp_bar.take_damage(enemy_data.attack_damage)
	squish()
	await attack_move()
	is_attacking = false

func heavy_attack():
	is_attacking = true
	play_attack_sound()
	print("Enemy HEAVY ATTACK!")
	player_hp_bar.take_damage(enemy_data.heavy_attack_damage)
	squish()
	await attack_move()
	is_attacking = false
