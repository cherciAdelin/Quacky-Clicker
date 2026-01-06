extends Node2D

@onready var ScoreLabel = $UI/Score
@onready var ClickValueLabel = $UI/Click_val
@onready var EggsBrLabel = $UI/EggsBr
signal up_menu
var shownCurrency := 0.0
var currencyTween: Tween
var cameraTween: Tween
var menuTween: Tween

func _ready():
	update_ui()

func update_ui():
	animate_currency(Global.currency)
	ClickValueLabel.text = "Click value: " + str(Global.click_value)
	EggsBrLabel.text = "Eggs broken: " + str(Global.eggsBroken)
	up_menu.emit()

func animate_currency(newValue: float):	
	currencyTween = create_tween()
	currencyTween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	currencyTween.tween_property(self, "shownCurrency", newValue, 0.3)
	currencyTween.tween_method(Callable(self, "_set_shown_currency"), shownCurrency, newValue, 0.3)

func _set_shown_currency(value: float):
	shownCurrency = value
	ScoreLabel.text = "Money: " + str(int(shownCurrency)) + "$"

func _on_autoclick_menu_change() -> void:
	update_ui()

func _on_upgrade_menu_up_menu_change() -> void:
	update_ui()

func _on_egg_egg() -> void:
	update_ui()

func _on_main_menu_button_pressed() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	var mainMenu = $MainMenu/Background
	if(cameraTween):
		cameraTween.kill()
	cameraTween = create_tween()
	
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	cameraTween.tween_property(camera, "position", mainMenu.global_position, 0.1)
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0),1)


func _on_up_menu_open_pressed() -> void:
	var menu = $UpgradeMenu/Control
	if(menuTween):
		menuTween.kill()
	menuTween = create_tween()
	
	menuTween.set_trans(Tween.TRANS_SINE)
	menuTween.set_ease(Tween.EASE_OUT)
	menuTween.tween_property(menu, "position:x", menu.position.x + 1500, 1)


func _on_main_menu_start_pressed() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	if(cameraTween):
		cameraTween.kill()
	cameraTween = create_tween()
	
	cameraTween.tween_property(camera, "position", $MainMenu/Door.global_position, 1.0)
	cameraTween.parallel().tween_property(camera, "zoom", Vector2(3,3), 1.5)
	cameraTween.parallel().tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	
	await get_tree().create_timer(1.5).timeout
	var tween2 = create_tween()
	
	tween2.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
	tween2.parallel().tween_property(camera, "position", $MainScreen/Background.global_position, 0.1)
	tween2.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0), 1.0)


func _on_autoclick_up_menu_open_pressed() -> void:
	var menu = $autoclick_up_menu
	if(menuTween):
		menuTween.kill()
	menuTween = create_tween()
	
	menuTween.set_trans(Tween.TRANS_SINE)
	menuTween.set_ease(Tween.EASE_OUT)
	menuTween.tween_property(menu, "position:x", menu.position.x + 750, 1)
