extends Sprite2D

@onready var energy_bar = $"../PlayerEnergyBar"  #path to my energy node
@export var enemy_hp_bar: TextureProgressBar #Enemy HP Bar
@onready var anim_player = $PlayerAnimation
@onready var marker1 = $"../PlayerEnergyBarCover/EnergyMarker"
@onready var marker2 = $"../PlayerEnergyBarCover/EnergyMarker2"
@onready var marker3 = $"../PlayerEnergyBarCover/EnergyMarker3"

var BAR_TOP_Y = 80.0
var BAR_BOTTOM_Y = 751.0
var BAR_CENTER_X = 135.0


#Marker placement
func _place_marker(marker, cost):
	var ratio = float(cost) / 100.0
	marker.global_position.x = BAR_CENTER_X
	marker.global_position.y = BAR_BOTTOM_Y - ((BAR_BOTTOM_Y - BAR_TOP_Y) * ratio) 

func _ready():
	original_scale = scale
	var global_scale = energy_bar.get_global_transform().get_scale()
	var true_height = abs(global_scale.y) * 756.0
	print("True height: ", true_height)
	print("Bar global pos: ", energy_bar.global_position)
	print("Bar bottom Y: ", energy_bar.global_position.y + true_height)
	_place_markers()

#Energy % of where markers are placed
func _place_markers():
	_place_marker(marker1, 25)
	_place_marker(marker2, 45)
	_place_marker(marker3, 80)


var original_scale: Vector2 #Original scale of the sprite


func _physics_process(delta):
	if not try_attack():
		anim_player.play("moonman_idle")

#Attack when theres enough energy
func try_attack():
	if get_parent().battle_busy: #If enemy is attacking you can't attack
		return
	# Basic attack on Right Arrow (20 energy)
	if Input.is_action_just_pressed("Ability_1"):
		if energy_bar.has_enough(25):
			attack()
			energy_bar.energy -= 25
		else:
			print("Not enough energy")

	# Heal on Up Arrow (50 energy)
	if Input.is_action_just_pressed("Ability_2"):
		if energy_bar.has_enough(45):
			heal()
			energy_bar.energy -= 45
		else:
			print("Not enough energy to heal")

	# Ultimate on Left Arrow (90 energy)
	if Input.is_action_just_pressed("Ability_3"):
		if energy_bar.has_enough(80):
			ultimate()
			energy_bar.energy -= 80
		else:
			print("Not enough energy for ultimate")


func _process(_delta: float) -> void:
	try_attack()


# Heal ability connected to player hp bar
func heal():
	get_parent().battle_busy = true 
	print("Player heals!")
	$"../PlayerHPBar".heal(50)
	squish()
	get_parent().battle_busy = false

# Ultimate attack
func ultimate():
	get_parent().battle_busy = true
	print("PLAYER ULTIMATE!")
	enemy_hp_bar.take_damage(60)
	squish()
	await attack_move()
	get_parent().battle_busy = false
	
#Squish effect when the homunculus attacks
func squish():
	scale = original_scale * Vector2(1.2, 0.8)
	
	var timer = get_tree().create_timer(0.3)
	timer.timeout.connect(_on_squish_finished) 

func _on_squish_finished():
	scale = original_scale #Reset back function
	
func attack():
	get_parent().battle_busy = true #Tells the game that player is attacking therefore pauses it
	print("Player attacks!") #Just to make sure the attack registered
	enemy_hp_bar.take_damage(20) #deals 20 damage to enemy
	squish() #Squish effect when attack func happens
	await attack_move()
	get_parent().battle_busy = false #Tells the game the action is over
	
func attack_move():
	var original_pos = position #Variable of original position
	
	position += Vector2(200, 0)  # Move right to make it look like Homunculus attacks close range
	
	await get_tree().create_timer(1).timeout #Timer 0.2 seconds before sprite moves back
	
	position = original_pos #Return to original position
