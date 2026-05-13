extends Sprite2D

@onready var energy_bar = $"../EnemyEnergyBar"  #path to enemys energy node
@export var player_hp_bar: TextureProgressBar

var original_scale: Vector2

func _ready():
	randomize()
	original_scale = scale
	random_attack_loop()
	print(player_hp_bar)
	
func random_attack_loop() -> void:
	while true:
		var wait_time = randf_range(1.0, 5.0)
		await get_tree().create_timer(wait_time).timeout
		
		try_attack()

func try_attack():
	if get_parent().battle_busy:
		return
	if energy_bar.has_enough(20):
		attack()
		energy_bar.energy -= 20  #reduce energy by 20
	else:
		print("Enemy attempted his attack but appeared to be exhausted")

func squish():
	scale = original_scale * Vector2(1.2, 0.8)
	
	var timer = get_tree().create_timer(0.3)
	timer.timeout.connect(_on_squish_finished)

func _on_squish_finished():
	scale = original_scale

func attack():
	print("Enemy attacks!")
	player_hp_bar.take_damage(20)
	squish()
	await attack_move()
	
func attack_move():
	var original_pos = position #Original position
	
	position += Vector2(-200, 0) #Position the enemy sprite moves to the left
	
	await get_tree().create_timer(0.7).timeout #Timer 0.2 seconds
	
	position = original_pos #Return to original position of the sprite
