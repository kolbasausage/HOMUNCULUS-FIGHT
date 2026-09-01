extends Resource
class_name AbilityData

@export var ability_name: String = ""
@export var cost: float = 0.0
@export var damage: float = 0.0
@export var heal_percent: float = 0.0 # percent of target max HP
@export var effect: Resource # EffectData resource to apply
@export var animation: String = ""
@export var target: String = "enemy" # "enemy" or "self" or "all"
@export var cooldown: float = 0.0
@export var ultimate_charge: int = 0 # amount of ultimate charge gained when using this ability
@export var required_charge: int = 0 # if >0, this ability requires charge to be consumed
