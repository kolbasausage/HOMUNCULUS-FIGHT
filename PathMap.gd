extends Node2D

@onready var bus = $Bus
@onready var prompt_label = $CanvasLayer/PromptLabel
@onready var movement_label = $CanvasLayer/MovementLabel

var bus_speed = 400.0
var stop_positions = [900, 1800]
var proximity = 100.0
var current_stop_index = -1

func _ready():
	movement_label.visible = true
	$Bus/Camera2D/Sprite2D/AnimatedSprite2D.play("Moving_Bushes")
	$Bus/AnimatedSprite2D.play("Idle_Bus")
	_animate_building($GhettoStreetHouse)
	_animate_building($GhettoStreetHouse2)

func _animate_building(building):
	var original_pos = building.position
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(building, "scale:y", 1.15, 0.4)
	tween.parallel().tween_property(building, "position:y", original_pos.y - 20, 0.4)
	tween.tween_property(building, "scale:y", 1.0, 0.4)
	tween.parallel().tween_property(building, "position:y", original_pos.y, 0.4)

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		bus.position.x += bus_speed * delta
		$Bus/AnimatedSprite2D.play("Moving_Bus")
		movement_label.visible = false  
	elif Input.is_action_pressed("ui_left"):
		bus.position.x -= bus_speed * delta
		$Bus/AnimatedSprite2D.play("Moving_Bus")
		movement_label.visible = false
	else:
		$Bus/AnimatedSprite2D.play("Idle_Bus")

	# Check if near a stop
	var near_stop = false
	for i in range(stop_positions.size()):
		if abs(bus.position.x - stop_positions[i]) < proximity:
			near_stop = true
			current_stop_index = i
			if Input.is_action_just_pressed("ui_accept"):
				if i == 0:
					get_tree().change_scene_to_file("res://Fight_scene.tscn")
				elif i == 1:
					get_tree().change_scene_to_file("res://BinLad_scene.tscn")

	prompt_label.visible = near_stop
