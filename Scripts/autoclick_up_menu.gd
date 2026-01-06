extends Control

signal AutoclickMenuChange
@onready var Menu = $Control

@onready var autoclick1Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/Cost
@onready var autoclick2Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/Cost
@onready var autoclick3Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/Cost
@onready var autoclick4Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/Cost
@onready var autoclick5Cost = $Control/UpgradesContainer/VBoxContainer/autoclick_up5/Cost

@onready var autoclick1LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/LvL
@onready var autoclick2LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/LvL
@onready var autoclick3LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/LvL
@onready var autoclick4LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/LvL
@onready var autoclick5LVL = $Control/UpgradesContainer/VBoxContainer/autoclick_up5/LvL

@onready var autoclick1UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/UpButton
@onready var autoclick2UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/UpButton
@onready var autoclick3UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/UpButton
@onready var autoclick4UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/UpButton
@onready var autoclick5UpButoon = $Control/UpgradesContainer/VBoxContainer/autoclick_up5/UpButton

@onready var autoclick1lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up1/Locked
@onready var autoclick2lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up2/Locked
@onready var autoclick3lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up3/Locked
@onready var autoclick4lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up4/Locked
@onready var autoclick5lock = $Control/UpgradesContainer/VBoxContainer/autoclick_up5/Locked


func _on_close_menu_pressed() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Menu, "position:x", Menu.position.x - 1500, 1)

func _on_egg_autoclick_unlock() -> void:
	autoclick1lock.visible = false
	

func autoclick_up(upgrade: String, cost_inc: int, val_inc: float, threshold: int, next_upgrade: Control):
	Global.currency -= Global.upgrades[upgrade]["cost"]
	Global.upgrades[upgrade]["cost"] += cost_inc
	Global.upgrades[upgrade]["level"] += 1
	Global.autoclick_value += Global.upgrades[upgrade]["value"]
	Global.upgrades[upgrade]["value"] += val_inc
	if(Global.upgrades[upgrade]["level"] == threshold):
		next_upgrade.visible = false
	AutoclickMenuChange.emit()

func insufficient_funds(costLabel: Control):
	costLabel.text = "Insufficient"
	await get_tree().create_timer(2).timeout
	AutoclickMenuChange.emit()

func UI_change(upgrade: String, costLabel: Control, lvlLabel: Control):
	costLabel.text = str(Global.upgrades[upgrade]["cost"]) + "$"
	lvlLabel.text = "LVL" + str(Global.upgrades[upgrade]["level"])


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


func _on_main_up_menu() -> void:
	UI_change("autoclick_up1", autoclick1Cost, autoclick1LVL)
	UI_change("autoclick_up2", autoclick2Cost, autoclick2LVL)
	UI_change("autoclick_up3", autoclick3Cost, autoclick3LVL)
	UI_change("autoclick_up4", autoclick4Cost, autoclick4LVL)
	UI_change("autoclick_up5", autoclick5Cost, autoclick5LVL)







func _on_up_button_pressed_autoclick1() -> void:
	if(Global.currency < Global.upgrades["autoclick_up1"]["cost"]):
		insufficient_funds(autoclick1Cost)
	else:
		bought_popup(autoclick1UpButoon.global_position, Vector2(0, 0))
		autoclick_up("autoclick_up1", 1000, 1, 10, autoclick2lock)

func _on_up_button_pressed_autoclick2() -> void:
	if(Global.currency < Global.upgrades["autoclick_up2"]["cost"]):
		insufficient_funds(autoclick2Cost)
	else:
		bought_popup(autoclick2UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up2", 2500, 2, 20, autoclick3lock)

func _on_up_button_pressed_autoclick3() -> void:
	if(Global.currency < Global.upgrades["autoclick_up3"]["cost"]):
		insufficient_funds(autoclick3Cost)
	else:
		bought_popup(autoclick3UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up3", 5000, 10, 35, autoclick4lock)

func _on_up_button_pressed_autoclick4() -> void:
	if(Global.currency < Global.upgrades["autoclick_up4"]["cost"]):
		insufficient_funds(autoclick4Cost)
	else:
		bought_popup(autoclick4UpButoon.global_position, Vector2.ZERO)
		autoclick_up("autoclick_up4", 10000, 15, 50, autoclick5lock)

func _on_up_button_pressed_autoclick5() -> void:
	pass # Replace with function body.
