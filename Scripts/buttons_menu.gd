extends Control

## --------------- VARIABLES ---------------

## signals used to communicate with the main script

signal clickMenuOpen
signal duckMenuOpen
signal questMenuOpen
signal optionsMenuOpen
signal statsMenuOpen


## variables used for manipulating the buttons

@onready var clickMenu = $HBoxContainer/ClickUpMenu
@onready var duckMenu = $HBoxContainer/DuckUpMenu
@onready var questMenu = $HBoxContainer/QuestMenu
@onready var optionsMenu = $HBoxContainer/OptionsMenu
@onready var statsMenu = $HBoxContainer/StatsMenu
@onready var menu_movement_sfx = $MenuMovementSFX




## --------------- FUNCTIONS TRIGGERED BY BUTTONS FROM THE CURRENT SCENE ---------------

## all of them do the same thing but for different buttons
## they disable the button after you press it so you can't just keep pressing 
## it and potentially break something
## then they emit their corresponding signal to the main script so it can then do its thing
## and send another signal to the corresponding scene (menu) 

func _on_click_up_menu_pressed() -> void:
	clickMenu.disabled = true
	clickMenuOpen.emit()
	menu_movement_sfx.play()

func _on_duck_up_menu_pressed() -> void:
	duckMenu.disabled = true
	duckMenuOpen.emit()
	menu_movement_sfx.play()

func _on_quest_menu_pressed() -> void:
	questMenu.disabled = true
	questMenuOpen.emit()
	menu_movement_sfx.play()

func _on_options_menu_pressed() -> void:
	optionsMenu.disabled = true
	optionsMenuOpen.emit()

func _on_stats_menu_pressed() -> void:
	statsMenu.disabled = true
	statsMenuOpen.emit()
	menu_movement_sfx.play()


## these functions re-activate the buttons after the corresponding menu has been closed
## the signals come from the main script which sends them whenever you close one of the menus

func _on_main_click_menu_close() -> void:
	clickMenu.disabled = false
	menu_movement_sfx.play()

func _on_main_duck_menu_close() -> void:
	duckMenu.disabled = false
	menu_movement_sfx.play()

func _on_main_quest_menu_close() -> void:
	questMenu.disabled = false
	menu_movement_sfx.play()

func _on_main_options_menu_close() -> void:
	optionsMenu.disabled = false

func _on_main_stats_menu_close() -> void:
	statsMenu.disabled = false
	menu_movement_sfx.play()
