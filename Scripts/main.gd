extends Node2D

## --------------- VARIABLES ---------------

## variables used to manipulate scenes in the scene tree

var currencyTween: Tween
var cameraTween: Tween
var menuTween: Tween

enum apw{FIH, WHISKEY, CAULDRON, ELIXIR}

@onready var ScoreLabel = $UI/Score
@onready var ClickValueLabel = $UI/Click_val
@onready var EggshellLabel = $UI/EggshellLabel
@onready var DisableInputLayer = $DisableInputLayer
@onready var backgroundMusic = $UI/BackgroundMusic

@onready var CloudsTimer := $UI/Clouds/CloudsTimer
@onready var CloudsStartPos := $UI/Clouds/CloudsStartPos

@onready var fih_active_up = $active_powerups/Fih_bucket
@onready var glass_active_up = $active_powerups/Whiskey_glass
@onready var cauldron_active_up = $active_powerups/Cauldron
@onready var elixir_active_Up = $active_powerups/Elixir

@onready var microwave := $UI/Decorations/Microwave
@onready var cat := $UI/Decorations/Cat
@onready var plant := $UI/Decorations/Plant
@onready var painting1 := $UI/Decorations/Painting1
@onready var painting2 := $UI/Decorations/Painting2
@onready var painting3 := $UI/Decorations/Painting3

@export var Cloud_1: PackedScene
@export var Cloud_2: PackedScene

## signals to communicate with other scenes

signal clickMenuClose
signal duckMenuClose
signal questMenuClose
signal optionsMenuClose
signal statsMenuClose
signal up_menu
signal stat_menu
signal quest_check
signal main_menu_sfx




## --------------- FUNCTIONS ---------------

## function that sets the active powerups to their default states (hidden/locked)

func set_active_powerup_default():
	fih_active_up.visible = false
	glass_active_up.visible = false
	cauldron_active_up.visible = false
	elixir_active_Up.visible = false


## function that sets the decorations to their default states (hidden/locked)

func set_decorations_default():
	microwave.visible = false
	cat.visible = false
	plant.visible = false
	painting1.visible = false
	painting2.visible = false
	painting3.visible = false


## updates everything related to stats and numbers
## sends signals to other scripts so they can update their own labels and values

func update_ui():
	ScoreLabel.text = "Money: " + str(int(Global.currency)) + "$"
	ClickValueLabel.text = "Click value: " + str(Global.click_value)
	EggshellLabel.text = "EggShells: " + str(Global.eggshell_currency)
	up_menu.emit()
	stat_menu.emit()
	quest_check.emit()


## animation for all the menus

func menu_open_animation(menu: Control, xCoord: int, tween: Tween):
	if(tween):
		tween.kill()
	tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(menu, "position:x", menu.position.x + xCoord, 1)


## function that instantiates one of the two cloud scenes 
## spawns it at a random position and makes it move at a random speed

func spawn_clouds(scene: PackedScene):
	var cloud := scene.instantiate()
	var coord_y := randf_range(-100, 100)
	cloud.global_position = CloudsStartPos.global_position + Vector2(0, coord_y)
	get_tree().current_scene.add_child(cloud)
	
	var tween := create_tween()
	var randomTime := randi_range(10, 15)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cloud, "position:x", cloud.position.x + 3000, randomTime)
	
	await get_tree().create_timer(randomTime).timeout
	cloud.queue_free()


## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## function that triggers when you run the program
## it does the UI initialization

func _ready():
	Input.set_custom_mouse_cursor(Global.default_cursor_texture, Input.CURSOR_ARROW, Vector2(0, 0))
	CloudsTimer.start(4)
	Global.set_global_variables_default()
	set_active_powerup_default()
	set_decorations_default()
	update_ui()


## these 3 functions update the UI whenever the scene which sent the signal 
## changes something related to the Global variables

func _on_autoclick_menu_change() -> void:
	update_ui()

func _on_upgrade_menu_up_menu_change() -> void:
	update_ui()

func _on_egg_egg() -> void:
	update_ui()


## SIGNAL TRIGGERED BY THE main_menu_start BUTTON FROM THE MainMenu SCENE
## animates the door then changes the tint of the screen and camera position so it 
## switches from the main menu to the main game screen 

func _on_main_menu_start_pressed() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	cameraTween = create_tween()
	
	cameraTween.tween_property(camera, "position", $MainMenu/Door.global_position, 1.0)
	cameraTween.parallel().tween_property(camera, "zoom", Vector2(3,3), 1.5)
	cameraTween.parallel().tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)

	await get_tree().create_timer(1.5).timeout
	backgroundMusic.play()
	var tween2 = create_tween()
	
	tween2.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
	tween2.parallel().tween_property(camera, "position", $MainScreen/Background.global_position, 0.1)
	tween2.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0), 1.0)


## SIGNAL TRIGGERED BY THE ActivePowerupUnlock SIGNAL SENT BY THE active_powerups SCENE
## it matches the index from the enum with one of the cases and unlocks the 
## corresponding active powerup

func _on_active_powerup_unlock(apwu: int) -> void:
	if(apwu == apw.FIH):
		fih_active_up.visible = true
	elif(apwu == apw.WHISKEY):
		glass_active_up.visible = true
	elif(apwu == apw.CAULDRON):
		cauldron_active_up.visible = true
	elif(apwu == apw.ELIXIR):
		elixir_active_Up.visible = true
	else:
		return


## SIGNAL TRIGGERED BY questComplete SIGNAL SENT BY THE QuestMenu SCENE
## it matches the number of the quest given as a parameter and 
## unlocks the corresponding decoration

func _on_quest_complete(qNumber: int) -> void:
	match qNumber:
		1:
			microwave.visible = true
		2:
			plant.visible = true
		3:
			painting1.visible = true
		4:
			cat.visible = true
		5:
			painting2.visible = true
		6:
			painting3.visible = true


## SIGNALS SENT BY THE ButtonMenu SCENE
## all of these functions open their corresponding menus

func _on_click_menu_open() -> void:
	var menu = $UpgradeMenu/Control
	menu_open_animation(menu, 1500, menuTween)

func _on_duck_menu_open() -> void:
	var menu = $autoclick_up_menu
	menu_open_animation(menu, 750, menuTween)

func _on_options_menu_open() -> void:
	var opMenu := $OptionsMenu
	opMenu.visible = true

func _on_quest_menu_open() -> void:
	var menu := $QuestMenu
	menu_open_animation(menu, 750, menuTween)

func _on_stats_menu_open() -> void:
	var menu := $StatsMenu
	menu_open_animation(menu, 750, menuTween)


## SIGNALS SENT BY DIFFERENT MENU SCENES 
## these functions send a signal to the 
## ButtonMenu so the buttons can be re-enabled

func _on_up_menu_close() -> void:
	clickMenuClose.emit()

func _on_autoclick_menu_close() -> void:
	duckMenuClose.emit()

func _on_options_menu_resume() -> void:
	optionsMenuClose.emit()


## this function is triggered when you press the main menu button
## in the options tab. It takes you back to the main menu

func _on_options_menu_exit() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	var mainMenu = $MainMenu/Background
	cameraTween = create_tween()
	
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	cameraTween.tween_property(camera, "position", mainMenu.global_position, 0.1)
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0),1)
	optionsMenuClose.emit()
	main_menu_sfx.emit()
	backgroundMusic.stop()

func _on_quest_menu_close() -> void:
	questMenuClose.emit()

func _on_stats_menu_close() -> void:
	statsMenuClose.emit()


## SIGNAL TRIGGERED BY THE CloudTimer 
## this function generates random clouds with
## random speeds and positions in the main menu

func _on_clouds_timer_timeout() -> void:
	var randCloud := randi_range(1, 2)
	if(randCloud == 1):
		spawn_clouds(Cloud_1)
	else:
		spawn_clouds(Cloud_2)


## function that stops the imputs when the duck speaks so it doesn't break the speech bubble when the speak function 
## is called multiple times (kinda inefficient but i'll change it at some point)

func _on_duck_speaking(isTrue: bool) -> void:
	if(isTrue):
		DisableInputLayer.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		DisableInputLayer.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_dev_press() -> void:
	update_ui()
