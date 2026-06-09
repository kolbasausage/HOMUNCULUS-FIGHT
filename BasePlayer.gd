extends Sprite2D
class_name BasePlayer

@onready var energy_bar = $"../PlayerEnergyBar"
@export var enemy_hp_bar: TextureProgressBar
@export var character_data: CharacterData
@onready var anim_player = $PlayerAnimation
@onready var marker1 = $"../PlayerEnergyBarCover/PlayerEnergyMarker1"
@onready var marker2 = $"../PlayerEnergyBarCover/PlayerEnergyMarker2"
@onready var marker3 = $"../PlayerEnergyBarCover/PlayerEnergyMarker3"

var BAR_TOP_Y = 80.0
var BAR_BOTTOM_Y = 751.0
var BAR_CENTER_X = 135.0
var is_dead = false
var is_attacking = false
var original_scale: Vector2

func _place_marker(marker, cost):
	var ratio = float(cost) / 100.0
	marker.global_position.x = BAR_CENTER_X
	marker.global_position.y = BAR_BOTTOM_Y - ((BAR_BOTTOM_Y - BAR_TOP_Y) * ratio)

func _ready():
	original_scale = scale
	_place_markers()
	$"../PlayerHPBar".player_died.connect(_on_death)

func _place_markers():
	_place_marker(marker1, character_data.basic_attack_cost)
	_place_marker(marker2, character_data.heal_cost)
	_place_marker(marker3, character_data.ultimate_cost)

func _physics_process(_delta):
	if is_dead:
		return
	try_attack()
	if not get_parent().battle_busy and not is_attacking and anim_player.animation != character_data.hurt_anim:
		anim_player.play(character_data.idle_anim)

func try_attack():
	if is_dead or is_attacking or get_parent().battle_busy:
		return
	if Input.is_action_just_pressed("Ability_1"):
		is_attacking = true
		get_parent().battle_busy = true
		await ability_1()
		is_attacking = false
		get_parent().battle_busy = false
	elif Input.is_action_just_pressed("Ability_2"):
		is_attacking = true
		get_parent().battle_busy = true
		await ability_2()
		is_attacking = false
		get_parent().battle_busy = false
	elif Input.is_action_just_pressed("Ability_3"):
		is_attacking = true
		get_parent().battle_busy = true
		await ability_3()
		is_attacking = false
		get_parent().battle_busy = false

func ability_1():
	pass

func ability_2():
	pass

func ability_3():
	pass

func _on_death():
	is_dead = true
	is_attacking = true
	print("death started")
	if character_data.death_anim != "":
		anim_player.play(character_data.death_anim)
	await get_tree().create_timer(2.0).timeout
	print("death finished")
	get_parent().player_loses()

func play_attack_sound():
	if character_data.attack_sound != null:
		var audio = AudioStreamPlayer.new()
		audio.stream = character_data.attack_sound
		audio.volume_db = character_data.attack_sound_volume
		add_child(audio)
		audio.play()
		audio.finished.connect(audio.queue_free)

func play_hurt():
	is_attacking = true
	anim_player.play(character_data.hurt_anim)
	if character_data.hurt_sound != null:
		var audio = AudioStreamPlayer.new()
		audio.stream = character_data.hurt_sound
		add_child(audio)
		audio.play()
		audio.finished.connect(audio.queue_free)
	get_tree().create_timer(0.5).timeout.connect(func():
		print("hurt timer fired")
		if not is_instance_valid(self) or is_dead:
			return
		is_attacking = false
		anim_player.play(character_data.idle_anim))

func squish():
	scale = original_scale * Vector2(1.2, 0.8)
	get_tree().create_timer(0.3).timeout.connect(_on_squish_finished)

func _on_squish_finished():
	scale = original_scale

func attack_move():
	var original_pos = position
	position += Vector2(300, 0)
	await get_tree().create_timer(0.2).timeout
	position = original_pos
