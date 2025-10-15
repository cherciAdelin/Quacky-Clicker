extends Area2D

signal egg_pressed
signal egg_broken

var egg_health := 100
const max_egg_health := 100
var main

@onready var sprite = $egg_sprite
@onready var egg_textures := {
	100:	preload("res://Assets/Sprites/Egg/Egg_full_202510151033_14760.png"),
	75:		preload("res://Assets/Sprites/Egg/Egg_cracked1_202510151033_14758.png"),
	50:		preload("res://Assets/Sprites/Egg/Egg_cracked2_202510151033_14756.png"),
	25:		preload("res://Assets/Sprites/Egg/Egg_cracked3_202510151033_14755.png"),
	0:		preload("res://Assets/Sprites/Egg/Egg_broken_202510151033_14751.png"),
}

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if(event.is_action_pressed("left_click")):
		egg_pressed.emit()
		var damage = main.click_value
		take_dmg(damage)
		animate_tween()


# egg health
func take_dmg(amount:int):
	egg_health = clamp(egg_health - amount, -1, max_egg_health)
	$egg_hp.text = "Egg health: " + str(egg_health)
	change_sprite()
	if(egg_health < 0):
		egg_broken.emit()
		reset_egg()


#sprite manipulation
func change_sprite():
	var percent := egg_health
	var threshholds = [0, 25, 50, 75, 100]
	
	for i in threshholds:
		if(percent <= i):
			sprite.texture = egg_textures[i]
			break

func reset_egg():
	egg_health = max_egg_health
	$egg_hp.text = "Egg health: " + str(max_egg_health)
	sprite.texture = egg_textures[max_egg_health]

func animate_tween():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	sprite.scale = Vector2(1, 1)
	tween.tween_property(sprite, "scale", Vector2(0.9, 0.9), 0.08)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.08)
