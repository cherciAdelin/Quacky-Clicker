extends Control

## signal to update the UI in the main script
signal UpMenuChange
@onready var Menu = $Control
@onready var ClickValText = $Control/UpgradesContainer/VBoxContainer/ClickVal/ClickValUpgrade

## when you press the "x" button the upgrade menu slides back to its "original" position
func _on_close_menu_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Menu, "position:x", Menu.position.x - 1500, 1)

## function that checks if you have enough currency for a click value upgrade and if:
## you dont have enought: it displays an error message and updates the ui after 2 seconds
## you have enough: it increases the cost of the next upgrade, displays a confirmation message, 
##                  increases the click value and updates the UI after 2 seconds
func _on_click_val_upgrade_pressed() -> void:
	if(Global.currency < Global.upgrades["click_up"]["cost"]):
		ClickValText.text = "Insufficient $"
		await get_tree().create_timer(2).timeout
		UpMenuChange.emit()
	else:
		Global.currency -= Global.upgrades["click_up"]["cost"]
		Global.upgrades["click_up"]["cost"] += Global.upgrades["click_up"]["cost"] + 100
		upgrade_click()
		ClickValText.text = "OK"
		await get_tree().create_timer(2).timeout
		UpMenuChange.emit()

## function that increases the "click" value and the "click upgrade" value
func upgrade_click() -> void:
	Global.click_value += Global.upgrades["click_up"]["value"]
	Global.upgrades["click_up"]["value"] += 0.1
	UpMenuChange.emit()
