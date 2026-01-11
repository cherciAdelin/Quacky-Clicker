extends Control

signal questMenuClose
signal questComplete(qNumber: int)

@onready var quest1conditionLabel := $QuestContainer/VBoxContainer/quest_1/quest_conditions
@onready var quest2conditionLabel := $QuestContainer/VBoxContainer/quest_2/quest_conditions
@onready var quest3conditionLabel := $QuestContainer/VBoxContainer/quest_3/quest_conditions
@onready var quest4conditionLabel := $QuestContainer/VBoxContainer/quest_4/quest_conditions
@onready var quest5conditionLabel := $QuestContainer/VBoxContainer/quest_5/quest_conditions
@onready var quest6conditionLabel := $QuestContainer/VBoxContainer/quest_6/quest_conditions

@onready var quest1statusLabel := $QuestContainer/VBoxContainer/quest_1/quest_status
@onready var quest2statusLabel := $QuestContainer/VBoxContainer/quest_2/quest_status
@onready var quest3statusLabel := $QuestContainer/VBoxContainer/quest_3/quest_status
@onready var quest4statusLabel := $QuestContainer/VBoxContainer/quest_4/quest_status
@onready var quest5statusLabel := $QuestContainer/VBoxContainer/quest_5/quest_status
@onready var quest6statusLabel := $QuestContainer/VBoxContainer/quest_6/quest_status

@onready var quest1progressLabel := $QuestContainer/VBoxContainer/quest_1/quest_progress
@onready var quest2progressLabel := $QuestContainer/VBoxContainer/quest_2/quest_progress
@onready var quest3progressLabel := $QuestContainer/VBoxContainer/quest_3/quest_progress
@onready var quest4progressLabel := $QuestContainer/VBoxContainer/quest_4/quest_progress
@onready var quest5progressLabel := $QuestContainer/VBoxContainer/quest_5/quest_progress
@onready var quest6progressLabel := $QuestContainer/VBoxContainer/quest_6/quest_progress

@onready var quest1button := $QuestContainer/VBoxContainer/quest_1/claim_button
@onready var quest2button := $QuestContainer/VBoxContainer/quest_2/claim_button
@onready var quest3button := $QuestContainer/VBoxContainer/quest_3/claim_button
@onready var quest4button := $QuestContainer/VBoxContainer/quest_4/claim_button
@onready var quest5button := $QuestContainer/VBoxContainer/quest_5/claim_button
@onready var quest6button := $QuestContainer/VBoxContainer/quest_6/claim_button


func _on_quest_close_button_pressed() -> void:
	var questCloseButton := $questCloseButton
	var tween := create_tween()
	var menu := $"."
	questCloseButton.disabled = true
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(menu, "position:x", menu.position.x - 750, 1)
	questMenuClose.emit()
	await get_tree().create_timer(1.5).timeout
	questCloseButton.disabled = false

func set_quest_params(cond_label: Control, prog_label: Control, status_label: Control,quest_button: Control, quest_number: int):
	var quest := "quest" + str(quest_number)
	cond_label.text = str(Global.quests[quest]["condition"])
	prog_label.text = "0/" + str(Global.quests[quest]["threshold"])
	status_label.add_theme_color_override("font_color", Color(1.0, 0.752, 0.123, 1.0))
	status_label.text = "Status: Ongoing"
	quest_button.disabled = true

func _ready():
	set_quest_params(quest1conditionLabel, quest1progressLabel, quest1statusLabel, quest1button, 1)
	set_quest_params(quest2conditionLabel, quest2progressLabel, quest2statusLabel, quest2button, 2)
	set_quest_params(quest3conditionLabel, quest3progressLabel, quest3statusLabel, quest3button, 3)
	set_quest_params(quest4conditionLabel, quest4progressLabel, quest4statusLabel, quest4button, 4)
	set_quest_params(quest5conditionLabel, quest5progressLabel, quest5statusLabel, quest5button, 5)
	set_quest_params(quest6conditionLabel, quest6progressLabel, quest6statusLabel, quest6button, 6)

func check_quest_complete(comp_value: int, quest_number: int) -> bool:
	var quest := "quest" + str(quest_number)
	if(comp_value >= Global.quests[quest]["threshold"]):
		return true
	else:
		return false

func update_values(value: int, prog_label: Control, quest_number: int):
	var quest := "quest" + str(quest_number)
	prog_label.text = str(value) + "/" + str(Global.quests[quest]["threshold"])

func set_quest_complete(prog_label: Control, status_label: Control, button: Control, quest_number: int):
	var quest := "quest" + str(quest_number)
	prog_label.text = str(Global.quests[quest]["threshold"]) + "/" + str(Global.quests[quest]["threshold"])
	status_label.add_theme_color_override("font_color", Color(0.0, 0.903, 0.0, 1.0))
	status_label.text = "Status: Completed"
	button.disabled = false


func _on_main_quest_check() -> void:
	if(check_quest_complete(Global.eggsBroken, 1) and !Global.quests["quest1"]["completed"]):
		questComplete.emit(1)
		set_quest_complete(quest1progressLabel, quest1statusLabel, quest1button, 1)
	elif(!Global.quests["quest1"]["completed"]):
		update_values(Global.eggsBroken, quest1progressLabel, 1)
	
	if(check_quest_complete(Global.click_number, 2) and !Global.quests["quest2"]["completed"]):
		questComplete.emit(2)
		set_quest_complete(quest2progressLabel, quest2statusLabel, quest2button, 2)
	elif(!Global.quests["quest2"]["completed"]):
		update_values(Global.click_number, quest2progressLabel, 2)
	
	if(check_quest_complete(int(Global.currency), 3) and !Global.quests["quest3"]["completed"]):
		questComplete.emit(3)
		set_quest_complete(quest3progressLabel, quest3statusLabel, quest3button, 3)
	elif(!Global.quests["quest3"]["completed"]):
		update_values(int(Global.currency), quest3progressLabel, 3)
	
	if(check_quest_complete(Global.eggshell_currency, 4) and !Global.quests["quest4"]["completed"]):
		questComplete.emit(4)
		set_quest_complete(quest4progressLabel, quest4statusLabel, quest4button, 4)
	elif(!Global.quests["quest4"]["completed"]):
		update_values(Global.eggshell_currency, quest4progressLabel, 4)
	
	if(check_quest_complete(int(Global.click_value), 5) and !Global.quests["quest5"]["completed"]):
		questComplete.emit(5)
		set_quest_complete(quest5progressLabel, quest5statusLabel, quest5button, 5)
	elif(!Global.quests["quest5"]["completed"]):
		update_values(int(Global.click_value), quest5progressLabel, 5)
	
	if(check_quest_complete(int(Global.autoclick_value), 6) and !Global.quests["quest6"]["completed"]):
		questComplete.emit(6)
		set_quest_complete(quest6progressLabel, quest6statusLabel, quest6button, 6)
	elif(!Global.quests["quest6"]["completed"]):
		update_values(int(Global.autoclick_value), quest6progressLabel, 6)
