extends Node2D

@onready var bus = $Bus
@onready var prompt_label = $CanvasLayer/PromptLabel

var bus_speed = 400.0
var stop_positions = [900, 1800]
var proximity = 100.0
var current_stop_index = -1

func _ready():
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
	elif Input.is_action_pressed("ui_left"):
		bus.position.x -= bus_speed * delta
		$Bus/AnimatedSprite2D.play("Moving_Bus")
	else:
		$Bus/AnimatedSprite2D.play("Idle_Bus")

	# Check if near a stop
	var near_stop = false
	for i in range(stop_positions.size()):
		if abs(bus.position.x - stop_positions[i]) < proximity:
			near_stop = true
			current_stop_index = i
			if Input.is_action_just_pressed("ui_accept"):
				get_tree().change_scene_to_file("res://Fight_scene.tscn")

	prompt_label.visible = near_stop
