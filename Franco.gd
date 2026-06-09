extends BasePlayer

func ability_1():
	if energy_bar.has_enough(character_data.basic_attack_cost):
		play_attack_sound()
		anim_player.play(character_data.attack_anim)
		energy_bar.energy -= character_data.basic_attack_cost
		enemy_hp_bar.take_damage(character_data.basic_attack_damage)
		squish()
		await attack_move()
	else:
		print("Not enough energy")

func ability_2():
	if energy_bar.has_enough(character_data.heal_cost):
		energy_bar.energy -= character_data.heal_cost
		$"../PlayerHPBar".heal(character_data.heal_amount)
		squish()
	else:
		print("Not enough energy to heal")

func ability_3():
	if energy_bar.has_enough(character_data.ultimate_cost):
		energy_bar.energy -= character_data.ultimate_cost
		anim_player.play(character_data.attack_anim)
		enemy_hp_bar.take_damage(character_data.ultimate_damage)
		squish()
		await attack_move()
	else:
		print("Not enough energy for ultimate")
