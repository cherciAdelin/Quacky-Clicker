extends Node2D

## variables to make the code more readable
@onready var ClickUpButton = $UpgradeMenu/Control/UpgradesContainer/VBoxContainer/click_up/UpName
@onready var ClickUpTxt = $UpgradeMenu/Control/UpgradesContainer/VBoxContainer/click_up/ClickValUpgrade
@onready var ClickUpLvL = $UpgradeMenu/Control/UpgradesContainer/VBoxContainer/click_up/LvL
@onready var AutoclickButton = $UpgradeMenu/Control/UpgradesContainer/VBoxContainer/autoclicker/UpButton
@onready var AutoclickLvL = $UpgradeMenu/Control/UpgradesContainer/VBoxContainer/autoclicker/LvL
@onready var AutoclickTxT = $UpgradeMenu/Control/UpgradesContainer/VBoxContainer/autoclicker/UpName
@onready var ScoreLabel = $UI/Score
@onready var ClickValueLabel = $UI/Click_val
@onready var EggsBrLabel = $UI/EggsBr

## updates every value and label the moment you run the program
func _ready() -> void:
	update_ui()

	## Egg functions

## the signal you get from the egg collision shape when you click it
## it increases the "Currency" you have and also updates the UI
func _on_egg_egg_pressed() -> void:
	Global.currency += Global.click_value
	show_dmg(Global.click_value, $Egg.global_position)
	update_ui()


## updates every label on-screen with the latest values
func update_ui():
	ScoreLabel.text = "Money: " + str(int(Global.currency)) + "$"
	ClickValueLabel.text = "Click value: " + str(Global.click_value)
	ClickUpButton.text = "Click Up: " + str(Global.upgrades["click_up"]["cost"]) + " $"
	ClickUpTxt.text = "$$$"
	ClickUpLvL.text = "LVL: " + str(Global.upgrades["click_up"]["level"])
	AutoclickButton.text = "$$$"
	AutoclickTxT.text = "Autoclicker: " + str(Global.upgrades["autoclicker"]["cost"]) + "$"
	AutoclickLvL.text = "LVL: " + str(Global.upgrades["autoclicker"]["level"])
	EggsBrLabel.text = "Eggs broken: " + str(Global.eggsBroken)

## the signal you get when the egg health drops below 0
## it increases the number of eggs broken and provides a 20% bonus to your current currency
func _on_egg_egg_broken() -> void:
	Global.eggsBroken += 1
	Global.currency += int(Global.currency*0.2)
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


## the signal you get from the start button in MainMenu scene
## it zooms in on the house door, screen fades to black then changes the 
## camera position to the main game and turns the brighness back on
func _on_main_menu_start_pressed() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	var tween = create_tween()
	
	tween.tween_property(camera, "position", $MainMenu/Door.global_position, 1.0)
	tween.parallel().tween_property(camera, "zoom", Vector2(3,3), 1.5)
	tween.parallel().tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	
	await get_tree().create_timer(1.5).timeout
	var tween2 = create_tween()
	
	tween2.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
	tween2.parallel().tween_property(camera, "position", $MainScreen/Background.global_position, 0.1)
	tween2.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0), 1.0)

## when you press the "upgrade menu button" the upgrade menu
## slides on the screen 
func _on_up_menu_open_pressed() -> void:
	var menu = $UpgradeMenu/Control
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(menu, "position:x", menu.position.x + 1500, 1)


## function that updates the UI whenever you interact with the upgrade menu
func _on_upgrade_menu_up_menu_change() -> void:
	update_ui()

## function that gets you back to the main menu
func _on_main_menu_button_pressed() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	var mainMenu = $MainMenu/Background
	var tween = create_tween()
	
	tween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	tween.tween_property(camera, "position", mainMenu.global_position, 0.1)
	tween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0),1)


func _on_egg_egg_autoclick() -> void:
	update_ui()
