extends Sprite2D
@onready var energy_bar = $"../EnemyEnergyBar" #Path to enemy's energy node
@export var player_hp_bar: TextureProgressBar #Reference to player's HP bar (set in inspector)
@onready var anim_enemy = $EnemyAnimation #Enemy animation player
var original_scale: Vector2 #Stores original scale for squish effect
var is_attacking := false #Guard to prevent overlapping attacks

func _ready(): #Called when node enters the scene
	randomize() #Randomizes the seed for randf_range
	original_scale = scale #Save original scale before any squish
	random_attack_loop() #Start the attack timer loop
	print(player_hp_bar) #Debug: confirm hp bar is linked

func _physics_process(delta): #Called every frame
	anim_enemy.play("angrysam_idle") #Always idle

func random_attack_loop() -> void:
	while true:
		var wait_time = randf_range(1.0, 5.0)
		await get_tree().create_timer(wait_time, false).timeout  # false = respects pause
		if get_tree().paused:  # extra safety check
			return
		try_attack()

func try_attack(): #Checks conditions before allowing an attack
	if get_parent().battle_busy or is_attacking: #Skip if battle is busy or already attacking
		return
	if energy_bar.has_enough(25): #Check if enemy has enough energy to attack
		attack() #Trigger the attack
		energy_bar.energy -= 25 #Deduct energy cost
	else:
		print("Enemy attempted his attack but appeared to be exhausted") #Debug: not enough energy

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
	position += Vector2(-200, 0) #Lunge left toward the player
	await get_tree().create_timer(0.7).timeout #Hold lunge position for 0.7 seconds
	position = original_pos #Snap back to original position
