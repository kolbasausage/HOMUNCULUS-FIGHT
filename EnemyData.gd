extends Resource
class_name EnemyData

@export var ability2_icon: Texture2D
@export var enemy_name: String = ""
@export var max_hp: float = 100

# Attack values
@export var attack_damage: float = 20
@export var attack_cost: float = 25
@export var heavy_attack_damage: float = 40
@export var heavy_attack_cost: float = 50
@export var attack_cooldown: float = 2.0

# Animation names
@export var idle_anim: String = ""
@export var hurt_anim: String = ""
@export var death_anim: String = ""
@export var attack_anim: String = ""

@export var hurt_sound: AudioStream
@export var hurt_sound_volume: float = 0.0

@export var attack_sound: AudioStream
@export var attack_sound_volume: float = 0.0
