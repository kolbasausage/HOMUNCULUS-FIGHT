extends Node
class_name AbilityExecutor

# Executes AbilityData resources on targets. Intended as a child of BaseCharacter.

func execute_ability(ability: AbilityData, target: Node) -> void:
	if ability == null:
		print("No ability provided")
		return
	var owner = get_parent()
	# cost handling (if owner has energy_bar)
	if owner and owner.has_node("../PlayerEnergyBar") and ability.cost > 0:
		# attempt to drain energy only for players; enemies use their own energy_bar logic
		var eb = owner.get_node("../PlayerEnergyBar")
		if eb and not eb.has_enough(ability.cost):
			print("Not enough energy for", ability.ability_name)
			return
		else:
			eb.energy -= ability.cost
	# play animation if available
	if owner and owner.has_node("PlayerAnimation") and ability.animation != "":
		var anim = owner.get_node("PlayerAnimation")
		if anim:
			anim.play(ability.animation)
	# apply damage/heal/effect
	if ability.target == "enemy" and target:
		if ability.damage > 0:
			# respect target's damage multipliers
			var dmg = ability.damage * (owner.get_damage_multiplier() if owner.has_method("get_damage_multiplier") else 1.0)
			target.take_hit(dmg)
		if ability.effect:
			target.apply_effect(ability.effect)
		if ability.heal_percent > 0 and owner:
			var hpbar = owner.get_node_or_null("../PlayerHPBar")
			if hpbar:
				hpbar.heal(hpbar.max_value * (ability.heal_percent / 100.0))
	elif ability.target == "self":
		if ability.effect and owner:
			owner.apply_effect(ability.effect)
		if ability.heal_percent > 0 and owner:
			var hpbar = owner.get_node_or_null("../PlayerHPBar")
			if hpbar:
				hpbar.heal(hpbar.max_value * (ability.heal_percent / 100.0))
	# ultimate charge handling
	if owner and ability.ultimate_charge > 0 and owner.has_method("gain_ultimate_charge"):
		owner.gain_ultimate_charge(ability.ultimate_charge)
	# consume required charge if needed
	if ability.required_charge > 0 and owner and owner.ultimate_charge >= ability.required_charge:
		# execute ultimate effect: for now, do big damage to target
		if target:
			target.take_hit(ability.damage)
		owner.consume_ultimate_charge()
