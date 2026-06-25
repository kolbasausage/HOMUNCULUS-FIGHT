extends Node2D

var battle_busy = false
const PLAYER_POS = Vector2(640, 600)
const ENEMY_POS = Vector2(1280, 600)

@onready var player = $Player
@onready var enemy = $Enemy
@onready var player_hp_bar = $PlayerHPBar
@onready var player_energy_bar = $PlayerEnergyBar
@onready var enemy_hp_bar = $EnemyHPBar
@onready var enemy_energy_bar = $EnemyEnergyBar
@onready var result_screen = $CanvasLayer/ResultScreen
@onready var player_mutation_icon = $PlayerMutationIcon
@onready var enemy_mutation_icon = $EnemyMutationIcon


var all_mutations = [
	preload("res://Caffeine.tres"),
	preload("res://Hyperkeratosis.tres"),
	preload("res://Vampirism.tres")
]

func _ready():
	_setup_positions()
	player_hp_bar.player_hp = player.character_data.max_hp
	player_hp_bar.max_value = player.character_data.max_hp
	player_hp_bar.value = player.character_data.max_hp
	enemy_hp_bar.enemy_hp = enemy.enemy_data.max_hp
	enemy_hp_bar.max_value = enemy.enemy_data.max_hp
	enemy_hp_bar.value = enemy.enemy_data.max_hp

	if GameState.current_mutation:
		player.apply_mutation(GameState.current_mutation)
		player_mutation_icon.texture = GameState.current_mutation.mutation_icon
	else:
		player_mutation_icon.visible = false

# Apply random mutation to enemy
	randomize()
	var random_mutation = all_mutations[randi() % all_mutations.size()]
	enemy.apply_mutation(random_mutation)
	enemy_mutation_icon.texture = random_mutation.mutation_icon
	print("Enemy mutation: ", random_mutation.mutation_name)
	

func _setup_positions():
	player.position = PLAYER_POS
	enemy.position = ENEMY_POS

func player_wins():
	GameState.levels_unlocked += 1
	get_tree().paused = true
	result_screen.show_result("YOU WIN!", true)

func player_loses():
	get_tree().paused = true
	result_screen.show_result("YOU LOSE!", false)
	GameState.reset()
