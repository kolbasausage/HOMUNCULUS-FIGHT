extends TextureProgressBar

var enemy_hp: float = 100

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = enemy_hp

func take_damage(amount: float):
	print("Enemy HP bar take_damage: ", amount, " current hp: ", enemy_hp)
	enemy_hp -= amount
	enemy_hp = max(enemy_hp, 0)
	value = enemy_hp
	
	get_parent().get_node("Enemy").play_hurt() 
	
	var label = Label.new()
	label.text = str(amount)
	label.global_position = Vector2(1280, 600) + Vector2(-230, -150)
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color.RED)
	get_tree().root.add_child(label)  # add first

	var tween = label.create_tween()  # THEN create tween
	tween.tween_property(label, "position:y", label.position.y - 80, 1) 
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1)
	tween.tween_callback(label.queue_free)
	
	if enemy_hp <= 0:
		die()

signal enemy_died

var is_dead = false

func die():
	if is_dead:
		return
	is_dead = true
	print("die() called, finding enemy: ", get_parent().get_node("Enemy"))
	get_parent().get_node("Enemy")._on_death()
