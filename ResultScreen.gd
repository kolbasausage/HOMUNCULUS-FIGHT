extends Control

func _ready():
	hide()

func show_result(text: String, won: bool):
	show()
	$Panel/ResultLabel.text = text
	
func _on_restart_pressed():
	print("restart pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Fight_scene.tscn")

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://BinLad_scene.tscn")

func _on_path_map_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://PathMap.tscn")
