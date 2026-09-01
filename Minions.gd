extends BaseEnemy
var basic_cooldown = 0.0
var heavy_cooldown = 0.0

func decide_attack():
	var player_hp = get_parent().get_node("PlayerHPBar").player_hp
	var enemy_hp = get_parent().get_node("EnemyHPBar").enemy_hp
	var max_hp = get_parent().get_node("EnemyHPBar").max_value
	var hp_percent = enemy_hp / max_hp

	# Heal instead of shield — heals when low HP
	var heal_chance = 0.0
	if hp_percent < 0.5:
		heal_chance = 0.3
	if hp_percent < 0.25:
		heal_chance = 0.6
	if energy_bar.has_enough(enemy_data.shield_cost):
		if randf() < heal_chance:
			activate_heal()
			energy_bar.energy -= enemy_data.shield_cost
			return

	# Kill shot
	if player_hp <= enemy_data.attack_damage and energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost
		return
	# Heavy attack
	if heavy_cooldown <= 0 and energy_bar.has_enough(enemy_data.heavy_attack_cost):
		heavy_attack()
		energy_bar.energy -= enemy_data.heavy_attack_cost
		heavy_cooldown = 4.0
		basic_cooldown = 2.0
		return
	# Basic attack
	if basic_cooldown <= 0 and energy_bar.has_enough(enemy_data.attack_cost):
		attack()
		energy_bar.energy -= enemy_data.attack_cost
		basic_cooldown = 3.0

func _physics_process(delta):
	super._physics_process(delta)
	basic_cooldown -= delta
	heavy_cooldown -= delta

func activate_heal():
	is_attacking = true
	$EnemyHeal.play()
	show_ability_icon(enemy_data.ability2_icon)
	get_parent().get_node("EnemyHPBar").heal(enemy_data.heavy_attack_damage)  # reuse heavy damage as heal amount
	print("Minion heals!")
	is_attacking = false

func attack():
	is_attacking = true
	print("Enemy attacks!")
	player_hp_bar.take_damage(enemy_data.attack_damage)
	squish()
	await attack_move()
	is_attacking = false

func heavy_attack():
	is_attacking = true
	print("Enemy HEAVY ATTACK!")
	player_hp_bar.take_damage(enemy_data.heavy_attack_damage)
	squish()
	await attack_move()
	is_attacking = false
