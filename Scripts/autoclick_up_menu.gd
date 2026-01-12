extends Control

signal AutoclickMenuChange
signal DuckWeaponChange(texture: Texture2D)
signal DuckHatChange(texture: Texture2D)
signal ActivePowerupUnlock(apwu: int)
signal autoclickMenuClose
signal startAutoclicker
enum apw{FIH, WHISKEY, CAULDRON, ELIXIR}
var multiplied_upgrade_active := false
var multiplied_upgrade_value := 1.0
@onready var Menu = $Control
@onready var fishingPoleTexture = preload("res://Assets/Sprites/Duckk/Accessories/FishingPole.png")
@onready var revolverTexture = preload("res://Assets/Sprites/Duckk/Accessories/Revolver.png")
@onready var witchBroomTexture = preload("res://Assets/Sprites/Duckk/Accessories/WitchBroom.png")
@onready var wizardStaffTexture = preload("res://Assets/Sprites/Duckk/Accessories/WizardStaff.png")
@onready var strawHatTexture = preload("res://Assets/Sprites/Duckk/Hats/StrawHat.png")
@onready var cowboyHatTexture = preload("res://Assets/Sprites/Duckk/Hats/CowboyHat.png")
@onready var witchHatTexture = preload("res://Assets/Sprites/Duckk/Hats/WitchHat.png")
@onready var wizardHatTexture = preload("res://Assets/Sprites/Duckk/Hats/WizardHat.png")

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


func autoclick_up(upgrade: String, cost_inc: int, val_inc: float, threshold: int, next_upgrade: Control, hat: Control, weapon_texture: Texture2D):
	Global.currency -= Global.upgrades[upgrade]["cost"]
	Global.upgrades[upgrade]["cost"] += cost_inc
	Global.upgrades[upgrade]["level"] += 1
	if(multiplied_upgrade_active):
		Global.autoclick_value += Global.upgrades[upgrade]["value"] * multiplied_upgrade_value
	else:
		Global.autoclick_value += Global.upgrades[upgrade]["value"]
	Global.upgrades[upgrade]["value"] += val_inc
	if(Global.upgrades[upgrade]["level"] == 1):
		hat.visible = false
		DuckWeaponChange.emit(weapon_texture)
	if(Global.upgrades[upgrade]["level"] == threshold and next_upgrade != null):
		next_upgrade.visible = false
	AutoclickMenuChange.emit()

func special_up(upgrade: String, cost_inc: int, val_inc: float, active_up: int, hat_texture: Texture2D):
	Global.eggshell_currency -= Global.hats[upgrade]["cost"]
	Global.hats[upgrade]["cost"] += cost_inc
	Global.hats[upgrade]["value"] += val_inc
	Global.hats[upgrade]["level"] += 1
	var passed_value := float(Global.hats[upgrade]["value"])
	if(Global.hats[upgrade]["level"] == 1 and active_up != null):
		ActivePowerupUnlock.emit(active_up)
		DuckHatChange.emit(hat_texture)
	AutoclickMenuChange.emit()
	return passed_value

func insufficient_funds(costLabel: Control):
	costLabel.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
	costLabel.text = "Insufficient"
	await get_tree().create_timer(2).timeout
	AutoclickMenuChange.emit()

func UI_change(upgrade: String, costLabel: Control, lvlLabel: Control, detailsLabel: Control):
	costLabel.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	costLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	lvlLabel.text = "LVL" + str(Global.upgrades[upgrade]["level"])
	detailsLabel.text = "Next autoclick up value is " + str(Global.upgrades[upgrade]["value"])

func UI_change_hats(upgrade: String, costLabel: Control, lvlLabel: Control, detailsLabel: Control, txt: String):
	if(Global.hats[upgrade]["level"] == Global.special_lvl_limit):
		return
	costLabel.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	costLabel.text = str(Global.hats[upgrade]["cost"]) + "shells"
	lvlLabel.text = "LVL" + str(Global.hats[upgrade]["level"])
	detailsLabel.text = txt + str(Global.hats[upgrade]["value"])

func bought_popup(origin: Vector2, offset: Vector2):
	var pop := Label.new()
	var font := FontFile.new()
	
	font.load_dynamic_font("res://Assets/Sprites/Fonts/Cute Dino.ttf")
	pop.text = "+1"
	pop.add_theme_font_override("font", font)
	pop.add_theme_font_size_override("font_size", 55)
	pop.add_theme_constant_override("outline_size", 7)
	pop.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	pop.add_theme_color_override("outline_color", Color(0.0, 0.0, 0.0, 1.0))
	pop.top_level = true
	pop.position = origin + offset + Vector2(30, 20)
	add_child(pop)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pop, "position:y", pop.position.y - 30, 0.3)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(pop, "scale", Vector2.ZERO, 0.6)
	tween.finished.connect(pop.queue_free)





func _on_close_menu_pressed() -> void:
	$Control/CloseMenu.disabled = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Menu, "position:x", Menu.position.x - 1500, 1)
	autoclickMenuClose.emit()
	await get_tree().create_timer(1.5).timeout
	$Control/CloseMenu.disabled = false

func _on_egg_autoclick_unlock() -> void:
	autoclick1lock.visible = false

func _on_main_up_menu() -> void:
	UI_change("autoclick_up1", autoclick1Cost, autoclick1LVL, autoclick1Details)
	UI_change("autoclick_up2", autoclick2Cost, autoclick2LVL, autoclick2Details)
	UI_change("autoclick_up3", autoclick3Cost, autoclick3LVL, autoclick3Details)
	UI_change("autoclick_up4", autoclick4Cost, autoclick4LVL, autoclick4Details)
	UI_change_hats("straw_hat", strawHatCost, strawHatLVL, strawHatDetails, "Next eggshell multiplier upgrade: ")
	UI_change_hats("cowboy_hat", cowboyHatCost, cowboyHatLVL, cowboyHatDetails, "Next eggshell min/max gain upgrade: ")
	UI_change_hats("witch_hat", witchHatCost, witchHatLVL, witchHatDetails, "Next active powerup cdr upgrade: ")
	UI_change_hats("wizard_hat", wizardHatCost, wizardHatLVL, wizardHatDetails, "Next active powerup mult upgrade: ")







func _on_up_button_pressed_autoclick1() -> void:
	if(Global.currency < Global.upgrades["autoclick_up1"]["cost"]):
		insufficient_funds(autoclick1Cost)
	else:
		bought_popup(autoclick1UpButoon.global_position, Vector2(0, 0))
		autoclick_up("autoclick_up1", 1000, 1, 10, autoclick2lock, strawHatlock, fishingPoleTexture)
		if(Global.upgrades["autoclick_up1"]["level"] == 1):
			startAutoclicker.emit()

func _on_up_button_pressed_autoclick2() -> void:
	if(Global.currency < Global.upgrades["autoclick_up2"]["cost"]):
		insufficient_funds(autoclick2Cost)
	else:
		bought_popup(autoclick2UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up2", 2500, 2, 20, autoclick3lock, cowboyHatlock, revolverTexture)

func _on_up_button_pressed_autoclick3() -> void:
	if(Global.currency < Global.upgrades["autoclick_up3"]["cost"]):
		insufficient_funds(autoclick3Cost)
	else:
		bought_popup(autoclick3UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up3", 5000, 10, 35, autoclick4lock, witchHatlock, witchBroomTexture)

func _on_up_button_pressed_autoclick4() -> void:
	if(Global.currency < Global.upgrades["autoclick_up4"]["cost"]):
		insufficient_funds(autoclick4Cost)
	else:
		bought_popup(autoclick4UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up4", 10000, 15, 50, null, wizardHatlock, wizardStaffTexture)


func _on_up_button_pressed_straw_hat() -> void:
	if(Global.eggshell_currency < Global.hats["straw_hat"]["cost"]):
		insufficient_funds(strawHatCost)
	else:
		bought_popup(strawHatUpButton.global_position, Vector2.ZERO)
		var eggshell_mult = special_up("straw_hat", 50, 0.1, apw.FIH, strawHatTexture)
		Global.eggshell_multiplier += eggshell_mult
		
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
		var eggshell_limitbreak = special_up("cowboy_hat", 150, 1, apw.WHISKEY, cowboyHatTexture)
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
		var active_pw_cdr = special_up("witch_hat", 300, 2.5, apw.CAULDRON, witchHatTexture)
		Global.active_powerup_cdr += active_pw_cdr
		
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
		var active_powerup_mult = special_up("wizard_hat", 500, 0.1, apw.ELIXIR, wizardHatTexture)
		Global.active_powerup_multiplier += active_powerup_mult

		if(Global.hats["wizard_hat"]["level"] == Global.special_lvl_limit):
			wizardHatUpButton.disabled = true
			wizardHatCost.text = "MAX LVL"
			wizardHatDetails.text = "Active powerups multiplier value: " + str(Global.active_powerup_multiplier)
			wizardHatLVL.text = "LVL: " + str(Global.hats["wizard_hat"]["level"])

func _on_elixir_active(active: bool, multiplier: float) -> void:
	multiplied_upgrade_active = active
	multiplied_upgrade_value = multiplier
