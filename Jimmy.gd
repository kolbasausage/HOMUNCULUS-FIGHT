extends BasePlayer

func _ready():
	# call base class _ready to ensure EffectManager is created
	BasePlayer._ready(self)
	# Demo: apply Poison to the enemy after 1s so effects can be tested quickly
	get_tree().create_timer(1.0).timeout.connect(func():
		var enemy = get_parent().get_node("Enemy")
		if enemy:
			enemy.apply_effect(preload("res://effects/Poison.tres"))
			print("Applied Poison to enemy for testing")
	)

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
		var heal_amount = get_parent().get_node("PlayerHPBar").max_value * (character_data.heal_amount / 100.0)
		$"../PlayerHPBar".heal(heal_amount)
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

		var enemy = get_parent().get_node("Enemy")
		print("ULTIMATE HIT ENEMY =", enemy)

		enemy.apply_stun(4)
		# also apply Stun effect resource for any effect-system driven logic
		enemy.apply_effect(preload("res://effects/Stun.tres"))
		enemy.take_hit(damage)

		squish()
		await attack_move()
	else:
		print("Not enough energy for ultimate")
