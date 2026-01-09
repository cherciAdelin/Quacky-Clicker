extends Node2D

@onready var ScoreLabel = $UI/Score
@onready var ClickValueLabel = $UI/Click_val
@onready var EggshellLabel = $UI/EggshellLabel
@onready var fih_active_up = $active_powerups/Fih_bucket
@onready var glass_active_up = $active_powerups/Whiskey_glass
@onready var cauldron_active_up = $active_powerups/Cauldron
@onready var elixir_active_Up = $active_powerups/Elixir

signal up_menu
var shownCurrency := 0.0
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

func _on_autoclick_menu_change() -> void:
	update_ui()

func _on_upgrade_menu_up_menu_change() -> void:
	update_ui()

func _on_egg_egg() -> void:
	update_ui()

func _on_main_menu_button_pressed() -> void:
	$UI/MainMenuButton.disabled = true
	var camera = $Camera2D
	var tint = $ColorRect
	var mainMenu = $MainMenu/Background
	cameraTween = create_tween()
	
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 1.0), 1)
	cameraTween.tween_property(camera, "position", mainMenu.global_position, 0.1)
	cameraTween.tween_property(tint, "color", Color(0.0, 0.0, 0.0, 0.0),1)
	await get_tree().create_timer(1.5).timeout
	$UI/MainMenuButton.disabled = false


func _on_up_menu_open_pressed() -> void:
	$UI/UpMenuOpen.disabled = true
	var menu = $UpgradeMenu/Control
	if(menuTween):
		menuTween.kill()
	menuTween = create_tween()
	
	menuTween.set_trans(Tween.TRANS_SINE)
	menuTween.set_ease(Tween.EASE_OUT)
	menuTween.tween_property(menu, "position:x", menu.position.x + 1500, 1)
	await get_tree().create_timer(0.5).timeout
	$UI/UpMenuOpen.disabled = false


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


func _on_autoclick_up_menu_open_pressed() -> void:
	$UI/AutoclickUpMenuOpen.disabled = true
	var menu = $autoclick_up_menu
	if(menuTween):
		menuTween.kill()
	menuTween = create_tween()
	
	menuTween.set_trans(Tween.TRANS_SINE)
	menuTween.set_ease(Tween.EASE_OUT)
	menuTween.tween_property(menu, "position:x", menu.position.x + 750, 1)
	await get_tree().create_timer(0.5).timeout
	$UI/AutoclickUpMenuOpen.disabled = false



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
