extends Resource
class_name MutationData

@export var mutation_name: String = ""
@export var description: String = ""
@export var mutation_icon: Texture2D


# Stat modifiers (multipliers, so 1.5 = +50%, 0.7 = -30%)
@export var hp_multiplier: float = 1.0
@export var damage_multiplier: float = 1.0
@export var energy_cost_multiplier: float = 1.0
@export var energy_regen_multiplier: float = 1.0

# Special effects
@export var vampiric_heal: float = 0.0  # HP healed per attack
@export var hp_regen: float = 0.0       # HP per second
@export var hp_drain: float = 0.0       # HP lost per second
