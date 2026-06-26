extends Button
func _on_pressed() -> void:
	GameState.reset()
	get_tree().change_scene_to_file("res://PathMap.tscn")
