extends Button
func _on_pressed() -> void:
	GameState.reset()
	$Click.play()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://Story.tscn")
