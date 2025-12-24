extends Node2D

## variables to make the code more readable
@onready var ScoreLabel = $UI/Score
@onready var ClickValueLabel = $UI/Click_val
@onready var EggsBrLabel = $UI/EggsBr
signal up_menu

## updates every value and label the moment you run the program
func _ready() -> void:
	update_ui()

## updates every label on-screen with the latest values
func update_ui():
	ScoreLabel.text = "Money: " + str(int(Global.currency)) + "$"
	ClickValueLabel.text = "Click value: " + str(Global.click_value)
	EggsBrLabel.text = "Eggs broken: " + str(Global.eggsBroken)
	up_menu.emit()

## function that updates the UI whenever you interact with the upgrade menu
func _on_upgrade_menu_up_menu_change() -> void:
	update_ui()

func _on_egg_egg() -> void:
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

## when you press the "upgrade menu button" the upgrade menu
## slides on the screen 
func _on_up_menu_open_pressed() -> void:
	var menu = $UpgradeMenu/Control
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(menu, "position:x", menu.position.x + 1500, 1)


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
