extends Resource
class_name ActiveEffect

var data: EffectData = null
var remaining: float = 0.0

func init(effect_data: EffectData) -> void:
	data = effect_data
	remaining = effect_data.duration

func is_alive() -> bool:
	# permanent effects (duration == 0) are considered alive
	return data != null and (data.duration == 0.0 or remaining > 0.0)
