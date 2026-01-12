extends Control

## ------------ VARIABLES ------------

## variables used to manipulate the labels 

signal stats_menu_close
@onready var total_clicks := $VBoxContainer/TotalClicks
@onready var total_money := $VBoxContainer/TotalMoney
@onready var current_money := $VBoxContainer/CurrentMoney
@onready var total_eggshells := $VBoxContainer/TotalEggshells
@onready var current_eggshells := $VBoxContainer/CurrentEggshells
@onready var eggs_broken := $VBoxContainer/EggsBroken
@onready var click_value := $VBoxContainer/ClickValue
@onready var autoclick_value := $VBoxContainer/AutoclickValue
@onready var eggshell_mult := $VBoxContainer/EggshellMult
@onready var eggshell_lower := $VBoxContainer/EggshellLower
@onready var eggshell_upper := $VBoxContainer/EggshellUpper
@onready var apwcdr	:= $VBoxContainer/APWCDR
@onready var apw_mult := $VBoxContainer/APWMult
@onready var sp_up_lvl_lim := $VBoxContainer/SpUpLVLLim





## ------------ FUNCTIONS ------------

## function that sets the Global stats to each of their individual label

func set_stats():
	total_clicks.text = "Total clicks: " + str(Global.click_number)
	total_money.text = "Total money earned: " + str(int(Global.total_currency)) + "$"
	current_money.text = "Current money earned: " + str(int(Global.currency)) + "$"
	total_eggshells.text = "Total eggshells earned: " + str(Global.total_eggshell_currency) + " eggshells"
	current_eggshells.text = "Current eggshells earned: " + str(Global.eggshell_currency) + " eggshells"
	eggs_broken.text = "Total eggs broken: " + str(Global.eggsBroken)
	click_value.text = "Total click value: " + str(Global.click_value)
	autoclick_value.text = "Total autoclick value: " + str(Global.autoclick_value)
	eggshell_mult.text = "Eggshells multiplier: " + str(Global.eggshell_multiplier)
	eggshell_lower.text = "Minimum eggshell gain: " + str(Global.eggshell_lower_limit) + " eggshells/break"
	eggshell_upper.text = "Maximum eggshell gain: " + str(Global.eggshell_upper_limit) + " eggshells/break"
	apwcdr.text = "Active powerup cooldown reduction: " + str(Global.active_powerup_cdr) + " sec"
	apw_mult.text = "Active powerup multiplier: " + str(Global.active_powerup_multiplier)
	sp_up_lvl_lim.text = "Special upgrade level limit: " + str(Global.special_lvl_limit)
	





## ------------ FUNCTIONS TRIGGERED BY SIGNALS ------------

## function triggered when you press the close menu button in the top right corner of the menu

func _on_close_menu_button_pressed() -> void:
	var closeMenuButton := $CloseMenuButton
	closeMenuButton.disabled = true
	var statsMenu := $"."
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(statsMenu, "position:x", statsMenu.position.x - 750, 1)
	stats_menu_close.emit()
	await get_tree().create_timer(1).timeout
	closeMenuButton.disabled = false


## function triggered when the main script calls the UI_update function
## it updates the stats of all the labels with the new Global variables

func _on_main_stat_menu() -> void:
	set_stats()
