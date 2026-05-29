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

func _ready() -> void:
	_setup_positions()

func _setup_positions():
	player.position = PLAYER_POS
	enemy.position = ENEMY_POS

func player_wins():
	get_tree().paused = true

func player_loses():
	get_tree().paused = true
