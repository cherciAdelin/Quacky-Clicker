extends Control

## --------------- VARIABLES ---------------

## signal used to communicate with the main script

signal StartPressed
@onready var door = $Door
@onready var credits = $Credits
@onready var toplayer = $TopLayer
@onready var firstLabel = $"Credits/1stLabel"
@onready var secondLabel = $"Credits/2ndLabel"



## --------------- FUNCTIONS ---------------

## this function animates the door in the main menu

func open_door():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	door.scale = Vector2(1, 1)
	tween.tween_property(door, "scale:x", 0.1, 0.4)
	
	await get_tree().create_timer(3).timeout
	var tween2 = create_tween()
	tween2.tween_property(door, "scale:x", 1, 0.1)


func intro_credits():
	
	toplayer.visible = true
	credits.visible = true
	await get_tree().create_timer(1).timeout
	var tween := create_tween()
	tween.tween_property(toplayer, "color", Color(0.0, 0.0, 0.0, 0.0), 1)
	await get_tree().create_timer(2).timeout
	tween = create_tween()
	tween.tween_property(firstLabel, "modulate:a", 0.0, 1)
	tween.tween_property(secondLabel, "modulate:a", 1.0, 1)
	await get_tree().create_timer(3).timeout
	tween = create_tween()
	tween.tween_property(toplayer, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	tween.tween_property(credits, "modulate:a", 0.0, 0.1)
	await get_tree().create_timer(1).timeout
	tween = create_tween()
	tween.tween_property(toplayer, "color", Color(0.0, 0.0, 0.0, 0.0), 1)
	await get_tree().create_timer(1).timeout
	toplayer.visible = false
	credits.visible = false


## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

func _ready():
	intro_credits()

## this function triggers when you press the exit button in the main menu
## it closes the program

func _on_exit_button_pressed() -> void:
	get_tree().quit()


## this function triggers when you press the start button
## it animates the door opening and sends a signal to the main
## script which takes you to the main game from the main menu

func _on_start_button_pressed() -> void:
	$Buttons/StartButton.disabled = true
	open_door()
	await get_tree().create_timer(0.1).timeout
	StartPressed.emit()
	await get_tree().create_timer(1.5).timeout
	$Buttons/StartButton.disabled = false
	
	
	## duck speaks when you first start the game
	
	if(!Global.main_menu_tutorial_dialogue_seen):
		await get_tree().create_timer(1).timeout
		await Global.duck.speak(Global.text_monologue["Tutorial"][1], true)
		Global.duck.speak(Global.text_monologue["Tutorial"][2], false)
		Global.main_menu_tutorial_dialogue_seen = true
