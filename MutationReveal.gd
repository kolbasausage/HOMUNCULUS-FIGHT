extends Node2D

@onready var medkit = $Medkit
var opened = false

func _ready():
	$Background.play("background")
	medkit.play("chest_fall")
	medkit.animation_finished.connect(_on_fall_finished)

func _on_fall_finished():
	medkit.play("chest_closed")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if not opened and medkit.animation == "chest_closed":
			medkit.animation_finished.disconnect(_on_fall_finished)
			medkit.play("chest_opening")
			medkit.animation_finished.connect(_on_opening_finished)
		elif opened:
			get_tree().change_scene_to_file(GameState.next_fight_scene)

func _on_opening_finished():
	medkit.play("chest_opened")
	opened = true
