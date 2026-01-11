extends Node2D

@onready var ScoreLabel = $UI/Score
@onready var ClickValueLabel = $UI/Click_val
@onready var EggshellLabel = $UI/EggshellLabel
@onready var fih_active_up = $active_powerups/Fih_bucket
@onready var glass_active_up = $active_powerups/Whiskey_glass
@onready var cauldron_active_up = $active_powerups/Cauldron
@onready var elixir_active_Up = $active_powerups/Elixir

signal clickMenuClose
signal duckMenuClose
signal questMenuClose
signal optionsMenuClose
signal statsMenuClose
signal up_menu
signal stat_menu
signal quest_check

var currencyTween: Tween
var cameraTween: Tween
var menuTween: Tween
enum apw{FIH, WHISKEY, CAULDRON, ELIXIR}

func _ready():
	update_ui()
	fih_active_up.visible = false
	glass_active_up.visible = false
	cauldron_active_up.visible = false
	elixir_active_Up.visible = false

func update_ui():
	ScoreLabel.text = "Money: " + str(int(Global.currency)) + "$"
	ClickValueLabel.text = "Click value: " + str(Global.click_value)
	EggshellLabel.text = "EggShells: " + str(Global.eggshell_currency)
	up_menu.emit()
	stat_menu.emit()
	quest_check.emit()

func menu_open_animation(menu: Control, xCoord: int, tween: Tween):
	if(tween):
		tween.kill()
	tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(menu, "position:x", menu.position.x + xCoord, 1)

func _on_autoclick_menu_change() -> void:
	update_ui()

func _on_upgrade_menu_up_menu_change() -> void:
	update_ui()

func _on_egg_egg() -> void:
	update_ui()


func _on_main_menu_start_pressed() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	cameraTween = create_tween()
	
	cameraTween.tween_property(camera, "position", $MainMenu/Door.global_position, 1.0)
	cameraTween.parallel().tween_property(camera, "zoom", Vector2(3,3), 1.5)
	cameraTween.parallel().tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)

	
	await get_tree().create_timer(1.5).timeout
	var tween2 = create_tween()
	
	tween2.tween_property(camera, "zoom", Vector2(1, 1), 0.1)
	tween2.parallel().tween_property(camera, "position", $MainScreen/Background.global_position, 0.1)
	tween2.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0), 1.0)


func _on_active_powerup_unlock(apwu: int) -> void:
	if(apwu == apw.FIH):
		fih_active_up.visible = true
	elif(apwu == apw.WHISKEY):
		glass_active_up.visible = true
	elif(apwu == apw.CAULDRON):
		cauldron_active_up.visible = true
	elif(apwu == apw.ELIXIR):
		elixir_active_Up.visible = true
	else:
		return

func _on_quest_complete(qNumber: int) -> void:
	match qNumber:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass

func _on_click_menu_open() -> void:
	var menu = $UpgradeMenu/Control
	menu_open_animation(menu, 1500, menuTween)

func _on_duck_menu_open() -> void:
	var menu = $autoclick_up_menu
	menu_open_animation(menu, 750, menuTween)

func _on_options_menu_open() -> void:
	var opMenu := $OptionsMenu
	opMenu.visible = true

func _on_quest_menu_open() -> void:
	var menu := $QuestMenu
	menu_open_animation(menu, 750, menuTween)

func _on_stats_menu_open() -> void:
	var menu := $StatsMenu
	menu_open_animation(menu, 750, menuTween)


func _on_up_menu_close() -> void:
	clickMenuClose.emit()

func _on_autoclick_menu_close() -> void:
	duckMenuClose.emit()

func _on_options_menu_resume() -> void:
	optionsMenuClose.emit()

func _on_options_menu_exit() -> void:
	var camera = $Camera2D
	var tint = $ColorRect
	var mainMenu = $MainMenu/Background
	cameraTween = create_tween()
	
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	cameraTween.tween_property(camera, "position", mainMenu.global_position, 0.1)
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0),1)
	optionsMenuClose.emit()

func _on_quest_menu_close() -> void:
	questMenuClose.emit()

func _on_stats_menu_close() -> void:
	statsMenuClose.emit()
