extends Area2D

## --------------- VARIABLES ---------------

## signals used to communicate with the main script

signal egg
signal autoclickUnlock


## variables for:
## - the egg's max and current health
## - the number of eggs broken required for the egg max health threshold increase
## - the number of eggs broken required for the autoclick upgrade menu to be unlocked
## - current_stage used for the egg sprite change 

var egg_health := 100.0
var max_egg_health := 100.0
var egg_threshold := 10
var eggs_broken_threshold := 5
var current_stage := 4


## @export variables are the particle scenes used for the click and break animations
## sprite and egg colision are used to manipulate the nodes of the egg
## egg textures is a dictionary that holds the egg %health thresholds and their corresponding sprites

@export var clickAnimation: PackedScene
@export var breakParticles: PackedScene
@onready var sprite = $egg_sprite
@onready var egg_collision = $egg_collision_shape
@onready var egg_textures := {
	100:	preload("res://Assets/Sprites/Egg/Egg_full.png"),
	75:		preload("res://Assets/Sprites/Egg/Egg_cracked1.png"),
	50:		preload("res://Assets/Sprites/Egg/Egg_cracked2.png"),
	25:		preload("res://Assets/Sprites/Egg/Egg_cracked3.png"),
	0:		preload("res://Assets/Sprites/Egg/Egg_broken.png"),
}





## --------------- FUNCTIONS FOR EGG MANIPULATION ---------------

## function that is triggered whenever the egg is clicked
## when the hitbox detects the "left_click" input
## it calls all the required functions like:
## - function that triggers an animation where you click
## - function that increases the global currency based on how much dmg was dealt to the egg
## - function that changes the egg's health
## - function that animates the egg's sprite after it's been hit

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if(event.is_action_pressed("left_click")):
		Global.click_number += 1
		animate_click()
		gain_money()
		take_dmg(Global.click_value)
		egg_dmg_animation()


## function that increases the number of broken eggs
## checks if the number of eggs broken has reached the threshold and if it did
## it emits a signal to the main script that unlocks the autoclick menu

func egg_broken() -> void:
	Global.eggsBroken += 1
	if Global.eggsBroken == eggs_broken_threshold:
		autoclickUnlock.emit()
	egg.emit()


## function that increases the currency value based on how much damage was dealt to the egg
## (based on the global click value)
## it calls the show_dmg function which creates a popup that shows how much money the player has gained
## it emits a signal to the main script that triggers a UI update

func gain_money() -> void:
	Global.currency += Global.click_value
	Global.total_currency += Global.click_value
	show_dmg(Global.click_value,sprite.position)
	egg.emit()


## function that randomly increases the eggshells of the player based
## on the lower/upper limits. It generates a number between the lower and the upper limit
## and increases the eggshell currency value by that amount

func gain_eggshells(multiplier: float, lowerLimit: int, upperLimit: int):
	var eggshellsGained := randi_range(lowerLimit, upperLimit) * multiplier
	Global.eggshell_currency += int(eggshellsGained)
	Global.total_eggshell_currency += int(eggshellsGained)


## function that manipulates the egg's health
## if the egg's health is lower than 0
## it disables the hitbox so the player can't gain more broken eggs while the 
## code sequence is executed
## it sets the egg health to 0 so the sprite changes to the right one
## it calls the broken egg function, resets the egg then re-enables the hitbox

func take_dmg(amount:float):
	egg_health = clamp(egg_health - amount, -1, max_egg_health)
	var percent := (egg_health / max_egg_health) * 100
	if(egg_health < 0):
		$egg_hp.text = "Egg health: 0.0%"
		egg_collision.disabled = true
		egg_health = 0
		change_sprite()
		await get_tree().create_timer(0.1).timeout
		egg_broken()
		reset_egg()
		egg_collision.disabled = false
	else:
		$egg_hp.text = "Egg health: " + String.num(percent, 2) + "%"
		change_sprite()


## function that resets the health of the egg, its health stage and its texture
## it also checks if the number of broken eggs has reached the threshold and it increases the
## max health threshold accordingly

func reset_egg():
	if(Global.eggsBroken >= egg_threshold):
		max_egg_health *= 10
		egg_threshold *= 10
	egg_health = int(max_egg_health)
	$egg_hp.text = "Egg health: 100.0%"
	current_stage = 4
	sprite.texture = egg_textures[100]


## function that changes the egg's sprite whenever it hits the %health thresholds
## it also triggers a particle effect when it changes the sprite
## and gives a random amount of eggshells 

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


## function that changes the cursor's sprite

func change_cursor_sprite(texture: Texture2D):
	Input.set_custom_mouse_cursor(texture, Input.CURSOR_ARROW, Vector2(0, 0))


## function that triggers a particle effect when you click

func animate_click():
	var click := clickAnimation.instantiate()
	click.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(click)
	click.emitting = true
	click.finished.connect(click.queue_free)


## function that triggers a particle effect at random positions (used for the autoclicker)

func animate_autoclick():
	var autoclick := clickAnimation.instantiate()
	var coord_x := randf_range(-50, 50)
	var coord_y := randf_range(-100, 100) 
	autoclick.global_position = sprite.global_position + Vector2(coord_x, coord_y)
	get_tree().current_scene.add_child(autoclick)
	autoclick.emitting = true
	autoclick.finished.connect(autoclick.queue_free)


## function that makes the egg's sprite slightly smaller then turns it back to normal

func egg_dmg_animation():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1)


## function that triggers a particle effect of eggshells exploding (used when the egg's sprite changes)

func break_animation():
	var particle := breakParticles.instantiate()
	particle.global_position = sprite.global_position
	get_tree().current_scene.add_child(particle)
	particle.emitting = true
	particle.finished.connect(particle.queue_free)


## function that creates a +value popup at random locations which shows how much money you've gained

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





## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## function that triggers whenever the autoclick timer finishes 
## triggers a particle effect at random positions
## damages the egg
## increases the currency based on the autoclick value
## emits the signal to the main script that updates the UI

func _on_autoclicker_timeout() -> void:
	animate_autoclick()
	take_dmg(Global.autoclick_value)
	Global.currency += Global.autoclick_value
	Global.total_currency += Global.autoclick_value
	egg.emit()


## function triggered when the mounse enters the egg's hitbox
## it changes the cursor's sprite
## it makes the egg slightly larger

func _on_mouse_entered() -> void:
	change_cursor_sprite(Global.current_cursor_texture)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1.1, 1.1), 0.1)


## function triggered when the mouse exits the egg's hitbox
## it changes the cursor back to the original sprite
## it makes the egg turn back to normal

func _on_mouse_exited() -> void:
	change_cursor_sprite(null)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1)


## function triggered by a signal sent by the autoclick menu that 
## starts the autoclicker timer

func _on_autoclick_up_menu_start_autoclicker() -> void:
	$autoclicker.start(0.5)
