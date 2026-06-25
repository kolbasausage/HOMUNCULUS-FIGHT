extends Node

@export var enemy_hurt_sound: AudioStream
@export var player_hurt_sound: AudioStream

func _play(sound: AudioStream, volume := 0.0):
	if sound == null:
		return
	var audio = AudioStreamPlayer.new()
	audio.stream = sound
	audio.volume_db = volume
	get_tree().root.add_child(audio)
	audio.play()
	audio.finished.connect(audio.queue_free)

func play_enemy_hurt():
	_play(enemy_hurt_sound)

func play_player_hurt():
	_play(player_hurt_sound)
