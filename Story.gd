extends Control

@onready var story_label: Label = $StoryLabel
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var skip_label: Label = $SkipLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

var full_text := "Once upon a time in the Republic of Ash, u lightened with the dream of becoming the HFC champion - Homunculus Fighting Championship. Ur broke ass rents a van to go adventure and earn the title of absolute champion. So you fight your way up through the streets, back alleys and weird places to earn enough rep to get noticed. Each fight is you proving yourself to underground fight promoters."
var typing_speed := 0.06
var is_typing := true
var skip_alpha := 0.0
var fade_speed := 1.5

func _ready():
	anim.play("Fade_in")

	story_label.text = ""
	story_label.add_theme_color_override("font_color", Color.WHITE)

	skip_label.visible = true
	skip_label.add_theme_color_override("font_color", Color.WHITE)
	skip_label.modulate.a = 0.0

	audio.stream = load("res://story.wav")
	audio.play(0.3)

	await get_tree().create_timer(1.0).timeout
	start_typing()

func start_typing():
	is_typing = true
	story_label.text = ""
	reveal_text()

func reveal_text():
	for i in full_text.length():
		if not is_typing:
			break
		story_label.text = full_text.substr(0, i + 1)
		await get_tree().create_timer(typing_speed).timeout

	story_label.text = full_text
	is_typing = false

func _input(event):
	if event.is_pressed():
		if is_typing:
			is_typing = false
		else:
			fade_and_exit()

func _process(_delta):
	if not audio.playing and not is_typing:
		fade_and_exit()
	skip_alpha = abs(sin(Time.get_ticks_msec() * 0.002))
	skip_label.modulate.a = skip_alpha

	skip_label.modulate.a = skip_alpha

var exiting := false

func fade_and_exit():
	if exiting:
		return
	exiting = true

	anim.play("Fade Out")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://PathMap.tscn")
