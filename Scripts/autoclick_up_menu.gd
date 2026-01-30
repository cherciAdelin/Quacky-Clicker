extends Control

## duck dialogue functon called in autoclick_up & special_up functions

## --------------- VARIABLES ---------------

## Signals that are used to communicate with other scripts whenever 
## something UI related changes or when an event that unlocks certain things in the game
## triggers
signal AutoclickMenuChange
signal DuckWeaponChange(texture: Texture2D)
signal DuckHatChange(texture: Texture2D)
signal ActivePowerupUnlock(apwu: int)
signal autoclickMenuClose
signal startAutoclicker

enum apw{FIH, WHISKEY, CAULDRON, ELIXIR}
var multiplied_upgrade_active := false
var multiplied_upgrade_value := 1.0

## variables that hold the textures for the duck accessories which are unlocked
## whenever you buy an upgrade for the first time
@onready var Menu = $Control
@onready var fishingPoleTexture = preload("res://Assets/Sprites/Duckk/Accessories/FishingPole.png")
@onready var revolverTexture = preload("res://Assets/Sprites/Duckk/Accessories/Revolver.png")
@onready var witchBroomTexture = preload("res://Assets/Sprites/Duckk/Accessories/WitchBroom.png")
@onready var wizardStaffTexture = preload("res://Assets/Sprites/Duckk/Accessories/WizardStaff.png")
@onready var strawHatTexture = preload("res://Assets/Sprites/Duckk/Hats/StrawHat.png")
@onready var cowboyHatTexture = preload("res://Assets/Sprites/Duckk/Hats/CowboyHat.png")
@onready var witchHatTexture = preload("res://Assets/Sprites/Duckk/Hats/WitchHat.png")
@onready var wizardHatTexture = preload("res://Assets/Sprites/Duckk/Hats/WizardHat.png")

## variables used to manipulate the button/menu nodes
@onready var autoclick1Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/Cost
@onready var autoclick2Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/Cost
@onready var autoclick3Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/Cost
@onready var autoclick4Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/Cost
@onready var strawHatCost = $Control/UpgradesContainer/VBoxContainer/straw_hat/Cost
@onready var cowboyHatCost = $Control/UpgradesContainer/VBoxContainer/cowboy_hat/Cost
@onready var witchHatCost = $Control/UpgradesContainer/VBoxContainer/witch_hat/Cost
@onready var wizardHatCost = $Control/UpgradesContainer/VBoxContainer/wizard_hat/Cost

@onready var autoclick1Details = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/Details
@onready var autoclick2Details = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/Details
@onready var autoclick3Details = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/Details
@onready var autoclick4Details = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/Details
@onready var strawHatDetails = $Control/UpgradesContainer/VBoxContainer/straw_hat/Details
@onready var cowboyHatDetails = $Control/UpgradesContainer/VBoxContainer/cowboy_hat/Details
@onready var witchHatDetails = $Control/UpgradesContainer/VBoxContainer/witch_hat/Details
@onready var wizardHatDetails = $Control/UpgradesContainer/VBoxContainer/wizard_hat/Details

@onready var autoclick1LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/LvL
@onready var autoclick2LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/LvL
@onready var autoclick3LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/LvL
@onready var autoclick4LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/LvL
@onready var strawHatLVL = $Control/UpgradesContainer/VBoxContainer/straw_hat/LvL
@onready var cowboyHatLVL = $Control/UpgradesContainer/VBoxContainer/cowboy_hat/LvL
@onready var witchHatLVL = $Control/UpgradesContainer/VBoxContainer/witch_hat/LvL
@onready var wizardHatLVL = $Control/UpgradesContainer/VBoxContainer/wizard_hat/LvL

@onready var autoclick1UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/UpButton
@onready var autoclick2UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/UpButton
@onready var autoclick3UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/UpButton
@onready var autoclick4UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/UpButton
@onready var strawHatUpButton = $Control/UpgradesContainer/VBoxContainer/straw_hat/UpButton
@onready var cowboyHatUpButton = $Control/UpgradesContainer/VBoxContainer/cowboy_hat/UpButton
@onready var witchHatUpButton = $Control/UpgradesContainer/VBoxContainer/witch_hat/UpButton
@onready var wizardHatUpButton = $Control/UpgradesContainer/VBoxContainer/wizard_hat/UpButton

@onready var autoclick1lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/Locked
@onready var autoclick2lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/Locked
@onready var autoclick3lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/Locked
@onready var autoclick4lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/Locked
@onready var strawHatlock = $Control/UpgradesContainer/VBoxContainer/straw_hat/Locked
@onready var cowboyHatlock = $Control/UpgradesContainer/VBoxContainer/cowboy_hat/Locked
@onready var witchHatlock = $Control/UpgradesContainer/VBoxContainer/witch_hat/Locked
@onready var wizardHatlock = $Control/UpgradesContainer/VBoxContainer/wizard_hat/Locked

@onready var bought_sfx = $BoughtSFX



##--------------- FUNCTIONS ---------------

## function used to set the autoclick upgrades to their "default" state

func set_autoclick_stats_default(upgrade: String, LvLlabel: Control, DetailsLabel: Control, UpButton: Control, CostLabel: Control, Locked: Control, isLocked: bool):
	LvLlabel.text = "LVL: " + str(Global.upgrades[upgrade]["level"])
	DetailsLabel.text = "Next autoclick up value is: " + str(Global.upgrades[upgrade]["value"])
	UpButton.disabled = false
	CostLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	Locked.visible = isLocked


## function used to set the special upgrades to their "default" state

func set_hat_stats_default(upgrade: String, LvLlabel: Control, DetailsLabel: Control, UpButton: Control, CostLabel: Control, Locked: Control, isLocked: bool, Details: String):
	LvLlabel.text = "LVL: " + str(Global.hats[upgrade]["level"])
	DetailsLabel.text = Details + str(Global.hats[upgrade]["value"])
	UpButton.disabled = false
	CostLabel.text = str(Global.hats[upgrade]["cost"]) + " eggshells"
	Locked.visible = isLocked


## function that upgrades the autoclick value
## it takes arguments related to the upgrade it is used on like:
## - the upgrade name (key from the global dictionary "upgrades")
## - the cost increase of the upgrade
## - the autoclick value increase which adds to the current value of the upgrade and ends up being the 
## next upgrade actual value
## - the level threshold which, when reached, unlocks the next upgrade
## - the upgrade which is unlocked when the threshold is reached
## - the upgrade's corresponding "hat" upgrade (special upgrade)
## - the texture of the weapon the upgrade ulocks for the duck

func autoclick_up(upgrade: String, cost_inc: int, val_inc: float, threshold: int, next_upgrade: Control, hat: Control, weapon_texture: Texture2D, dialogue: int):
	bought_sfx.play()
	Global.currency -= Global.upgrades[upgrade]["cost"]
	Global.upgrades[upgrade]["cost"] += cost_inc
	Global.upgrades[upgrade]["level"] += 1
	if(multiplied_upgrade_active):
		Global.autoclick_value += val_inc * multiplied_upgrade_value
	else:
		Global.autoclick_value += val_inc 
	Global.upgrades[upgrade]["value"] += val_inc
	if(Global.upgrades[upgrade]["level"] == 1):
		hat.visible = false
		DuckWeaponChange.emit(weapon_texture)
		Global.duck.speak(Global.text_monologue["Autoclick_up_menu"][dialogue], false)
	if(Global.upgrades[upgrade]["level"] == threshold and next_upgrade != null):
		next_upgrade.visible = false
	AutoclickMenuChange.emit()


## function that upgrades the "special" stats like: 
## active powerup cooldown reduction, eggshell minimum/maximum gain etc.
## it takes arguments related to the hat upgrades, similar to the autoclick_up() function:
## - the upgrade name (key from the global dictionary "hats")
## - the cost increase of the upgrade
## - the value increase which adds to the current value of the upgrade
## - the corresponding active powerup index value or name from the enum variable declared at the beginning of the script
## - the texture of the hat the upgrade unlocks for the duck

func special_up(upgrade: String, cost_inc: int, val_inc: float, active_up: int, hat_texture: Texture2D, dialogue: int):
	bought_sfx.play()
	Global.eggshell_currency -= Global.hats[upgrade]["cost"]
	Global.hats[upgrade]["cost"] += cost_inc
	Global.hats[upgrade]["value"] += val_inc
	Global.hats[upgrade]["level"] += 1
	var passed_value := float(Global.hats[upgrade]["value"])
	if(Global.hats[upgrade]["level"] == 1 and active_up != null):
		ActivePowerupUnlock.emit(active_up)
		DuckHatChange.emit(hat_texture)
		Global.duck.speak(Global.text_monologue["Autoclick_up_menu"][dialogue], false)
	AutoclickMenuChange.emit()
	return passed_value


## function used to display an error message on the cost label of the upgrade when you don't have enought
## money to buy the upgrade

func insufficient_funds(costLabel: Control):
	costLabel.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
	costLabel.text = "Insufficient"
	await get_tree().create_timer(2).timeout
	AutoclickMenuChange.emit()


## function used to update the labels of the autoclick upgrades like:
## - the cost of the upgrade
## - the level of the upgrade
## - the details of the upgrade (what the upgrade gives and its value)

func UI_change(upgrade: String, costLabel: Control, lvlLabel: Control, detailsLabel: Control):
	costLabel.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	costLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	lvlLabel.text = "LVL" + str(Global.upgrades[upgrade]["level"])
	detailsLabel.text = "Next autoclick up value is " + str(Global.upgrades[upgrade]["value"])


## function used to update the labels of the special upgrades exactly like the UI_change function
## but for the hats. When the special upgrade level limit threshold is reached, the function stops 
## updating the labels

func UI_change_hats(upgrade: String, costLabel: Control, lvlLabel: Control, detailsLabel: Control, txt: String):
	if(Global.hats[upgrade]["level"] == Global.special_lvl_limit):
		return
	costLabel.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	costLabel.text = str(Global.hats[upgrade]["cost"]) + "shells"
	lvlLabel.text = "LVL" + str(Global.hats[upgrade]["level"])
	detailsLabel.text = txt + str(Global.hats[upgrade]["value"])


## function that creates a +1 popup whenever you successfully buy an upgrade

func bought_popup(origin: Vector2, offset: Vector2):
	var pop := Label.new()
	var font := FontFile.new()
	
	## font details for the popup (so it doesn't have the default color, font size etc.)
	font.load_dynamic_font("res://Assets/Sprites/Fonts/Cute Dino.ttf")
	pop.text = "+1"
	pop.add_theme_font_override("font", font)
	pop.add_theme_font_size_override("font_size", 55)
	pop.add_theme_constant_override("outline_size", 7)
	pop.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	pop.add_theme_color_override("outline_color", Color(0.0, 0.0, 0.0, 1.0))
	pop.top_level = true
	pop.z_index = 3
	pop.position = origin + offset + Vector2(30, 20)
	add_child(pop)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pop, "position:y", pop.position.y - 30, 0.3)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(pop, "scale", Vector2.ZERO, 0.6)
	tween.finished.connect(pop.queue_free)





## --------------- FUNCTIONS TRIGGERED BY SIGNALS FROM OTHER SCRIPTS/NODES ---------------

## function called the moment you run the program
## it sets the default states of each individual upgrade

func _ready():
	set_autoclick_stats_default("autoclick_up1", autoclick1LVL, autoclick1Details, autoclick1UpButoon, autoclick1Cost, autoclick1lock, true)
	set_autoclick_stats_default("autoclick_up2", autoclick2LVL, autoclick2Details, autoclick2UpButoon, autoclick2Cost, autoclick2lock, true)
	set_autoclick_stats_default("autoclick_up3", autoclick3LVL, autoclick3Details, autoclick3UpButoon, autoclick3Cost, autoclick3lock, true)
	set_autoclick_stats_default("autoclick_up4", autoclick4LVL, autoclick4Details, autoclick4UpButoon, autoclick4Cost, autoclick4lock, true)
	set_hat_stats_default("straw_hat", strawHatLVL, strawHatDetails, strawHatUpButton, strawHatCost, strawHatlock, true, "Next eggshell multiplier upgrade: ")
	set_hat_stats_default("cowboy_hat", cowboyHatLVL, cowboyHatDetails, cowboyHatUpButton, cowboyHatCost, cowboyHatlock, true, "Next eggshell min/max gain upgrade: ")
	set_hat_stats_default("witch_hat", witchHatLVL, witchHatDetails, witchHatUpButton, witchHatCost, witchHatlock, true, "Next active powerup cdr upgrade: ")
	set_hat_stats_default("wizard_hat", wizardHatLVL, wizardHatDetails, wizardHatUpButton, wizardHatCost, wizardHatlock, true, "Next active powerup mult upgrade: ")


## SIGNAL FROM CloseMenu BUTTON IN THE autoclick_up_menu SCENE
## function that "closes" the menu when you press the x button in the top right corner
## it moves the menu to its initial position

func _on_close_menu_pressed() -> void:
	$Control/CloseMenu.disabled = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Menu, "position:x", Menu.position.x - 1500, 1)
	autoclickMenuClose.emit()
	await get_tree().create_timer(1.5).timeout
	$Control/CloseMenu.disabled = false


## SIGNAL FROM THE egg.gd SCRIPT
## function that triggers after the requirements for unlocking the autoclick upgrade menu 
## are met (at the moment it's when you break 5 eggs, the egg script sends this signal)

func _on_egg_autoclick_unlock() -> void:
	autoclick1lock.visible = false


## SIGNAL FROM THE multiplied_autoclicker_upgrades SIGNAL SENT FROM THE elixir_powerup SCRIPT
## function that triggers after the active powerup "elixir" has been activated
## it multiplies the autoclick values

func _on_elixir_active(active: bool, multiplier: float) -> void:
	multiplied_upgrade_active = active
	multiplied_upgrade_value = multiplier


## SIGNAL FROM THE up_menu SIGNAL SENT FROM THE main SCRIPT
## function that uses the UI functions to update the labels of all the upgrades

func _on_main_up_menu() -> void:
	UI_change("autoclick_up1", autoclick1Cost, autoclick1LVL, autoclick1Details)
	UI_change("autoclick_up2", autoclick2Cost, autoclick2LVL, autoclick2Details)
	UI_change("autoclick_up3", autoclick3Cost, autoclick3LVL, autoclick3Details)
	UI_change("autoclick_up4", autoclick4Cost, autoclick4LVL, autoclick4Details)
	UI_change_hats("straw_hat", strawHatCost, strawHatLVL, strawHatDetails, "Next eggshell multiplier upgrade: ")
	UI_change_hats("cowboy_hat", cowboyHatCost, cowboyHatLVL, cowboyHatDetails, "Next eggshell min/max gain upgrade: ")
	UI_change_hats("witch_hat", witchHatCost, witchHatLVL, witchHatDetails, "Next active powerup cdr upgrade: ")
	UI_change_hats("wizard_hat", wizardHatCost, wizardHatLVL, wizardHatDetails, "Next active powerup mult upgrade: ")





## --------------- FUNCTIONS TRIGGERED BY BUTTONS FROM THE CURRENT SCENE ---------------

## all the buttons work the same but the upgrades have different values
## each function checks to see if you have enough currency and calls the 
## appropriate functions

func _on_up_button_pressed_autoclick1() -> void:
	if(Global.currency < Global.upgrades["autoclick_up1"]["cost"]):
		insufficient_funds(autoclick1Cost)
	else:
		bought_popup(autoclick1UpButoon.global_position, Vector2(0, 0))
		autoclick_up("autoclick_up1", 250, 2, 10, autoclick2lock, strawHatlock, fishingPoleTexture, 1)
		if(Global.upgrades["autoclick_up1"]["level"] == 1):
			startAutoclicker.emit()


func _on_up_button_pressed_autoclick2() -> void:
	if(Global.currency < Global.upgrades["autoclick_up2"]["cost"]):
		insufficient_funds(autoclick2Cost)
	else:
		bought_popup(autoclick2UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up2", 700, 5, 10, autoclick3lock, cowboyHatlock, revolverTexture, 3)


func _on_up_button_pressed_autoclick3() -> void:
	if(Global.currency < Global.upgrades["autoclick_up3"]["cost"]):
		insufficient_funds(autoclick3Cost)
	else:
		bought_popup(autoclick3UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up3", 1700, 25, 10, autoclick4lock, witchHatlock, witchBroomTexture, 5)


func _on_up_button_pressed_autoclick4() -> void:
	if(Global.currency < Global.upgrades["autoclick_up4"]["cost"]):
		insufficient_funds(autoclick4Cost)
	else:
		bought_popup(autoclick4UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up4", 4000, 100, 10, null, wizardHatlock, wizardStaffTexture, 7)






func _on_up_button_pressed_straw_hat() -> void:
	if(Global.eggshell_currency < Global.hats["straw_hat"]["cost"]):
		insufficient_funds(strawHatCost)
	else:
		bought_popup(strawHatUpButton.global_position, Vector2.ZERO)
		var eggshell_mult = special_up("straw_hat", 250, 1, apw.FIH, strawHatTexture, 2)
		Global.eggshell_multiplier = eggshell_mult
		
		if(Global.hats["straw_hat"]["level"] == Global.special_lvl_limit):
			strawHatUpButton.disabled = true
			strawHatCost.text = "MAX LVL"
			strawHatDetails.text = "Eggshell multiplier value: " + str(Global.eggshell_multiplier)
			strawHatLVL.text = "LVL: " + str(Global.hats["straw_hat"]["level"])


func _on_up_button_pressed_cowboy_hat() -> void:	
	if(Global.eggshell_currency < Global.hats["cowboy_hat"]["cost"]):
		insufficient_funds(cowboyHatCost)
	else:
		bought_popup(cowboyHatUpButton.global_position, Vector2.ZERO)
		var eggshell_limitbreak = special_up("cowboy_hat", 500, 1, apw.WHISKEY, cowboyHatTexture, 4)
		Global.eggshell_lower_limit += int(eggshell_limitbreak)
		Global.eggshell_upper_limit += int(eggshell_limitbreak)
		
		if(Global.hats["cowboy_hat"]["level"] == Global.special_lvl_limit):
			cowboyHatUpButton.disabled = true
			cowboyHatCost.text = "MAX LVL"
			cowboyHatDetails.text = "Eggshell drop lower/upper limit values: " + str(Global.eggshell_lower_limit) + "/" + str(Global.eggshell_upper_limit)
			cowboyHatLVL.text = "LVL: " + str(Global.hats["cowboy_hat"]["level"])


func _on_up_button_pressed_witch_hat() -> void:
	if(Global.eggshell_currency < Global.hats["witch_hat"]["cost"]):
		insufficient_funds(witchHatCost)
	else:
		bought_popup(witchHatUpButton.global_position, Vector2.ZERO)
		var active_pw_cdr = special_up("witch_hat", 1500, 10, apw.CAULDRON, witchHatTexture, 6)
		Global.active_powerup_cdr = active_pw_cdr
		
		if(Global.hats["witch_hat"]["level"] == Global.special_lvl_limit):
			witchHatUpButton.disabled = true
			witchHatCost.text = "MAX LVL"
			witchHatDetails.text = "Active powerups cdr value: " + str(Global.active_powerup_cdr)
			witchHatLVL.text = "LVL: " + str(Global.hats["witch_hat"]["level"])


func _on_up_button_pressed_wizard_hat() -> void:
	if(Global.eggshell_currency < Global.hats["wizard_hat"]["cost"]):
		insufficient_funds(wizardHatCost)
	else:
		bought_popup(wizardHatUpButton.global_position, Vector2.ZERO)
		var active_powerup_mult = special_up("wizard_hat", 2000, 1, apw.ELIXIR, wizardHatTexture, 8)
		Global.active_powerup_multiplier = active_powerup_mult

		if(Global.hats["wizard_hat"]["level"] == Global.special_lvl_limit):
			wizardHatUpButton.disabled = true
			wizardHatCost.text = "MAX LVL"
			wizardHatDetails.text = "Active powerups multiplier value: " + str(Global.active_powerup_multiplier)
			wizardHatLVL.text = "LVL: " + str(Global.hats["wizard_hat"]["level"])
