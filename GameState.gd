extends Node

var levels_unlocked = 1
var bus_position_x: float = 0.0
var next_fight_scene: String = ""
var current_mutation: MutationData = null

func reset():
	levels_unlocked = 1
	bus_position_x = 0.0
	next_fight_scene = ""
	current_mutation = null
