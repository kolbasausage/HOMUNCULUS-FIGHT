extends BaseEnemy


func decide_attack():
	if shield_hp <= 0 and energy_bar.has_enough(enemy_data.heavy_attack_cost):
		activate_shield()
		energy_bar.energy -= enemy_data.heavy_attack_cost
	elif energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost

func activate_shield():
	is_attacking = true
	shield_hp = 30.0
	show_ability_icon(enemy_data.ability2_icon)
	print("BinLad shields!")
	is_attacking = false

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
