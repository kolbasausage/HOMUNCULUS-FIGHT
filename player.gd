extends Sprite2D

@onready var energy_bar = $"../PlayerEnergyBar"  #path to my energy node
@export var enemy_hp_bar: TextureProgressBar #Enemy HP Bar

var original_scale: Vector2 #Original scale of the sprite

func _ready():
	original_scale = scale

#Processes attack input
func _process(_delta: float) -> void: 
	if Input.is_action_just_pressed("ui_right"):
		try_attack()

#Attack when theres enough energy
func try_attack():
	if energy_bar.has_enough(20):
		attack()
		energy_bar.energy -= 20  # or energy_bar.consume(20)
	else:
		print("Not enough energy")

#Squish effect when the homunculus attacks
func squish():
	scale = original_scale * Vector2(1.2, 0.8)
	
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(_on_squish_finished) #Timer that resets back to his original scale after 0.1 sec

func _on_squish_finished():
	scale = original_scale #Reset back function
	
func attack():
	print("Player attacks!") #Just to make sure the attack registered
	enemy_hp_bar.take_damage(20) #deals 20 damage to enemy
	squish() #Squish effect when attack func happens
	await attack_move()
	
func attack_move():
	var original_pos = position #Variable of original position
	
	position += Vector2(400, 0)  # Move right to make it look like Homunculus attacks close range
	
	await get_tree().create_timer(0.2).timeout #Timer 0.2 seconds before sprite moves back
	
	position = original_pos #Return to original position
