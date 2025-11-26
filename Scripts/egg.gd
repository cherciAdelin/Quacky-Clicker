extends Area2D

	## Variables

## signals for when you click/break the egg that trigger functions
## in the main script
signal egg_pressed
signal egg_broken
signal egg_autoclick

## variables that are used to manipulate the health of the egg
var egg_health := 100.0
var max_egg_health := 100.0
## variable used in a function that checks if you have broken the
## required number of eggs. If the threshold is reached, the max health
## of the egg grows by *10
var egg_threshold := 10

## sprite has easy access to the sprite2d
@onready var sprite = $egg_sprite
##preloads the textures for the egg at the start of the program
@onready var egg_textures := {
	100:	preload("res://Assets/Sprites/Egg/Egg_full.png"),
	75:		preload("res://Assets/Sprites/Egg/Egg_cracked1.png"),
	50:		preload("res://Assets/Sprites/Egg/Egg_cracked2.png"),
	25:		preload("res://Assets/Sprites/Egg/Egg_cracked3.png"),
	0:		preload("res://Assets/Sprites/Egg/Egg_broken.png"),
}


	##EGG

## when you click the egg it triggers every command in this function
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if(event.is_action_pressed("left_click")):
		egg_pressed.emit()
		var damage = Global.click_value
		take_dmg(damage)
		animate_tween()


	## egg health

## sets the health between -1 and max_egg_health which updates based on the number
## of eggs broken, updates the egg sprite when the egg reaches 75%, 
## 50%, 25%, 0% health and when the egg health drops below 0 it resets the egg
func take_dmg(amount:float):
	egg_health = clamp(egg_health - amount, -1, max_egg_health)
	$egg_hp.text = "Egg health: " + str(int(egg_health))
	change_sprite()
	if(egg_health < 0):
		egg_broken.emit()
		reset_egg()


	## sprite manipulation

## function that changes sprites based on the %health left which is calculated in 
## the "percent" variable with the formula below
func change_sprite():
	var percent: float
	var threshholds = [0, 25, 50, 75, 100]
	
	percent = (egg_health / max_egg_health) * 100
	
	for i in threshholds:
		if(percent <= i):
			sprite.texture = egg_textures[i]
			break


## function that resets the health and sprite of the egg and it
## increases the %maxhealth of the egg if a certain number of eggs have been
## broken
func reset_egg():
	if(Global.eggsBroken >= egg_threshold):
		max_egg_health *= 10
		egg_threshold *= 10
	egg_health = int(max_egg_health)
	$egg_hp.text = "Egg health: " + str(egg_health)
	sprite.texture = egg_textures[100]


## function that changes the size of the sprite to create the illusion of the
## egg bouncing when you click it
func animate_tween():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1)


func _on_upgrade_menu_autoclicker_change() -> void:
	while(1):
		await get_tree().create_timer(1).timeout
		take_dmg(Global.upgrades["autoclicker"]["value"])
		Global.currency += Global.upgrades["autoclicker"]["value"]
		egg_autoclick.emit()
