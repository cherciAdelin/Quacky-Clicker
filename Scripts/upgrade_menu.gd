extends Control

## duck dialogue function called in upgrade_click function

## ------------ VARIABLES ------------

## variables used to manipulate the click upgrades

signal UpMenuChange
signal upMenuClose
var multiplied_upgrade_active := false
var multiplied_upgrade_value := 1.0

@onready var Menu = $Control
@onready var clickup1Cost = $Control/UpgradesContainer/VBoxContainer/click_up1/Cost
@onready var clickup2Cost = $Control/UpgradesContainer/VBoxContainer/click_up2/Cost
@onready var clickup3Cost = $Control/UpgradesContainer/VBoxContainer/click_up3/Cost
@onready var clickup4Cost = $Control/UpgradesContainer/VBoxContainer/click_up4/Cost
@onready var clickup5Cost = $Control/UpgradesContainer/VBoxContainer/click_up5/Cost

@onready var clickup1Details = $Control/UpgradesContainer/VBoxContainer/click_up1/Details
@onready var clickup2Details = $Control/UpgradesContainer/VBoxContainer/click_up2/Details
@onready var clickup3Details = $Control/UpgradesContainer/VBoxContainer/click_up3/Details
@onready var clickup4Details = $Control/UpgradesContainer/VBoxContainer/click_up4/Details
@onready var clickup5Details = $Control/UpgradesContainer/VBoxContainer/click_up5/Details

@onready var clickup1LvL = $Control/UpgradesContainer/VBoxContainer/click_up1/LvL
@onready var clickup2LvL = $Control/UpgradesContainer/VBoxContainer/click_up2/LvL
@onready var clickup3LvL = $Control/UpgradesContainer/VBoxContainer/click_up3/LvL
@onready var clickup4LvL = $Control/UpgradesContainer/VBoxContainer/click_up4/LvL
@onready var clickup5LvL = $Control/UpgradesContainer/VBoxContainer/click_up5/LvL

@onready var clickup1lock = $Control/UpgradesContainer/VBoxContainer/click_up1/Locked
@onready var clickup2lock = $Control/UpgradesContainer/VBoxContainer/click_up2/Locked
@onready var clickup3lock = $Control/UpgradesContainer/VBoxContainer/click_up3/Locked
@onready var clickup4lock = $Control/UpgradesContainer/VBoxContainer/click_up4/Locked
@onready var clickup5lock = $Control/UpgradesContainer/VBoxContainer/click_up5/Locked

@onready var clickUp1ButtonPos = $Control/UpgradesContainer/VBoxContainer/click_up1/UpButton
@onready var clickUp2ButtonPos = $Control/UpgradesContainer/VBoxContainer/click_up2/UpButton
@onready var clickUp3ButtonPos = $Control/UpgradesContainer/VBoxContainer/click_up3/UpButton
@onready var clickUp4ButtonPos = $Control/UpgradesContainer/VBoxContainer/click_up4/UpButton
@onready var clickUp5ButtonPos = $Control/UpgradesContainer/VBoxContainer/click_up5/UpButton





## ------------ FUNCTIONS ------------

## function that sets the upgrades to their default states

func set_upgrade_states_default(upgrade: String, LvLlabel: Control, DetailsLabel: Control, UpButton: Control, CostLabel: Control, Locked: Control, isLocked: bool):
	LvLlabel.text = "LVL" + str(Global.upgrades[upgrade]["level"])
	DetailsLabel.text = "Next click upgrade value is: " + str(Global.upgrades[upgrade]["value"])
	UpButton.disabled = false
	CostLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	Locked.visible = isLocked


## function that upgrades the click value 
## it works similar (but a little less complicated) to the autoclick_up funciton 
## from the autoclick_up_menu script

func upgrade_click(upgrade: String, cost_inc: int, val_inc: float, threshold: int, next_upgrade: Control, dialogue: int):
	Global.currency -= Global.upgrades[upgrade]["cost"]
	Global.upgrades[upgrade]["cost"] += cost_inc
	Global.upgrades[upgrade]["level"] += 1
	if(multiplied_upgrade_active):
		Global.click_value += val_inc * multiplied_upgrade_value
	else:
		Global.click_value += val_inc
	Global.upgrades[upgrade]["value"] += val_inc
	if (Global.upgrades[upgrade]["level"] == threshold and next_upgrade != null):
		next_upgrade.visible = false
		Global.duck.speak(Global.text_monologue["Click_up_menu"][dialogue], false)
	UpMenuChange.emit()


## functions that work exactly like the one from the autoclick_up_menu script

func insufficient_funds(costLabel: Control):
	costLabel.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
	costLabel.text = "Insufficient"
	await get_tree().create_timer(2).timeout
	UpMenuChange.emit()


func UI_change(upgrade: String, costLabel: Control, lvlLabel: Control, detailsLabel: Control):
	costLabel.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	costLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	lvlLabel.text = "LVL" + str(Global.upgrades[upgrade]["level"])
	detailsLabel.text = "Next click upgrade value is " + str(Global.upgrades[upgrade]["value"]) 


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
	pop.z_index = 3
	pop.position = origin + offset + Vector2(30, 20)
	add_child(pop)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pop, "position:y", pop.position.y - 30, 0.3)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(pop, "scale", Vector2.ZERO, 0.6)
	tween.finished.connect(pop.queue_free)





## ------------ FUNCTIONS TRIGGERED BY SIGNALS ------------

func _ready():
	set_upgrade_states_default("click_up", clickup1LvL, clickup1Details, clickUp1ButtonPos, clickup1Cost, clickup1lock, false)
	set_upgrade_states_default("click_up2", clickup2LvL, clickup2Details, clickUp2ButtonPos, clickup2Cost, clickup2lock, true)
	set_upgrade_states_default("click_up3", clickup3LvL, clickup3Details, clickUp3ButtonPos, clickup3Cost, clickup3lock, true)
	set_upgrade_states_default("click_up4", clickup4LvL, clickup4Details, clickUp4ButtonPos, clickup4Cost, clickup4lock, true)
	set_upgrade_states_default("click_up5", clickup5LvL, clickup5Details, clickUp5ButtonPos, clickup5Cost, clickup5lock, true)

## function triggered when you press the button in the top right corner of the menu

func _on_close_menu_pressed() -> void:
	$Control/CloseMenu.disabled = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Menu, "position:x", Menu.position.x - 1500, 1)
	upMenuClose.emit()
	await get_tree().create_timer(1.5).timeout
	$Control/CloseMenu.disabled = false


## SIGNAL TRIGGERED BY THE up_menu SIGNAL SENT BY THE main SCRIPT
## function that triggers when it gets a signal from the main script 
## it updates the click upgrades information

func _on_main_up_menu() -> void:
	UI_change("click_up", clickup1Cost, clickup1LvL, clickup1Details)
	UI_change("click_up2", clickup2Cost, clickup2LvL, clickup2Details)
	UI_change("click_up3", clickup3Cost, clickup3LvL, clickup3Details)
	UI_change("click_up4", clickup4Cost, clickup4LvL, clickup4Details)
	UI_change("click_up5", clickup5Cost, clickup5LvL, clickup5Details)


## SIGNAL TRIGGERED BY THE multiplied_upgrades SIGNAL SENT BY THE fih_bucket SCENE
## function that makes it so, when it's active, whenever you buy an upgrade, it gives
## the value multiplied

func _on_fih_bucket_active(active: bool, multiplier: float) -> void:
	multiplied_upgrade_active = active
	multiplied_upgrade_value = multiplier


## these functions work like the ones in the autoclick_up_menu
## they check if you have enough currency then call the corresponding functions
## these functions also change the cursor texture whenever you buy one upgrade for the
## first time

func _on_up_button_pressed_clickval1() -> void:
	if(Global.currency < Global.upgrades["click_up"]["cost"]):
		insufficient_funds(clickup1Cost)
	else:
		bought_popup(clickUp1ButtonPos.global_position, Vector2(0, -100))
		upgrade_click("click_up", 150, 2, 10, clickup2lock,2)
		if(Global.upgrades["click_up"]["level"] == 1):
			Global.current_cursor_texture = preload("res://Assets/Sprites/CursorSprites/toothpick_cursor.png")
			Global.duck.speak(Global.text_monologue["Click_up_menu"][1], false)

func _on_up_button_pressed_clickval2() -> void:
	if(Global.currency < Global.upgrades["click_up2"]["cost"]):
		insufficient_funds(clickup2Cost)
	else:
		bought_popup(clickUp2ButtonPos.global_position, Vector2.ZERO)
		upgrade_click("click_up2", 750, 5, 10, clickup3lock,3)
		if(Global.upgrades["click_up2"]["level"] == 1):
			Global.current_cursor_texture = preload("res://Assets/Sprites/CursorSprites/butterknife_cursor.png")


func _on_up_button_pressed_clickval3() -> void:
	if(Global.currency < Global.upgrades["click_up3"]["cost"]):
		insufficient_funds(clickup3Cost)
	else:
		bought_popup(clickUp3ButtonPos.global_position, Vector2.ZERO)
		upgrade_click("click_up3", 3500, 15, 10, clickup4lock,4)
		if(Global.upgrades["click_up3"]["level"] == 1):
			Global.current_cursor_texture = preload("res://Assets/Sprites/CursorSprites/hammer_cursor.png")



func _on_up_button_pressed_clickval4() -> void:
	if(Global.currency < Global.upgrades["click_up4"]["cost"]):
		insufficient_funds(clickup4Cost)
	else:
		bought_popup(clickUp4ButtonPos.global_position, Vector2.ZERO)
		upgrade_click("click_up4", 7800, 50, 10, clickup5lock,5)
		if(Global.upgrades["click_up4"]["level"] == 1):
			Global.current_cursor_texture = preload("res://Assets/Sprites/CursorSprites/drill_cursor.png")


func _on_up_button_pressed_clickval5() -> void:
	if(Global.currency < Global.upgrades["click_up5"]["cost"]):
		insufficient_funds(clickup5Cost)
	else:
		bought_popup(clickUp5ButtonPos.global_position, Vector2.ZERO)
		upgrade_click("click_up5", 25000, 100, 10, null, -1)
		if(Global.upgrades["click_up5"]["level"] == 1):
			Global.current_cursor_texture = preload("res://Assets/Sprites/CursorSprites/nuke_cursor.png")
