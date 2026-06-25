extends Control

func _ready():
	hide()

func show_result(text: String, won: bool):
	show()
	$Panel/ResultLabel.text = text
	

func _on_path_map_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://PathMap.tscn")
