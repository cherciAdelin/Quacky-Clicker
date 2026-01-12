extends Control

## --------------- VARIABLES ---------------

## signals used to communicate with the main script

signal optionsMenuExit
signal optionsMenuResume


## --------------- FUNCTIONS ---------------

## function used to hide the menu 

func hide_menu():
	var opMenu := $"."
	opMenu.visible = false


## --------------- FUNCTIONS TRIGGERED BY SIGNALS ---------------

## this function is triggered when you press the resume button in the 
## options menu. It hides the options button and sends a signal to the main script to
## re-enable the options button

func _on_resume_button_pressed() -> void:
	hide_menu()
	optionsMenuResume.emit()


## this function is triggered when you press the main menu button in the options
## menu. It disables the main menu button, sends a signal to the main script which
## takes you from the main game to the main menu then hides the options menu and re-enables
## the main menu button

func _on_exit_button_pressed() -> void:
	$VBoxContainer/ExitButton.disabled = true
	optionsMenuExit.emit()
	await get_tree().create_timer(1).timeout
	hide_menu()
	$VBoxContainer/ExitButton.disabled = false
