extends Control

func _ready():
	hide()

func show_result(text: String):
	show()
	$Panel/ResultLabel.text = text

func _on_restart_pressed():
	print("restart pressed")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://BinLad_scene.tscn")
