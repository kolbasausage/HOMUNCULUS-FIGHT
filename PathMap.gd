extends Node2D

@onready var bus = $Bus
@onready var prompt_label = $CanvasLayer/PromptLabel
@onready var movement_label = $CanvasLayer/MovementLabel
@onready var streets = $Streets
var bus_speed = 400.0
var stop_positions = [900, 1800, 2700, 3700]
var stop_names = ["⚔️ Angry Sam", "⚔️ BinLad", "⚔️ Samneric", "⚔️ Minions"]
var stop_scenes = ["res://Fight_scene.tscn", "res://BinLad_scene.tscn", "res://Samneric_scene.tscn", "res://Minions_scene.tscn"]
var proximity = 100.0
var current_stop_index = -1
var levels_unlocked = 1

func _ready():
	streets.play()
	levels_unlocked = GameState.levels_unlocked
	bus.position.x = GameState.bus_position_x
	$Bus/Camera2D/Sprite2D/AnimatedSprite2D.play("Moving_Bushes")
	$Bus/AnimatedSprite2D.play("Idle_Bus")
	movement_label.visible = true
	_animate_building($GhettoStreetHouse)
	_animate_building($GhettoStreetHouse2)
	_animate_building($GhettoStreetHouse3)
	_animate_building($GhettoStreetHouse4)

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

	bus.position.x = clamp(bus.position.x, 100, 7580)

	var near_stop = false
	for i in range(stop_positions.size()):
		if abs(bus.position.x - stop_positions[i]) < proximity:
			near_stop = true
			current_stop_index = i
			if i < levels_unlocked:
				prompt_label.text = "Press SPACE to enter - " + stop_names[i]
				if Input.is_action_just_pressed("ui_accept"):
					GameState.bus_position_x = bus.position.x
					GameState.next_fight_scene = stop_scenes[i]
					get_tree().change_scene_to_file("res://MutationReveal.tscn")
			else:
				prompt_label.text = "🚧 Road works - Beat previous level first!"

	prompt_label.visible = near_stop
