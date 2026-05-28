extends Sprite2D

@export var hp_bar: TextureProgressBar

var base_scale: Vector2

func _ready():
	base_scale = scale

func _process(delta):
	if hp_bar == null:
		return
	
	var hp_percent = hp_bar.player_hp / hp_bar.max_value
	var beat_speed = lerp(1.5, 6.0, 1.0 - hp_percent)
	var pulse_amount = lerp(0.05, 0.3, 1.0 - hp_percent)
	
	var t = Time.get_ticks_msec() * 0.001 * beat_speed
	
	# Two bumps per beat — big bump then small bump (tuk-tuk)
	var beat1 = max(0.0, sin(t * 3.14159)) 
	var beat2 = max(0.0, sin(t * 3.14159 - 1.2)) * 0.5
	var pulse = (beat1 + beat2) * pulse_amount
	
	scale.x = base_scale.x * (1.0 - pulse)
	scale.y = base_scale.y * (1.0 + pulse * 0.8)
