extends Sprite2D

@export var energy_bar: TextureProgressBar
@export var cost: float = 25.0
@export var marker: Sprite2D
@export var enemy: BaseEnemy

var small_scale: Vector2
var big_scale: Vector2
var can_attack = false

func _ready():
	small_scale = scale * 0.7
	big_scale = scale
	modulate = Color(0.3, 0.3, 0.3, 1.0)
	scale = small_scale

func _process(_delta):
	if energy_bar == null or enemy == null:
		return
	cost = enemy.enemy_data.ability_costs[2]
	global_position = marker.global_position + Vector2(-185, 0)
	var has_energy = energy_bar.has_enough(cost)
	if has_energy and not can_attack:
		can_attack = true
		_pop()
	elif not has_energy and can_attack:
		can_attack = false
		modulate = Color(0.3, 0.3, 0.3, 1.0)
		scale = small_scale

func _pop():
	modulate = Color(1, 1, 1, 1)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(big_scale.x * 0.7, big_scale.y * 1.4), 0.1)
	tween.tween_property(self, "scale", big_scale, 0.1)
