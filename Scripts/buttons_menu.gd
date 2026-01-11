extends Control

signal clickMenuOpen
signal duckMenuOpen
signal questMenuOpen
signal optionsMenuOpen
signal statsMenuOpen
@onready var clickMenu = $HBoxContainer/ClickUpMenu
@onready var duckMenu = $HBoxContainer/DuckUpMenu
@onready var questMenu = $HBoxContainer/QuestMenu
@onready var optionsMenu = $HBoxContainer/OptionsMenu
@onready var statsMenu = $HBoxContainer/StatsMenu

func _on_click_up_menu_pressed() -> void:
	clickMenu.disabled = true
	clickMenuOpen.emit()

func _on_duck_up_menu_pressed() -> void:
	duckMenu.disabled = true
	duckMenuOpen.emit()

func _on_quest_menu_pressed() -> void:
	questMenu.disabled = true
	questMenuOpen.emit()

func _on_options_menu_pressed() -> void:
	optionsMenu.disabled = true
	optionsMenuOpen.emit()

func _on_stats_menu_pressed() -> void:
	statsMenu.disabled = true
	statsMenuOpen.emit()


func _on_main_click_menu_close() -> void:
	clickMenu.disabled = false

func _on_main_duck_menu_close() -> void:
	duckMenu.disabled = false

func _on_main_quest_menu_close() -> void:
	questMenu.disabled = false

func _on_main_options_menu_close() -> void:
	optionsMenu.disabled = false

func _on_main_stats_menu_close() -> void:
	statsMenu.disabled = false
