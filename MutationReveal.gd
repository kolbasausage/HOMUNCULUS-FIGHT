extends Node2D

@onready var medkit = $Medkit
@onready var syringes = {
	"Caffeine": $CaffeineSyringe,
	"Hyperkeratosis": $HyperkeratosisSyringe,
	"Vampirism": $VampirismSyringe
}

var opened = false

var mutations = [
	preload("res://Caffeine.tres"),
	preload("res://Hyperkeratosis.tres"),
	preload("res://Vampirism.tres")
]

func _ready():
	for s in syringes.values():
		s.visible = false
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
	var mutation = mutations[randi() % mutations.size()]
	GameState.current_mutation = mutation
	_show_syringe(mutation)

func _show_syringe(mutation):
	var syringe = syringes[mutation.mutation_name]
	syringe.position = medkit.position
	syringe.scale = Vector2.ZERO
	syringe.modulate.a = 0.0
	syringe.visible = true
	var tween = create_tween()
	tween.tween_property(syringe, "scale", Vector2.ONE, 0.5)
	tween.parallel().tween_property(syringe, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(syringe, "position", Vector2(960, 400), 0.5)
	tween.tween_property(syringe, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(syringe, "scale", Vector2.ONE, 0.1)
