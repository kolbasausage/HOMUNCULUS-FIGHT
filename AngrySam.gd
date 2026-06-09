extends BaseEnemy

func decide_attack():
	var player_hp = get_parent().get_node("PlayerHPBar").player_hp
	if player_hp <= 40 and energy_bar.has_enough(enemy_data.heavy_attack_cost):
		heavy_attack()
		energy_bar.energy -= enemy_data.heavy_attack_cost
	elif energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost

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
