extends TextureProgressBar

var player_hp: float = 100

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = player_hp

func take_damage(amount: float):
	player_hp -= amount
	player_hp = max(player_hp, 0)
	value = player_hp
	print("HP: ", player_hp)
	
	get_parent().get_node("Player").play_hurt()
	
	# Enemy vampiric heal
	var enemy = get_parent().get_node("Enemy")
	if enemy.mutation and enemy.mutation.vampiric_heal > 0:
		get_parent().get_node("EnemyHPBar").heal(enemy.mutation.vampiric_heal)
	
	var label = Label.new()
	label.text = str(amount)
	label.global_position = Vector2(640, 600) + Vector2(30, -150)
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color.RED)
	label.add_theme_font_override("font", preload("res://Super Pandora.ttf"))
	get_tree().root.add_child(label)  # add first

	var tween = label.create_tween()  # THEN create tween
	tween.tween_property(label, "position:y", label.position.y - 80, 1)  # 1 sec
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1)
	tween.tween_callback(label.queue_free)
	if player_hp <= 0:
		die()


func heal(amount):
	player_hp += amount
	
	# Clamp HP between 0 and max_value
	player_hp = clamp(player_hp, 0, max_value)
	
	# Update the visible bar immediately
	value = player_hp
	
signal player_died

var is_dead = false

func die():
	
	if is_dead:
		return
	is_dead = true
	print("die() called!")
	print("Player node: ", get_parent().get_node("Player"))
	get_parent().get_node("Player")._on_death()
