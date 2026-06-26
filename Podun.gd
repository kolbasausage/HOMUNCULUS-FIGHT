extends BaseEnemy
func decide_attack():
	if energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost

func attack():
	is_attacking = true
	player_hp_bar.take_damage(enemy_data.attack_damage)
	squish()
	await attack_move()
	is_attacking = false
