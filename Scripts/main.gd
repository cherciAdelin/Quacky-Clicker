extends Node2D

	## Variables

## variables that hold the score, damage-per-click, number of eggs broken
## the cost of the damage upgrades and the current upgrade dmg value
var points := 0.0
var click_value := 1.0
var eggs_broken := 0
var up_cost := 50
var up_val := 1.0

## first line creates the connection between this script and the egg script
## second line updates every value and label the moment you run the program
func _ready() -> void:
	$Egg.main = self
	update_ui()

	## Egg functions

## the signal you get from the egg collision shape when you click it
## it increases the "Currency" you have and also updates the UI
func _on_egg_egg_pressed() -> void:
	points += click_value
	show_dmg(click_value, $Egg.global_position)
	update_ui()

## updates every label on-screen with the latest values
func update_ui():
	$UI/Score.text = "Money: " + str(int(points)) + "$"
	$UI/Click_val.text = "Click value: " + str(click_value)
	$UI/Upgrade1.text = "CLICK UPGRADE: " + str(up_cost) + " $$$"

## the signal you get when the egg health drops below 0
## it increases the number of eggs broken and provides a 20% bonus to your current points
func _on_egg_egg_broken() -> void:
	eggs_broken += 1
	points += int(points*0.2)
	update_ui()
	
	## Upgrade button functions

## the signal you get when you press the upgrade button
## it either tells you you don't have enough currency to upgrade or
## subtracts the upgrade cost from your current currency, increases the cost of the next upgrade
## increases the damage you deal to the egg and displays appropriate messages for each case
func _on_upgrade_1_pressed() -> void:
	if(points < up_cost):
		$UI/Upgrade1.text = "Insufficient currency!"
		await get_tree().create_timer(2.0).timeout
		update_ui()
	else:
		points -= up_cost
		up_cost += up_cost + 50
		up_clickval_flat()
		$UI/Upgrade1.text = "Upgrade succesful!"
		await get_tree().create_timer(2.0).timeout
		update_ui()

## increases the damage you deal to the egg and increases the next upgrade value by 0.1
func up_clickval_flat():
	click_value += up_val
	up_val += 0.1
	update_ui()

## Dmg popup function. It first creates the text(var pop), generates a random position
## loads the font, sets the text to the click value, adds the font and changes the font size
## sets the position with the "origin" which is the position of the egg then adds the random coordinates
## changes the color and adds it to the main scene with add_child. After all that it uses tweens for the 
## popup and fading animations
func show_dmg(dmg_val: float, origin: Vector2):
	var pop = Label.new()
	var pos_x = randf_range(-60, 20)
	var pos_y = randf_range(-30, 30)
	var font = FontFile.new()
	
	font.load_dynamic_font("res://Assets/Sprites/Fonts/Cute Dino.ttf")
	pop.text = "+ " + str(dmg_val) + "$"
	pop.add_theme_font_override("font", font)
	pop.add_theme_font_size_override("font_size", 46)
	pop.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	pop.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	pop.add_theme_constant_override("outline_size", 3)
	pop.global_position = origin + Vector2(pos_x, pos_y)
	add_child(pop)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pop, "position:y", pop.position.y - 30, 0.3)
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	tween.tween_property(pop, "scale", Vector2.ZERO, 0.6)
	tween.connect("finished", Callable(pop, "queue_free"))
