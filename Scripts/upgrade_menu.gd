extends Control

## signal to update the UI in the main script
signal UpMenuChange
@onready var Menu = $Control
@onready var clickup1Cost = $Control/UpgradesContainer/VBoxContainer/click_up1/Cost
@onready var clickup2Cost = $Control/UpgradesContainer/VBoxContainer/click_up2/Cost
@onready var clickup3Cost = $Control/UpgradesContainer/VBoxContainer/click_up3/Cost
@onready var clickup4Cost = $Control/UpgradesContainer/VBoxContainer/click_up4/Cost
@onready var clickup5Cost = $Control/UpgradesContainer/VBoxContainer/click_up5/Cost

@onready var clickup1LvL = $Control/UpgradesContainer/VBoxContainer/click_up1/LvL
@onready var clickup2LvL = $Control/UpgradesContainer/VBoxContainer/click_up2/LvL
@onready var clickup3LvL = $Control/UpgradesContainer/VBoxContainer/click_up3/LvL
@onready var clickup4LvL = $Control/UpgradesContainer/VBoxContainer/click_up4/LvL
@onready var clickup5LvL = $Control/UpgradesContainer/VBoxContainer/click_up5/LvL

@onready var clickup2lock = $Control/UpgradesContainer/VBoxContainer/click_up2/Locked
@onready var clickup3lock = $Control/UpgradesContainer/VBoxContainer/click_up3/Locked
@onready var clickup4lock = $Control/UpgradesContainer/VBoxContainer/click_up4/Locked
@onready var clickup5lock = $Control/UpgradesContainer/VBoxContainer/click_up5/Locked

@onready var clickUp1ButtonPos = $Control/UpgradesContainer/VBoxContainer/click_up1/UpButton



func upgrade_click(upgrade: String, cost_inc: int, val_inc: float, threshold: int, next_upgrade: Control):
	Global.currency -= Global.upgrades[upgrade]["cost"]
	Global.upgrades[upgrade]["cost"] += cost_inc
	Global.upgrades[upgrade]["level"] += 1
	Global.click_value += Global.upgrades[upgrade]["value"]
	Global.upgrades[upgrade]["value"] += val_inc
	if Global.upgrades[upgrade]["level"] == threshold:
		next_upgrade.visible = false
	UpMenuChange.emit()

func insufficient_funds(costLabel: Control):
	costLabel.text = "Insufficient"
	await get_tree().create_timer(2).timeout
	UpMenuChange.emit()

func UI_change(upgrade: String, costLabel: Control, lvlLabel: Control):
	costLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	lvlLabel.text = "LVL" + str(Global.upgrades[upgrade]["level"])




func _on_close_menu_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Menu, "position:x", Menu.position.x - 1500, 1)


func _on_main_up_menu() -> void:
	UI_change("click_up", clickup1Cost, clickup1LvL)
	UI_change("click_up2", clickup2Cost, clickup2LvL)
	UI_change("click_up3", clickup3Cost, clickup3LvL)
	UI_change("click_up4", clickup4Cost, clickup4LvL)
	UI_change("click_up5", clickup5Cost, clickup5LvL)








func _on_up_button_pressed_clickval1() -> void:
	if(Global.currency < Global.upgrades["click_up"]["cost"]):
		insufficient_funds(clickup1Cost)
	else:
		upgrade_click("click_up", 100, 0.1, 1, clickup2lock)

func _on_up_button_pressed_clickval2() -> void:
	if(Global.currency < Global.upgrades["click_up2"]["cost"]):
		insufficient_funds(clickup2Cost)
	else:
		upgrade_click("click_up2", 1000, 10, 15, clickup3lock)


func _on_up_button_pressed_clickval3() -> void:
	if(Global.currency < Global.upgrades["click_up3"]["cost"]):
		insufficient_funds(clickup3Cost)
	else:
		upgrade_click("click_up3", 1500, 25, 30, clickup4lock)


func _on_up_button_pressed_clickval4() -> void:
	if(Global.currency < Global.upgrades["click_up4"]["cost"]):
		insufficient_funds(clickup4Cost)
	else:
		upgrade_click("click_up4", 2500, 50, 50, clickup5lock)


func _on_up_button_pressed_clickval5() -> void:
	pass # Replace with function body.
