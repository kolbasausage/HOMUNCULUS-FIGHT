extends Sprite2D
@onready var energy_bar = $"../EnemyEnergyBar" #Path to enemy's energy node
@export var player_hp_bar: TextureProgressBar #Reference to player's HP bar (set in inspector)
@onready var anim_enemy = $EnemyAnimation #Enemy animation player
@onready var emarker1 = $"../EnemyEnergyBarCover/EnemyEnergyMarker1"
@onready var emarker2 = $"../EnemyEnergyBarCover/EnemyEnergyMarker2"
@onready var emarker3 = $"../EnemyEnergyBarCover/EnemyEnergyMarker3"
var original_scale: Vector2 #Stores original scale for squish effect
var is_attacking := false #Guard to prevent overlapping attacks

var EBAR_TOP_Y = 80.0
var EBAR_BOTTOM_Y = 751.0
var EBAR_CENTER_X = 1752.0 + 37.0  # bar x + half bar width

func _place_emarker(marker, cost):
	var ratio = float(cost) / 100.0
	marker.global_position.x = EBAR_CENTER_X
	marker.global_position.y = EBAR_BOTTOM_Y - ((EBAR_BOTTOM_Y - EBAR_TOP_Y) * ratio)

func _place_emarkers():
	_place_emarker(emarker1, 25)
	_place_emarker(emarker2, 50)
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
	anim_enemy.play("death_animation")
	await anim_enemy.animation_finished
	get_parent().player_wins()

var is_dead = false

func _physics_process(_delta):
	if is_dead:
		return
	anim_enemy.play("angrysam_idle")



func random_attack_loop() -> void:
	while true:
		var wait_time = randf_range(0.5, 2.5)  # faster than before
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
	
	var player_hp = get_parent().get_node("PlayerHPBar").player_hp
	
	if player_hp <= 40 and energy_bar.has_enough(50):
		heavy_attack()
		energy_bar.energy -= 50
	elif energy_bar.has_enough(25):
		attack()
		energy_bar.energy -= 25

func heavy_attack():
	is_attacking = true
	print("Enemy HEAVY ATTACK!")
	player_hp_bar.take_damage(40)  # double damage
	squish()
	await attack_move()
	is_attacking = false

func squish(): #Brief squish animation on attack
	scale = original_scale * Vector2(1.2, 0.8) #Squish horizontally, compress vertically
	var timer = get_tree().create_timer(0.3) #Hold squish for 0.3 seconds
	timer.timeout.connect(_on_squish_finished) #Restore scale after timer

func _on_squish_finished(): #Called when squish timer ends
	scale = original_scale #Reset to original scale

func attack(): #Handles the full attack sequence
	is_attacking = true #Lock to prevent overlapping attacks
	print("Enemy attacks!") #Debug: attack triggered
	player_hp_bar.take_damage(20) #Deal 20 damage to player
	squish() #Play squish effect
	await attack_move() #Wait for movement animation to finish
	is_attacking = false #Unlock after attack completes

func attack_move(): #Movement during attack
	var original_pos = position #Store original position to return to
	position += Vector2(-300, 0) #Lunge left toward the player
	await get_tree().create_timer(1).timeout #Hold lunge position for 0.7 seconds
	position = original_pos #Snap back to original position
