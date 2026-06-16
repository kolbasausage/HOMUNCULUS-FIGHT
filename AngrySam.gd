extends BaseEnemy

func decide_attack():
	var player_hp = get_parent().get_node("PlayerHPBar").player_hp
	
	# Go for the kill
	if player_hp <= 20 and energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost
		return
	if player_hp <= 40 and energy_bar.has_enough(enemy_data.heavy_attack_cost):
		heavy_attack()
		energy_bar.energy -= enemy_data.heavy_attack_cost
		return
	
	# Otherwise attack randomly
	var roll = randi() % 2
	if roll == 0 and energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost
	elif energy_bar.has_enough(enemy_data.heavy_attack_cost):
		heavy_attack()
		energy_bar.energy -= enemy_data.heavy_attack_cost

func attack():
	is_attacking = true
	play_attack_sound()
	player_hp_bar.take_damage(enemy_data.attack_damage)
	squish()
	await attack_move()
	is_attacking = false

func heavy_attack():
	is_attacking = true
	play_attack_sound()
	player_hp_bar.take_damage(enemy_data.heavy_attack_damage)
	squish()
	await attack_move()
	is_attacking = false
