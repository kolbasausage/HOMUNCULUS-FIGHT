extends Resource
class_name EffectData

@export var effect_name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var duration: float = 0.0 # seconds, 0 means permanent

# Periodic effects
@export var hp_regen: float = 0.0   # HP per second
@export var hp_drain: float = 0.0  # HP lost per second

# Multipliers applied while the effect is active
@export var damage_multiplier: float = 1.0
@export var hp_multiplier: float = 1.0

# Special flags
@export var stun: float = 0.0       # instant stun duration applied when effect starts
@export var infect: bool = false
@export var infection_damage: float = 0.0
