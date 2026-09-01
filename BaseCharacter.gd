extends Sprite2D
class_name BaseCharacter

# Shared character base for players and enemies
var effect_manager = null
var ability_executor = null
var mutation: MutationData = null
var is_dead = false
var is_attacking = false
var original_scale: Vector2

# RPG stats
@export var dodge: float = 0.1
@export var ultimate_charge: int = 0
@export var ultimate_required: int = 3

func _ready():
	original_scale = scale
	# ensure per-character EffectManager
	if not has_node("EffectManager"):
		var em = preload("res://EffectManager.gd").new()
		em.name = "EffectManager"
		add_child(em)
	effect_manager = get_node("EffectManager")
	# Ability executor component
	if not has_node("AbilityExecutor"):
		var ae = preload("res://AbilityExecutor.gd").new()
		ae.name = "AbilityExecutor"
		add_child(ae)
	ability_executor = get_node("AbilityExecutor")

func _physics_process(delta):
	if is_dead:
		return
	if effect_manager:
		effect_manager.tick(delta)

func apply_effect(effect_data):
	if effect_manager:
		effect_manager.apply_effect(effect_data)

func get_damage_multiplier():
	if effect_manager:
		return effect_manager.damage_multiplier()
	return 1.0

func take_hit(amount: float):
	# dodge check
	if randf() < dodge:
		print(name, "dodged the attack!")
		return
	# find HP bar
	var hp_bar_path = "../PlayerHPBar" if name == "Player" else "../EnemyHPBar"
	var hp_bar = get_node_or_null(hp_bar_path)
	if hp_bar:
		hp_bar.take_damage(amount)
	else:
		print("No HP bar found for", name)

func gain_ultimate_charge(amount: int=1):
	ultimate_charge += amount
	if ultimate_charge >= ultimate_required:
		print(name, "ultimate ready!")

func consume_ultimate_charge():
	ultimate_charge = 0
