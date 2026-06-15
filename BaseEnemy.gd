extends Sprite2D
class_name BaseEnemy

@onready var energy_bar = $"../EnemyEnergyBar"
@export var player_hp_bar: TextureProgressBar
@export var enemy_data: EnemyData
@onready var anim_enemy = $EnemyAnimation
@onready var emarker1 = $"../EnemyEnergyBarCover/EnemyEnergyMarker1"
@onready var emarker2 = $"../EnemyEnergyBarCover/EnemyEnergyMarker2"
@onready var emarker3 = $"../EnemyEnergyBarCover/EnemyEnergyMarker3"

var mutation: MutationData = null

func apply_mutation(m: MutationData):
	mutation = m
	# Apply HP multiplier
	var hp_bar = $EnemyHPBar
	hp_bar.max_value *= m.hp_multiplier
	hp_bar.value = hp_bar.max_value
	# Apply energy regen multiplier
	energy_bar.energy_speed *= m.energy_regen_multiplier

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
	_place_emarker(emarker1, enemy_data.attack_cost)
	_place_emarker(emarker2, enemy_data.heavy_attack_cost)
	emarker3.hide()

func _ready():
	randomize()
	original_scale = scale
	_place_emarkers()
	random_attack_loop()
	$"../EnemyHPBar".enemy_died.connect(_on_death)

func _on_death():
	is_dead = true
	is_attacking = true
	anim_enemy.play(enemy_data.death_anim)
	await anim_enemy.animation_finished
	get_parent().player_wins()

func _physics_process(_delta):
	if is_dead:
		return
	if not is_attacking:
		anim_enemy.play(enemy_data.idle_anim)

func random_attack_loop() -> void:
	while true:
		var wait_time = randf_range(0.5, 2.5)
		await get_tree().create_timer(wait_time, false).timeout
		if get_tree().paused or is_dead:
			return
		try_attack()

func try_attack():
	if get_parent().get_node("PlayerHPBar").is_dead:
		return
	if get_parent().get_node("EnemyHPBar").is_dead:
		return
	if get_parent().battle_busy or is_attacking:
		return
	decide_attack()

func decide_attack():
	pass

func play_attack_sound():
	if enemy_data.attack_sound != null:
		var audio = AudioStreamPlayer.new()
		audio.stream = enemy_data.attack_sound
		audio.volume_db = enemy_data.attack_sound_volume
		add_child(audio)
		audio.play()
		audio.finished.connect(audio.queue_free)

func play_hurt():
	is_attacking = true
	anim_enemy.play(enemy_data.hurt_anim)
	if enemy_data.hurt_sound != null:
		var audio = AudioStreamPlayer.new()
		audio.stream = enemy_data.hurt_sound
		audio.volume_db = enemy_data.hurt_sound_volume
		add_child(audio)
		audio.play()
		audio.finished.connect(audio.queue_free)
	get_tree().create_timer(0.5).timeout.connect(func():
		if not is_instance_valid(self) or is_dead:
			return
		is_attacking = false
		anim_enemy.play(enemy_data.idle_anim))


func squish():
	scale = original_scale * Vector2(1.2, 0.8)
	get_tree().create_timer(0.3).timeout.connect(_on_squish_finished)

func _on_squish_finished():
	scale = original_scale

func attack_move():
	var original_pos = position
	position += Vector2(-300, 0)
	await get_tree().create_timer(1).timeout
	position = original_pos
