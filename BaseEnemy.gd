extends BaseCharacter
class_name BaseEnemy

@onready var energy_bar = $"../EnemyEnergyBar"
@export var player_hp_bar: TextureProgressBar
@export var enemy_data: EnemyData
@onready var anim_enemy = $EnemyAnimation
@onready var emarker1 = $"../EnemyEnergyBarCover/EnemyEnergyMarker1"
@onready var emarker2 = $"../EnemyEnergyBarCover/EnemyEnergyMarker2"
@onready var emarker3 = $"../EnemyEnergyBarCover/EnemyEnergyMarker3"

var home_position: Vector2
var is_stunned = false
var stun_timer = 0.0
var stun_icon = null


func _ready():
	# call base setup to set up effect and ability components
	setup_character()
	randomize()
	original_scale = scale
	_place_emarkers()
	random_attack_loop()
	$"../EnemyHPBar".enemy_died.connect(_on_death)
	call_deferred("_store_home")

func _store_home():
	home_position = position

func attack_move():
	position += Vector2(-300, 0)
	await get_tree().create_timer(0.2).timeout
	position = home_position

func apply_mutation(m: MutationData):
	mutation = m
	var hp_bar = get_parent().get_node("EnemyHPBar")
	hp_bar.max_value *= m.hp_multiplier
	hp_bar.enemy_hp = hp_bar.max_value
	hp_bar.value = hp_bar.max_value
	energy_bar.energy_speed *= m.energy_regen_multiplier

func apply_effect(effect_data):
	if effect_manager:
		effect_manager.apply_effect(effect_data)

func get_damage_multiplier():
	if effect_manager:
		return effect_manager.damage_multiplier()
	return 1.0

var original_scale: Vector2
var is_attacking := false
var is_dead = false
var EBAR_TOP_Y = 80.0
var EBAR_BOTTOM_Y = 751.0
var EBAR_CENTER_X = 1752.0 + 37.0

func _place_emarker(marker, cost):
	var ratio = float(cost) / 100.0
	marker.global_position.x = EBAR_CENTER_X
	marker.global_position.y = EBAR_BOTTOM_Y - ((EBAR_BOTTOM_Y - EBAR_TOP_Y) * ratio)

func _place_emarkers():
	var markers = [emarker1, emarker2, emarker3]
	for i in range(markers.size()):
		if i < enemy_data.ability_costs.size():
			_place_emarker(markers[i], enemy_data.ability_costs[i])
		else:
			markers[i].hide()

func _on_death():
	is_dead = true
	is_attacking = true

	var s = AudioStreamPlayer.new()
	s.stream = preload("res://death animation.wav")   # ← your sound here
	add_child(s)
	s.play(0.6)

	anim_enemy.play(enemy_data.death_anim)
	await anim_enemy.animation_finished
	get_parent().player_wins()
	
func _physics_process(delta):
	if is_dead:
		return

	# tick status effects
	if effect_manager:
		effect_manager.tick(delta)

	if is_stunned:
		stun_timer -= delta
		if stun_timer <= 0:
			is_stunned = false
			is_attacking = false
			anim_enemy.play(enemy_data.idle_anim)
		return
	if not is_attacking:
		anim_enemy.play(enemy_data.idle_anim)


func random_attack_loop() -> void:
	while true:
		var wait_time = randf_range(0.5, 2.5)
		await get_tree().create_timer(wait_time, false).timeout
		if get_tree().paused or is_dead:
			return
		print("loop tick, is_stunned: ", is_stunned)
		if is_stunned:
			continue
		try_attack()

func show_stun_icon():
	var icon = Sprite2D.new()
	icon.texture = preload("res://stun_icon.png")
	icon.position = Vector2(1370, 280)
	icon.scale = Vector2(0.7, 0.7)
	get_tree().root.add_child(icon)

	stun_icon = icon

	await get_tree().create_timer(4).timeout

	if icon:
		icon.queue_free()


func try_attack():
	if get_parent().get_node("PlayerHPBar").is_dead:
		return
	if get_parent().get_node("EnemyHPBar").is_dead:
		return
	if get_parent().battle_busy or is_attacking:
		return
	decide_attack()
	if is_stunned:
		return


func decide_attack():
	pass


func play_hurt():
	is_attacking = true
	anim_enemy.play(enemy_data.hurt_anim)

	SFX.play_enemy_hurt()

	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	tween.tween_property(self, "modulate", Color.RED, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)

	var original_pos = position
	tween.tween_property(self, "position", original_pos + Vector2(10, 0), 0.05)
	tween.tween_property(self, "position", original_pos + Vector2(-10, 0), 0.05)
	tween.tween_property(self, "position", original_pos + Vector2(10, 0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)

	get_tree().create_timer(0.5).timeout.connect(func():
		if not is_instance_valid(self) or is_dead:
			return
		is_attacking = false
		anim_enemy.play(enemy_data.idle_anim))
		
func apply_stun(duration):
	print("STUN APPLIED, duration: ", duration, " is_stunned: ", is_stunned)
	if is_dead:
		return
	is_stunned = true
	stun_timer = duration
	is_attacking = true
	show_stun_icon()


func squish():
	scale = original_scale * Vector2(1.2, 0.8)
	get_tree().create_timer(0.3).timeout.connect(_on_squish_finished)

func _on_squish_finished():
	scale = original_scale

	
var shield_hp = 0.0

func take_hit(amount: float):
	if shield_hp > 0:
		var overflow = amount - shield_hp
		shield_hp -= amount
		shield_hp = max(shield_hp, 0)
		if overflow > 0:
			get_parent().get_node("EnemyHPBar").take_damage(overflow)
	else:
		get_parent().get_node("EnemyHPBar").take_damage(amount)
	
	# Vampiric heal when player hits enemy
	var player = get_parent().get_node("Player")
	if player.mutation and player.mutation.vampiric_heal > 0:
		get_parent().get_node("PlayerHPBar").heal(player.mutation.vampiric_heal)
		

		
func show_ability_icon(texture: Texture2D):
	if texture == null:
		return
	var icon = Sprite2D.new()
	icon.texture = texture
	icon.global_position = global_position + Vector2(0, -150)
	get_tree().root.add_child(icon)
	var tween = icon.create_tween()
	tween.tween_property(icon, "modulate:a", 0.0, 0.8)
	tween.tween_callback(icon.queue_free)
