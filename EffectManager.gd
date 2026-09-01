extends Node
class_name EffectManager

# Holds ActiveEffect resources and ticks them. This node is intended to be
# added as a child of a character (BasePlayer or BaseEnemy) so it can apply
# periodic HP changes and call character methods.

var effects := []

func apply_effect(effect_data: EffectData) -> void:
	var ae = preload("res://ActiveEffect.gd").new()
	ae.init(effect_data)
	effects.append(ae)

func tick(delta: float) -> void:
	var new_effects := []
	var owner = get_parent()
	for ae in effects:
		# periodic HP regen/drain
		if ae.data.hp_regen != 0.0:
			if owner and owner.has_node("../PlayerHPBar"):
				owner.get_node("../PlayerHPBar").heal(ae.data.hp_regen * delta)
			elif owner and owner.has_node("../EnemyHPBar"):
				owner.get_node("../EnemyHPBar").heal(ae.data.hp_regen * delta)
		if ae.data.hp_drain != 0.0:
			if owner and owner.has_node("../PlayerHPBar"):
				owner.get_node("../PlayerHPBar").take_damage(ae.data.hp_drain * delta)
			elif owner and owner.has_node("../EnemyHPBar"):
				owner.get_node("../EnemyHPBar").take_damage(ae.data.hp_drain * delta)

		# infection handling (sets flags on owner)
		if ae.data.infect:
			if owner:
				owner.infected = true
				# use remaining duration if present, otherwise use a large number
				owner.infection_timer = ae.remaining if ae.data.duration > 0.0 else 99999.0
				owner.infection_damage = ae.data.infection_damage

		# stun: apply immediately to owner if owner supports apply_stun
		if ae.data.stun > 0.0 and owner and owner.has_method("apply_stun"):
			owner.apply_stun(ae.data.stun)

		# duration handling
		if ae.data.duration > 0.0:
			ae.remaining -= delta
			if ae.remaining > 0.0:
				new_effects.append(ae)
		else:
			# permanent effect
			new_effects.append(ae)

	effects = new_effects

func damage_multiplier() -> float:
	var m = 1.0
	for ae in effects:
		m *= ae.data.damage_multiplier
	return m

func hp_multiplier() -> float:
	var m = 1.0
	for ae in effects:
		m *= ae.data.hp_multiplier
	return m

func has_effect(name: String) -> bool:
	for ae in effects:
		if ae.data.effect_name == name:
			return true
	return false
