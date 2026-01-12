extends Control

## --------------- VARIABLES ---------------

## signal used to communicate with the main script

signal StartPressed
@onready var door = $Door


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


## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

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
