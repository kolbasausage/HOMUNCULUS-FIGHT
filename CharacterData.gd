extends Resource
class_name CharacterData


@export var character_name: String = ""
@export var max_hp: float = 100
@export var max_energy: float = 100

# Ability costs
@export var basic_attack_cost: float = 25
@export var heal_cost: float = 45
@export var ultimate_cost: float = 75

# Ability values
@export var basic_attack_damage: float = 20
@export var heal_amount: float = 50
@export var ultimate_damage: float = 60

# Animation names
@export var idle_anim: String = ""
@export var hurt_anim: String = ""
@export var death_anim: String = ""
@export var attack_anim: String = ""
