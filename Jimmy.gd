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
	var enemy = get_parent().get_node("Enemy")
	var ability = preload("res://abilities/Jimmy_Basic.tres")
	if ability_executor:
		ability_executor.execute_ability(ability, enemy)
		on_hit()
		squish()
		await attack_move()
	else:
		print("No ability executor found")


func ability_2():
	var ability = preload("res://abilities/Jimmy_Heal.tres")
	if ability_executor:
		ability_executor.execute_ability(ability, null)
		squish()
	else:
		print("No ability executor found")


func ability_3():
	var ability = preload("res://abilities/Jimmy_Ultimate.tres")
	var enemy = get_parent().get_node("Enemy")
	if ability_executor:
		ability_executor.execute_ability(ability, enemy)
		# keep legacy stun and visuals
		enemy.apply_stun(4)
		enemy.apply_effect(preload("res://effects/Stun.tres"))
		squish()
		await attack_move()
	else:
		print("No ability executor found")
