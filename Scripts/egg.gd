extends Area2D

signal egg
signal autoclickUnlock

var egg_health := 100.0
var max_egg_health := 100.0
var egg_threshold := 10

@export var breakParticles: PackedScene
@onready var sprite = $egg_sprite
@onready var egg_textures := {
	100:	preload("res://Assets/Sprites/Egg/Egg_full.png"),
	75:		preload("res://Assets/Sprites/Egg/Egg_cracked1.png"),
	50:		preload("res://Assets/Sprites/Egg/Egg_cracked2.png"),
	25:		preload("res://Assets/Sprites/Egg/Egg_cracked3.png"),
	0:		preload("res://Assets/Sprites/Egg/Egg_broken.png"),
}

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if(event.is_action_pressed("left_click")):
		egg_press()
		var damage = Global.click_value
		take_dmg(damage)
		animate_tween()

func egg_press() -> void:
	Global.currency += Global.click_value
	show_dmg(Global.click_value,sprite.position)
	egg.emit()

func show_dmg(dmg_val: float, origin: Vector2):
	var pop = Label.new()
	var pos_x = randf_range(-400, 100)
	var pos_y = randf_range(-150, 150)
	var font = FontFile.new()
	
	font.load_dynamic_font("res://Assets/Sprites/Fonts/Cute Dino.ttf")
	pop.text = "+ " + str(dmg_val) + "$"
	pop.add_theme_font_override("font", font)
	pop.add_theme_font_size_override("font_size", 300)
	pop.add_theme_color_override("font_color", Color(0.0, 0.914, 0.0, 1.0))
	pop.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	pop.add_theme_constant_override("outline_size", 70)
	pop.global_position = origin + Vector2(pos_x, pos_y)
	add_child(pop)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pop, "position:y", pop.position.y - 30, 0.3)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(pop, "scale", Vector2.ZERO, 0.6)
	tween.finished.connect(pop.queue_free)


func take_dmg(amount:float):
	egg_health = clamp(egg_health - amount, -1, max_egg_health)
	var percent := (egg_health / max_egg_health) * 100
	if(egg_health < 0):
		$egg_hp.text = "Egg health: 0.0%"
	else:
		$egg_hp.text = "Egg health: " + String.num(percent, 2) + "%"
	change_sprite()
	if(egg_health < 0):
		egg_health = 0
		change_sprite()
		await get_tree().create_timer(0.3).timeout
		egg_broken()
		reset_egg()


func egg_broken() -> void:
	Global.eggsBroken += 1
	Global.currency += int(Global.currency*0.2)
	if Global.eggsBroken == 5:
		autoclickUnlock.emit()
		$autoclicker.start(0.5)
	egg.emit()

func gain_eggshells(multiplier: float, lowerLimit: int, upperLimit: int):
	var eggshellsGained := randi_range(lowerLimit, upperLimit) * multiplier
	Global.eggshell_currency += int(eggshellsGained)

func break_animation():
	var particle := breakParticles.instantiate()
	particle.global_position = sprite.global_position
	get_tree().current_scene.add_child(particle)
	particle.emitting = true
	particle.finished.connect(particle.queue_free)

var current_stage := 4

func change_sprite():
	var percent: float
	var thresholds = [0, 25, 50, 75, 100]
	percent = (egg_health / max_egg_health) * 100
	
	for i in thresholds.size():
		if(percent <= thresholds[i]):
			if(i != current_stage):
				current_stage = i
				break_animation()
				sprite.texture = egg_textures[thresholds[i]]
				gain_eggshells(Global.eggshell_multiplier, Global.eggshell_lower_limit, Global.eggshell_upper_limit)
			break


func reset_egg():
	if(Global.eggsBroken >= egg_threshold):
		max_egg_health *= 10
		egg_threshold *= 10
	egg_health = int(max_egg_health)
	$egg_hp.text = "Egg health: 100.0%"
	current_stage = 4
	sprite.texture = egg_textures[100]


func animate_tween():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1)


func _on_autoclicker_timeout() -> void:
	take_dmg(Global.autoclick_value)
	Global.currency += Global.autoclick_value
	egg.emit()


func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1.1, 1.1), 0.1)


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1)
