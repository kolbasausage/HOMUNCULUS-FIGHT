extends Node2D

var battle_busy = false

# Character positions
const PLAYER_POS = Vector2(640, 600)
const ENEMY_POS = Vector2(1280, 600)
# Node references
@onready var player = $Player
@onready var enemy = $Enemy
@onready var player_hp_bar = $PlayerHPBar
@onready var player_energy_bar = $PlayerEnergyBar
@onready var enemy_hp_bar = $EnemyHPBar
@onready var enemy_energy_bar = $EnemyEnergyBar
@onready var result_screen = $CanvasLayer/ResultScreen

func player_wins():
	GameState.levels_unlocked += 1
	get_tree().paused = true
	result_screen.show_result("YOU WIN!", true)

func player_loses():
	get_tree().paused = true
	result_screen.show_result("YOU LOSE!", false)
	
func _ready():
	_setup_positions()
	player_hp_bar.player_hp = player.character_data.max_hp
	player_hp_bar.max_value = player.character_data.max_hp
	player_hp_bar.value = player.character_data.max_hp
	enemy_hp_bar.enemy_hp = enemy.enemy_data.max_hp
	enemy_hp_bar.max_value = enemy.enemy_data.max_hp
	enemy_hp_bar.value = enemy.enemy_data.max_hp

func _setup_positions():
	player.position = PLAYER_POS
	enemy.position = ENEMY_POS
