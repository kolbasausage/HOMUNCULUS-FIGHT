extends BasePlayer

func ability_1():
	if energy_bar.has_enough(character_data.basic_attack_cost):
		anim_player.play(character_data.attack_anim)
		energy_bar.energy -= character_data.basic_attack_cost
		var damage = character_data.basic_attack_damage
		if mutation:
			damage *= mutation.damage_multiplier
		get_parent().get_node("Enemy").take_hit(damage)
		on_hit()
		squish()
		await attack_move()
	else:
		print("Not enough energy")

func ability_2():
	if energy_bar.has_enough(character_data.heal_cost):
		show_icon(preload("res://heal cross.png"), global_position + Vector2(0, 0))
		energy_bar.energy -= character_data.heal_cost
		$"../PlayerHPBar".heal(character_data.heal_amount)
		squish()
	else:
		print("Not enough energy to heal")

func ability_3():
	if energy_bar.has_enough(character_data.ultimate_cost):
		energy_bar.energy -= character_data.ultimate_cost
		anim_player.play(character_data.attack_anim)
		var damage = character_data.ultimate_damage
		if mutation:
			damage *= mutation.damage_multiplier
		get_parent().get_node("Enemy").take_hit(damage)
		squish()
		await attack_move()
	else:
		print("Not enough energy for ultimate")
