extends BaseEnemy

func decide_attack():
	var enemy_hp = get_parent().get_node("EnemyHPBar").enemy_hp
	var max_hp = get_parent().get_node("EnemyHPBar").max_value
	var hp_percent = enemy_hp / max_hp
	
	# Shield chance increases as HP gets lower
	var shield_chance = 0.3  # 30% base chance
	if hp_percent < 0.5:
		shield_chance = 0.6  # 60% when below half HP
	if hp_percent < 0.25:
		shield_chance = 0.9  # 90% when nearly dead
	
	if shield_hp <= 0 and energy_bar.has_enough(enemy_data.heavy_attack_cost):
		if randf() < shield_chance:
			activate_shield()
			energy_bar.energy -= enemy_data.heavy_attack_cost
			return
	
	if energy_bar.has_enough(enemy_data.attack_cost):
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
